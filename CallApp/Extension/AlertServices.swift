//
//  AlertServices.swift
//  CallApp
//
//  Created by hau on 4/6/21.
//

import Foundation
import UIKit

class AlertServices {
    private init() {}
    static func showAlert(_ viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.alertController?.dismiss(animated: true, completion: nil)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
