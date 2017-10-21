//
//  BitcoinController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD

class BitcoinController: UIViewController {

    // - UI
    @IBOutlet weak var textFieldBackgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButtonButtonConstraint: NSLayoutConstraint!
    
    // - Data
    fileprivate let provider = MoyaProvider<ServerService>()
    var userId: String!
    var accessToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        self.pushFeed()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        self.sendBitcoin(bitcoin: textField.text ?? "")
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: -
// MARK: - Server methods

fileprivate extension BitcoinController {
    
    func sendBitcoin(bitcoin: String) {
        SVProgressHUD.show()
        self.provider.request(.setWallet(userId: self.userId, bitcoin: bitcoin, token: self.accessToken)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    self.pushFeed()
                    SVProgressHUD.dismiss()
                } else {
                    SVProgressHUD.showError(withStatus: "Ошибка")
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "Ошибка")
            }
        }
    }
    
}

// MARK: -
// MARK: - Push

fileprivate extension BitcoinController {
   
    func pushFeed() {
        let controller = UIStoryboard(storyboard: .feed).instantiateInitialViewController()
        self.navigationController?.pushViewController(controller!, animated: true)
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
