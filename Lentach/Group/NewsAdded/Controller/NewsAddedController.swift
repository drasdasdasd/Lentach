//
//  NewsAddedController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 22.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class NewsAddedController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        CameraHandler(delegate_: self).getPhotoLibraryOn(self, canEdit: true)
    }

}

// MARK: -
// MARK: - Camera delegate

extension NewsAddedController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as UIImage {
            picker.dismiss(animated: true, completion: nil)
        } else if let image = info[UIImagePickerControllerMediaURL] as UIImage {
            picker.dismiss(animated: true, completion: nil)
        }

        
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

