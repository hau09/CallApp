//
//  SignupViewController.swift
//  CallApp
//
//  Created by hau on 4/6/21.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var retryPasswordTF: UITextField!
    var fullname: String {
        return firstnameTF.text! + " " + lastnameTF.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signUpTapped(_ sender: Any) {
        guard let firstname = firstnameTF.text, firstname != "",
              let lastname = lastnameTF.text, lastname != "",
              let email = emailTF.text, email != "",
              let password = passwordTF.text, password != "",
              let retryPassword = retryPasswordTF.text, retryPassword != "" else {
            AlertServices.showAlert(self, title: "Missing Info", message: "Please fill in all fields")
            return
        }
        if !isValidEmail(email) {
            AlertServices.showAlert(self, title: "Invalid email", message: "Email is badly formatted")
            return
        }
        if  !isValidPassword(password){
            AlertServices.showAlert(self, title: "Invalid Password", message: "Make sure your password at least 8 character, contains special character and number")
            return
        }
        if password != retryPassword {
            AlertServices.showAlert(self, title: "Password invalid", message: "Password is incorect")
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.frame
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        DispatchQueue.global().async {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        activityIndicatorView.stopAnimating()
                    }
                    AlertServices.showAlert(self, title: "Error", message: error.localizedDescription)
                    return
                }
                let user = User(fullname: firstname + " " + lastname, email: email, uid: result!.user.uid)
                FirestoreService.shared.createUser(user: user, inColecttion: .users) { (error) in
                    guard let error = error else { return }
                    AlertServices.showAlert(self, title: "Error", message: error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    activityIndicatorView.stopAnimating()
                }
            }

        }
    }
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
