//
//  TasksViewController.swift
//  ToDoFirebase
//
//  Created by Makarov_Maxim on 01.05.2022.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "This is cell number \(indexPath.row)"
        cell.textLabel?.textColor = .white
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
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
