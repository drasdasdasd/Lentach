//
//  EntryController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import VK_ios_sdk
import SVProgressHUD
import Moya
import SwiftyJSON

class EntryController: UIViewController {
    
    fileprivate let provider = MoyaProvider<ServerService>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func vkLoginButtonAction(_ sender: Any) {
        let sdkInstnace = VKSdk.initialize(withAppId: "6228781")
        sdkInstnace?.register(self)
        sdkInstnace?.uiDelegate = self
        let permissions = ["photos", "offline", "email", "photo_50"]
        VKSdk.wakeUpSession(permissions) { [weak self] (state, error) in
            if state == .authorized {
                self?.sendToken(token: VKSdk.accessToken().accessToken)
            } else {
                VKSdk.authorize(permissions)
            }
        }
    }
    
    @IBAction func anonimButtonAction(_ sender: Any) {
    }
    
}

// MARK: -
// MARK: - Server methods

fileprivate extension EntryController {
    
    func sendToken(token: String) {
        self.provider.request(.vkLogin(token: token)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    let json = JSON(moyaResponse.data).object
                    print(json)
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
// MARK: - VK Delegates

extension EntryController: VKSdkDelegate, VKSdkUIDelegate {
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            self.sendToken(token: result.token.accessToken)
        }
    }
        
    func vkSdkUserAuthorizationFailed() {
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkWillDismiss(_ controller: UIViewController!) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
    }
    
}
