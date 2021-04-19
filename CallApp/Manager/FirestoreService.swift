//
//  FirestoreService.swift
//  CallApp
//
//  Created by hau on 4/7/21.
//

import Foundation
import Firebase

class FirestoreService {
    public enum FetchResult<T> {
        case success(response: T)
        case error(error: Error)
    }
    public enum FetchResults<T> {
        case success(response: [T])
        case error(error: Error)
    }

    public enum FetchResultsByAlphabet<T> {
        case success(response: [T])
        case error(error: Error)
    }
    
    private init (){}
    static let shared = FirestoreService()
    
    
    private func reference(to collection: FirestoreCollectionRef) -> CollectionReference {
        return Firestore.firestore().collection(collection.rawValue)
    }
    private func referenceUserSubCollection(to subCollection: FirestoreCollectionRef, userDocID ID: String) -> CollectionReference {
        Firestore.firestore().collection("users").document(ID).collection(subCollection.rawValue)
    }
    
    func createUser(user: User, inColecttion: FirestoreCollectionRef, completion: @escaping (Error?) -> ()) {
        do {
            let jsonUser = try user.toJson(excluding: ["id"])
            reference(to: .users).addDocument(data: jsonUser)
        } catch  {
            completion(error)
        }
    }
    func addContact<T: Encodable>(user: T, withUserID UID: String, completion: @escaping (Error?) -> ()) {
        reference(to: .users).whereField("uid", isEqualTo: UID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(error)
            }
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                do {
                    let json = try user.toJson(excluding: ["uid","id"])
                    self.referenceUserSubCollection(to: .contacts, userDocID: document.documentID).addDocument(data: json)
                } catch  {
                    completion(error)
                }
            }
        }
       
    }
    func fetchContactsFromCurrentUser<T: Decodable>(withUID UID: String, returning objectType: T.Type, completion: @escaping (_ result: FetchResults<T>) -> ()) {
        reference(to: .users).whereField("uid", isEqualTo: UID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(FetchResults.error(error: error))
            }
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                self.referenceUserSubCollection(to: .contacts, userDocID: document.documentID).getDocuments { (snapshot, error) in
                    
                    if let error = error {
                        completion(FetchResults.error(error: error))
                    }
                    guard let snapshot = snapshot else {return}
                    do {
                        var contacts = [T]()
                        for document in snapshot.documents {
                            let object = try document.decode(as: objectType)
                            contacts.append(object)
                        }
                        completion(FetchResults.success(response: contacts))
                    }catch{
                        completion(FetchResults.error(error: error))
                    }
                }
            }
        }
    }
    
    private func fetchAllUser<T: Decodable>(returnObjectType: T.Type, completion: @escaping  (_ result: FetchResults<T>) -> ()) {
        reference(to: .users).getDocuments { (snapshot, error) in
            if let error = error {
                completion(FetchResults.error(error: error))
            }
            do{
                var users = [T]()
                for document in snapshot!.documents {
                    let object  = try document.decode(as: returnObjectType)
                    users.append(object)
                }
                completion(FetchResults.success(response: users))
            } catch {
                completion(FetchResults.error(error: error))
            }
        }
    }
    
    func fetchFilteredResults(with emailSearchText: String?, completion: @escaping (FetchResults<User>) -> ()) {
        fetchAllUser(returnObjectType: User.self) { (result) in
            switch result {
            case .success(let users):
                let filteredUsers = users.filter { (user) -> Bool in
                    guard let textSearch = emailSearchText, textSearch.count > 2 else { return false }
                    return user.email.lowercased().contains(textSearch.lowercased()) || user.fullname.replacingOccurrences(of: " ", with: "").lowercased().contains(textSearch.replacingOccurrences(of: " ", with: "").lowercased())
                }
                completion(FetchResults.success(response: filteredUsers))
            case .error(error: let error):
                completion(FetchResults.error(error: error))
            }
        }
    }
    func isContainInContacts(for user: User, inCurrentUserUID UID: String,comletion: @escaping (Bool, Error?) -> ()) {
        FirestoreService.shared.fetchContactsFromCurrentUser(withUID: UID, returning: User.self) { (result) in
            switch result {
            case .success(response: let contacts):
                let isContained = contacts.contains { (result) -> Bool in
                    if result.email == user.email {
                        return true
                    }else{
                        return false
                    }
                }
                comletion(isContained, nil)
            case .error(error: let error):
                comletion(false, error)
            }
        }
    }
    
    func deleteContact<T: Encodable & Identifier>(for objectDelete: T, with UserID: String, completion: @escaping (Error?) -> ()) {
        reference(to: .users).whereField("uid", isEqualTo: UserID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(error)
            }
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                guard let id = objectDelete.id else { return }
                self.referenceUserSubCollection(to: .contacts, userDocID: document.documentID).document(id).delete()
            }
        }
    }
}
