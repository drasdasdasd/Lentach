//
//  BitcoinController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class BitcoinController: UIViewController {

    @IBOutlet weak var textFieldBackgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButtonButtonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    
}

// MARK: -
// MARK: - BitcoinController

extension BitcoinController {
    
    func configure() {
        self.addShadow()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        self.textField.becomeFirstResponder()
        self.textField.autocorrectionType = .no
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            nextButtonButtonConstraint.constant = keyboardHeight
        }
    }
    
    func addShadow() {
        self.textFieldBackgroundView.backgroundColor = UIColor.white
        self.textFieldBackgroundView.layer.cornerRadius = 5
        self.textFieldBackgroundView.layer.masksToBounds = false
        self.textFieldBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.textFieldBackgroundView.layer.shadowRadius = 10
        self.textFieldBackgroundView.layer.shadowOpacity = 1
        self.textFieldBackgroundView.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
    }
    
}
