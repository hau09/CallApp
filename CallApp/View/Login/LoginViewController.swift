//
//  LoginViewController.swift
//  CallApp
//
//  Created by hau on 4/6/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        guard let email = emailTF.text, email != "", let password = passwordTF.text, password != "" else {
            AlertServices.showAlert(self, title: "Missing Info", message: "Please fill in all field")
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startIndicatorActivity()
        
        DispatchQueue.global().async {
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                if let error = error {
                    activityIndicatorView.stopAnimating()
                    AlertServices.showAlert(self, title: "Login Fail", message: error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
                    UIApplication.shared.windows.first?.rootViewController = vc
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    activityIndicatorView.stopAnimating()
                    UIView.transition(with: UIApplication.shared.windows.first!, duration: 0.6, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
                
            }
        }
    }
}
