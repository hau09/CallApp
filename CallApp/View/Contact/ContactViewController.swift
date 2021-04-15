//
//  ContactViewController.swift
//  CallApp
//
//  Created by hau on 4/8/21.
//

import UIKit
import FirebaseAuth

class ContactViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    fileprivate var contacts = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startIndicatorActivity(viewController: self)
        DispatchQueue.global().async {
            self.fetchContacts(completion: { (results) in
                self.contacts = results
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                if self.contacts.count == 0 {
                    self.tableView.setEmptyView()
                }
            })
        }
    }
    
    func fetchContacts(completion: @escaping ([User]) -> ()) {
        FirestoreService.shared.fetchContactsFromCurrentUser(withUID: FirebaseAuth.Auth.auth().currentUser!.uid, returning: User.self) { (result) in
            switch result {
            case .success(let contacts):
                completion(contacts)
            case .error(let error):
                AlertServices.showAlert(self, title: "Error", message: error.localizedDescription)
            }
        }
    }
}
extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactTableViewCell
        cell.contact = contacts[indexPath.row]
        return cell
    }
}
extension ContactViewController: UITableViewDelegate {
    
}
extension UITableView {
    func setEmptyView() {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
                noDataLabel.text          = "No data available"
                noDataLabel.textColor     = UIColor.gray
                noDataLabel.textAlignment = .center
                self.backgroundView  = noDataLabel
    }
}
