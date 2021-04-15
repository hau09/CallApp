//
//  UIApplication+Extension.swift
//  CallApp
//
//  Created by hau on 4/6/21.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
}
