//
//  ContactTableViewController.swift
//  CallApp
//
//  Created by hau on 4/18/21.
//

import UIKit
import FirebaseAuth

class ContactTableViewController: UITableViewController {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var contacts = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    fileprivate let UID = FirebaseAuth.Auth.auth().currentUser!.uid

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startIndicatorActivity(viewController: self)
        fetchContacts(completion: { (results) in
            self.contacts = results
            self.activityIndicator.stopAnimating()
        })
    }
    
    func fetchContacts(completion: @escaping ([User]) -> ()) {
        FirestoreService.shared.fetchContactsFromCurrentUser(withUID: UID, returning: User.self) { (result) in
            switch result {
            case .success(let contacts):
                completion(contacts)
            case .error(let error):
                AlertServices.showAlert(self, title: "Error", message: error.localizedDescription)
            }
        }
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.contacts.isEmpty {
            self.tableView.setEmptyData()
        }else{
            self.tableView.backgroundView = nil
        }
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactTableViewCell
        cell.contact = contacts[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FirestoreService.shared.deleteContact(for: contacts[indexPath.row], with: UID) { (error) in
                if let error = error {
                    AlertServices.showAlert(self, title: "Error", message: error.localizedDescription)
                }
            }
            self.contacts.remove(at: indexPath.row)
        }
    }
}
extension UITableView {
    func setEmptyData() {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
                noDataLabel.text          = "No data available"
                noDataLabel.textColor     = UIColor.gray
                noDataLabel.textAlignment = .center
                self.backgroundView  = noDataLabel
    }
}
