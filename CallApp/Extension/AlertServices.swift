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
    static func makeCallAlert(_ viewController: UIViewController) {
        let voiceCallButton = UIButton()
        voiceCallButton.setTitle("Voice", for: .normal)
        voiceCallButton.backgroundColor = .green
        voiceCallButton.layer.cornerRadius = 15
        voiceCallButton.translatesAutoresizingMaskIntoConstraints = false

        let videoCallButton = UIButton()
        videoCallButton.setTitle("Video", for: .normal)
        videoCallButton.backgroundColor = .blue
        videoCallButton.layer.cornerRadius = 15
        videoCallButton.translatesAutoresizingMaskIntoConstraints = false

        let fullnameLB = UILabel()
        fullnameLB.textAlignment = .center
        fullnameLB.font = .systemFont(ofSize: 18)
        fullnameLB.text = "Full name"
        fullnameLB.translatesAutoresizingMaskIntoConstraints = false

        let emailLB = UILabel()
        emailLB.textAlignment = .center
        emailLB.font = .systemFont(ofSize: 16)
        emailLB.text = "Email"
        emailLB.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStackview = UIStackView()
        labelStackview.alignment = .fill
        labelStackview.distribution = .fillEqually
        labelStackview.spacing = 8

        labelStackview.addArrangedSubview(fullnameLB)
        labelStackview.addArrangedSubview(emailLB)
        labelStackview.axis = .vertical

        let buttonStackview = UIStackView()
        buttonStackview.alignment = .fill
        buttonStackview.distribution = .fillEqually
        buttonStackview.spacing = 8

        buttonStackview.addArrangedSubview(voiceCallButton)
        buttonStackview.addArrangedSubview(videoCallButton)
        buttonStackview.axis = .horizontal

        let makeCallStackView = UIStackView()
        makeCallStackView.axis = .vertical
        makeCallStackView.alignment = .fill
        makeCallStackView.distribution = .fill
        makeCallStackView.spacing = 30

        makeCallStackView.addArrangedSubview(labelStackview)
        makeCallStackView.addArrangedSubview(buttonStackview)
        makeCallStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(makeCallStackView)
        makeCallStackView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 10).isActive = true
        makeCallStackView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        makeCallStackView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        makeCallStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 205).isActive = true

        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertController.alertController?.dismiss(animated: true, completion: nil)
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
}
