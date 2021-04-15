//
//  ActivityIndicatorView+Extension.swift
//  CallApp
//
//  Created by hau on 4/8/21.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    
    func startIndicatorActivity(viewController: UIViewController? = UIApplication.topViewController()) {
        self.frame = viewController!.view.frame
        self.center = viewController!.view.center
        viewController!.view.addSubview(self)
        self.startAnimating()
    }
}
