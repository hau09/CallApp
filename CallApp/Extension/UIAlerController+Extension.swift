//
//  UIAlerController+Extension.swift
//  CallApp
//
//  Created by hau on 4/6/21.
//

import Foundation
import UIKit

extension UIAlertController {
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
}

