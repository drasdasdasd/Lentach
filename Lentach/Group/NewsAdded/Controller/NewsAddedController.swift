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

class NewsAddedController: UIViewController {
    
    // - UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    // - Data
    fileprivate let provider = MoyaProvider<ServerService>()
    fileprivate var phAssets = [PHAsset?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
    }
    
}

// MARK: -
// MARK: - Handle assets method

fileprivate extension NewsAddedController {
    
    func handleAssets() {
        for asset in self.phAssets {
            
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            
            if asset?.mediaType == .image {
                manager.requestImage(for: asset!, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
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
    }
    
}

// MARK: -
// MARK: - Collection View Configure

extension NewsAddedController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.plusCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func plusCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.plus.rawValue,
            for: indexPath) as! PlusAddNewsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let assetsPickerController = AssetsPickerController()
        
        assetsPickerController.didSelectAssets = { (assets: Array) -> () in
            self.phAssets = assets
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
    
    func sendImage(data: Data) {
        self.provider.request(.loadImage(data: data)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                } else {
                    SVProgressHUD.showError(withStatus: "Ошибка")
                }
            case .failure(_):
                SVProgressHUD.showError(withStatus: "Ошибка")
            }
        }
    }
    
    func sendVideo(data: Data) {
        self.provider.request(.loadVideo(data: data)) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
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
// MARK: - Constant

fileprivate extension NewsAddedController {
    
    enum Cell: String {
        case media = "MediaAddNewsCell"
        case plus = "PlusAddNewsCell"
    }
    
    func configure() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
}

