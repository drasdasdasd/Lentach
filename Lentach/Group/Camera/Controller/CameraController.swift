//
//  CameraController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit

class CameraController: SwiftyCamViewController {
    
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    var taskId: String?
            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.captureButton.delegate = self
    }
    
    func dismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
}

// MARK: -
// MARK: - My button action methods

extension CameraController {
    
    @IBAction func textButtonAction(_ sender: Any) {
        let controller = UIStoryboard(storyboard: .newsAdded).instantiateInitialViewController() as! NewsAddedController
        controller.neededShowKeyboard = true
        controller.taskId = taskId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: -
// MARK: - Cam methods

extension CameraController: SwiftyCamViewControllerDelegate {
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        let controller = UIStoryboard(storyboard: .newsAdded).instantiateInitialViewController() as! NewsAddedController
        let model = LocalMediaModel()
        model.image = photo
        controller.phAssets.append(model)
        controller.taskId = taskId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let controller = UIStoryboard(storyboard: .newsAdded).instantiateInitialViewController() as! NewsAddedController
        let model = LocalMediaModel()
        let data = try! NSData(contentsOf: url, options: .mappedIfSafe)
        model.videoData = data as Data
        controller.taskId = taskId
        controller.phAssets.append(model)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        self.switchCamera()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        self.flashEnabled = !self.flashEnabled
        
        if self.flashEnabled == true {
            self.flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        } else {
            self.flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        }
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension CameraController {
    
    func configure() {
        self.cameraDelegate = self
        self.maximumVideoDuration = 10.0
        self.shouldUseDeviceOrientation = false
        self.allowAutoRotate = false
        self.audioEnabled = true
        self.configurePhotoButton()
    }
    
    func configurePhotoButton() {
        self.photoButton.layer.cornerRadius = 15
        self.photoButton.layer.borderWidth = 2
        self.photoButton.layer.borderColor = UIColor.white.cgColor
    }
    
}
