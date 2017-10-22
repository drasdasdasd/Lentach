//
//  TaskController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 22.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import MapKit

class TaskController: UIViewController {

    // - UI
    @IBOutlet weak var taskMapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // - Data
    var task: TaskModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openCameraButtonAction(_ sender: Any) {
        let cameraController = UIStoryboard(storyboard: .camera).instantiateInitialViewController() as! CameraController
        cameraController.taskId = task.id
        self.navigationController?.pushViewController(cameraController, animated: true)
    }
    
}

// MARK: -
// MARK: - Configure

fileprivate extension TaskController {
    
    func configure() {
        self.titleLabel.text = self.task.title
        self.descriptionLabel.text = self.task.description
        self.priceLabel.text = "\(self.task.sum)руб."
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: task.place.lat, longitude: task.place.long)
        self.taskMapView.addAnnotation(annotation)
        
        let camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 3500, pitch: 20, heading: 20)
        self.taskMapView.setCamera(camera, animated: false)
    }
    
}


