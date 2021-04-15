//
//  TextField+Extension.swift
//  CallApp
//
//  Created by hau on 4/6/21.
//

import Foundation
import UIKit

@IBDesignable
class customUITextField: UITextField {

    private func setup() {
        self.layer.cornerRadius = 15
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

