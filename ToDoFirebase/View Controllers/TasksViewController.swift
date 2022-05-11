//
//  TasksViewController.swift
//  ToDoFirebase
//
//  Created by Makarov_Maxim on 01.05.2022.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: User!
    var ref: FIRDatabaseReference!
    var tasks = Array<Task>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        user = User(user: currentUser)
        ref = FIRDatabase.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value, with:  { [weak self] (snapshot) in
            var _tasks = Array<Task>()
            
            for item in snapshot.children {
                let task = Task(snapshot: item as! FIRDataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .clear
        let task = tasks[indexPath.row]
        cell.textLabel?.textColor = .white
        let taskTitle = task.title
        let isCompleted = task.completed
        cell.textLabel?.text = taskTitle
        toggleCompletion(cell, isCompleted: isCompleted)

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) -> Bool {
        if editingStyle == .delete {
            let task = task[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = task[indexPath.row]
        let isCompleted = !task.completed
        
        toggleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValue(["completed" : isCompleted])
    }
    
    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Task", message: "Add New Task", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
            //let task
            //taskRef
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth().signout()
        } catch {
            print (error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
}

}
