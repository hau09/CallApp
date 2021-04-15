//
//  User.swift
//  CallApp
//
//  Created by hau on 4/6/21.
//

import Foundation
import UIKit

class User: Codable {
    var fullname: String
    var email: String
    var uid: String?
    
    init(fullname: String, email: String, uid: String) {
        self.fullname = fullname
        self.email = email
        self.uid = uid
    }
    convenience init(fullname: String, email: String) {
        self.init(fullname: fullname, email: email, uid: "")
    }
    
}

