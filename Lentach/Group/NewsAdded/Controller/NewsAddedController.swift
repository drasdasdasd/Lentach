//
//  NewsAddedController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 22.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import Photos
import Moya
import SVProgressHUD
import SwiftyJSON

class NewsAddedController: UIViewController {
    
    // - UI
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var firstViewTopConstraint: NSLayoutConstraint!
    
    // - Data
    fileprivate let provider = MoyaProvider<ServerService>()
    fileprivate var medias = [MediaModel]()
    fileprivate let dispatchGroup = DispatchGroup()
    
    var taskId: String?
    var phAssets = [LocalMediaModel]()
    var neededShowKeyboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss()
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        self.sendAssets()
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
        let locationController = UIStoryboard(storyboard: .chooseLocation).instantiateInitialViewController() as! ChooseLocationController
        locationController.locationHandler = { self.update(address: $0) }
        self.navigationController?.pushViewController(locationController, animated: true)
    }
    
    func update(address: String) {
        self.addressLabel.text = address
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
        for controller in (self.navigationController?.viewControllers)! {
            if controller is FeedController {
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
}

// MARK: -
// MARK: - Handle assets method

fileprivate extension NewsAddedController {
    
    func sendAssets() {
        SVProgressHUD.show()
        for asset in self.phAssets {
            
            if let image = asset.image {
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                self.sendImage(data: imageData!)
                continue
            } else if let dataVideo = asset.videoData {
                self.sendVideo(data: dataVideo)
                continue
            }
            
            let asset = asset.phAsset
            
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            
            if let asset = asset, asset.mediaType == .image {
                manager.requestImage(for: asset, targetSize: CGSize(width: 800, height: 800), contentMode: .aspectFit, options: option, resultHandler: { (result, info) -> Void in
                    thumbnail = result!
                    let imageData = UIImageJPEGRepresentation(thumbnail, 1.0)
                    self.sendImage(data: imageData!)
                })
            } else if asset?.mediaType == .video {
                var videoData: Data!
                manager.requestAVAsset(forVideo: asset!, options: nil, resultHandler: { (avasset, audio, info) in
                    if let avassetURL = avasset as? AVURLAsset {
                        guard let video = try? Data(contentsOf: avassetURL.url) else {
                            return
                        }
                        videoData = video
                        self.sendVideo(data: videoData!)
                    }
                })
            }
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.sendNews()
        }
    }
    
}

// MARK: -
// MARK: - Collection View Configure

extension NewsAddedController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + self.phAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row >= self.phAssets.count {
            return self.plusCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            return self.imageCell(collectionView:collectionView, indexPath: indexPath)
        }
    }
    
    func plusCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.plus.rawValue,
            for: indexPath) as! PlusAddNewsCell
        return cell
    }
    
    func imageCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.media.rawValue,
            for: indexPath) as! MediaAddNewsCell
        cell.set(asset: self.phAssets[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let assetsPickerController = AssetsPickerController()

        assetsPickerController.didSelectAssets = { (assets: Array) -> () in
            
            for asset in assets {
                let model = LocalMediaModel()
                model.phAsset = asset
                self.phAssets.append(model)
            }
            
            self.collectionView.reloadData()
        }
        
        let navigationController = UINavigationController(rootViewController: assetsPickerController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

// MARK: -
// MARK: - Collection View Configure

extension NewsAddedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
    
}

// MARK: -
// MARK: - Server methods

fileprivate extension NewsAddedController {
    
    func sendNews() {
        let news = NewsModel()
        news.medias = self.medias
        news.description = self.textView.text.isEmpty ? "Описания нету" : self.textView.text
        news.userId = UserDefaultsManager().getUser()?.id ?? ""
        news.taskId = taskId
        
        let json = news.toJSON()
        
        self.provider.request(.uploadNews(news: json)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    self.dismiss()
                    SVProgressHUD.dismiss()
                } else {
                    SVProgressHUD.showError(withStatus: "Ошибка")
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "Ошибка")
            }
        }
    }
    
    func sendImage(data: Data) {
        self.dispatchGroup.enter()
        self.provider.request(.loadImage(data: data)) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(moyaResponse.data)
                self.addMedia(json: json)
                self.dispatchGroup.leave()
            case .failure(_):
                self.dispatchGroup.leave()
            }
        }
    }
    
    func sendVideo(data: Data) {
        self.dispatchGroup.enter()
        self.provider.request(.loadVideo(data: data)) { result in
            switch result {
            case let .success(moyaResponse):
                let json = JSON(moyaResponse.data)
                self.addMedia(json: json)
                self.dispatchGroup.leave()
            case .failure(_):
                self.dispatchGroup.leave()
            }
        }
    }
    
    func addMedia(json: JSON) {
        if let json = json["result"]["files"]["file"].array?.first {
            let name = json["name"].string
            let type = json["type"].string
            
            let media = MediaModel()
            media.id = name ?? ""
            
            let firstType = type?.split(separator: "/").first ?? ""
            media.type = firstType == "image" ? "img" : "video"
            
            self.medias.append(media)
        }
    }
    
}

// MARK: -
// MARK: - Constant

fileprivate extension NewsAddedController {
    
    enum Cell: String {
        case media = "MediaAddNewsCell"
        case plus = "PlusAddNewsCell"
    }
    
    func configure() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.textView.delegate = self
        self.textView.autocorrectionType = .no
        self.textView.text = "Опишите ситуацию..."
        self.textView.textColor = UIColor.lightGray
        if self.neededShowKeyboard {
            self.textView.becomeFirstResponder()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.3, animations: {
                self.firstViewTopConstraint.constant = -(keyboardHeight / 2)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.firstViewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
}

// MARK: -
// MARK: - Text view delegate

extension NewsAddedController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Опишите ситуацию..."
            textView.textColor = UIColor.lightGray
        }
    }
    
}

