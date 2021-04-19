//
//  User.swift
//  CallApp
//
//  Created by hau on 4/6/21.
//

import Foundation
import UIKit

protocol Identifier {
    var id : String? { get set}
}
class User: Codable, Identifier {
    var fullname: String
    var email: String
    var uid: String? = nil
    var id: String? = nil
    
    init(fullname: String, email: String, uid: String) {
        self.fullname = fullname
        self.email = email
        self.uid = uid
    }
}

