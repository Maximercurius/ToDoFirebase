//
//  Task.swift
//  ToDoFirebase
//
//  Created by Makarov_Maxim on 07.05.2022.
//

import Foundation
#warning("import Firebase")

struct Task {
    let title: String
    let userId: String
    let ref: FIRDatabaseReference?
    var completed: Bool = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    init(snapshot: FIRSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
        
    }
    func convertToDictionary() -> Any {
        return ["title" : title, "userId" : userId, "completed" : completed]
    }
}
