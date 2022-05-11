//
//  User.swift
//  ToDoFirebase
//
//  Created by Makarov_Maxim on 07.05.2022.
//

import Foundation
#warning("import Firebase")

struct User {
    let uid: String
    let email: String
    
    init(user: FIRUser) {
        self.uid = user.uid
        self.email = user.email!
        
    }
}
