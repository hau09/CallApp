//
//  DocumentSnapshot.swift
//  CallApp
//
//  Created by hau on 4/8/21.
//

import Foundation
import Firebase

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingID: Bool = true) throws -> T {
        var documentJson = data()!
        if includingID {
            documentJson["id"] = documentID
        }
        let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObject
    }
}
