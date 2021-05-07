//
//  ProfileViewController.swift
//  CallApp
//
//  Created by hau on 4/23/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func singOutTapped(_ sender: Any) {
        
            let alert = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Signout", style: .default, handler: { (_) in
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    self.setRootViewController(identifier: "LoginVC")
                } catch {
                    AlertServices.showAlert(self, title: "Error", message: error.localizedDescription)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
