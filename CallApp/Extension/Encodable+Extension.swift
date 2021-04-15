//
//  Decodable+Extention.swift
//  CallApp
//
//  Created by hau on 4/8/21.
//

import Foundation

enum MyError: Error {
    case encodingError
}

extension Encodable {
    func toJson() throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard let json = jsonObject as? [String: Any] else { throw MyError.encodingError }
        return json
    }
}
