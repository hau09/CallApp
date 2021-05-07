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
    override func viewWillAppear(_ animated: Bool) {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            setRootViewController(identifier: "MainTabBar")
        }
    }

    @IBAction func unwind(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        guard let email = emailTF.text, email != "", let password = passwordTF.text, password != "" else {
            AlertServices.showAlert(self, title: "Missing Info", message: "Please fill in all field")
            return
        }
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.startIndicatorActivity()
        DispatchQueue.global().async {
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    activityIndicatorView.stopAnimating()
                    AlertServices.showAlert(self, title: "Login Fail", message: error.localizedDescription)
                }else{
                DispatchQueue.main.async {
                    activityIndicatorView.stopAnimating()
                    self.setRootViewController(identifier: "MainTabBar")
                }
                }
            }
        }
    }
}
extension UIViewController {
    func setRootViewController(identifier: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        UIView.transition(with: UIApplication.shared.windows.first!, duration: 0.6, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
