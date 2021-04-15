//
//  AddContactTableViewCell.swift
//  CallApp
//
//  Created by hau on 4/13/21.
//

import UIKit
import FirebaseAuth

class AddContactTableViewCell: UITableViewCell {
    @IBOutlet weak var fullnameLB: UILabel!
    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var addToContactsTapped: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var user: User! {
        didSet {
            fullnameLB.text = user.fullname
            emailLB.text = user.email
            DispatchQueue.global().async {
                FirestoreService.shared.isContainInContacts(for: self.user, inCurrentUserUID: FirebaseAuth.Auth.auth().currentUser!.uid) { (isContain, error) in
                    if error != nil {
                        AlertServices.showAlert(UIApplication.topViewController()!, title: "Error", message: error!.localizedDescription)
                    }
                    if !isContain {
                        DispatchQueue.main.async {
                            self.addToContactsTapped.isEnabled = true
                            self.addToContactsTapped.alpha = 1
                        }
                    }
                }
            }
        }
    }
    @IBAction func addToContactsTapped(_ sender: Any) {
        guard let user = user else { return }
        FirestoreService.shared.isContainInContacts(for: user, inCurrentUserUID: FirebaseAuth.Auth.auth().currentUser!.uid) { (isContain, error) in
            if !isContain {
                if error != nil{
                    AlertServices.showAlert(UIApplication.topViewController()!, title: "Error", message: error!.localizedDescription)
                }
                FirestoreService.shared.addContact(contact: user, withUID: FirebaseAuth.Auth.auth().currentUser!.uid) { (error) in
                    if error != nil {
                        AlertServices.showAlert(UIApplication.topViewController()!, title: "Error", message: error!.localizedDescription)
                    }
                }
            }
        }
        self.addToContactsTapped.isEnabled = false
        self.addToContactsTapped.alpha = 0.25
    }
    
}
