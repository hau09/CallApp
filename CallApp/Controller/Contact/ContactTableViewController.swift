//
//  ContactTableViewController.swift
//  CallApp
//
//  Created by hau on 4/18/21.
//

import UIKit
import FirebaseAuth
protocol UserDelegate {
    var callee: User? {set get}
    var caller: (email: String, uid: String)? {set get}
}

class ContactTableViewController: UITableViewController, UserDelegate {
    
    var caller: (email: String, uid: String)?
    var callee: User?
    private let currentUser = FirebaseAuth.Auth.auth().currentUser
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    private lazy var contacts = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let email = currentUser?.email else { return }
        guard let uid = currentUser?.uid else { return }
        caller = (email: email, uid: uid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startIndicatorActivity(viewController: self)
        fetchContacts(completion: { (results) in
            self.contacts = results
            self.activityIndicator.stopAnimating()
        })
    }
    
    func fetchContacts(completion: @escaping ([User]) -> ()) {
        FirestoreService.shared.fetchContactsFromCurrentUser(withUID: caller!.uid, returning: User.self) { (result) in
            switch result {
            case .success(let contacts):
                completion(contacts)
            case .error(let error):
                AlertServices.showAlert(self, title: "Error", message: error.localizedDescription)
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let voiceCallButton = UIButton()
        let videoCallButton = UIButton()
        voiceCallButton.addTarget(self, action: #selector(voiceCallAtion), for: .touchUpInside)
        videoCallButton.addTarget(self, action: #selector(videoCallAtion), for: .touchUpInside)
        self.callee = contacts[indexPath.row]
        AlertServices.makeCallAlert(self, voiceCallButton: voiceCallButton, videoCallButton: videoCallButton, user: callee!)
    }
    @objc func voiceCallAtion(){
        print("this is voice")
    }
    @objc func videoCallAtion(){
        let vc = UIStoryboard(name: "VideoChat", bundle: nil).instantiateViewController(withIdentifier: "MakeCallVC") as? MakeCallViewController
        vc?.delegate = self
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
            self.present(vc!, animated: true, completion: nil)
        }
    }
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
            FirestoreService.shared.deleteContact(for: contacts[indexPath.row], with: caller!.uid) { (error) in
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
