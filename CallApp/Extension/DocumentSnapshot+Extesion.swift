//
//  DocumentSnapshot.swift
//  CallApp
//
//  Created by hau on 4/8/21.
//

import Foundation
import Firebase

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type) throws -> T {
        let documentJson = data()!
        let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObject
    }
}
