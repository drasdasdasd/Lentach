//
//  TaskCollectionViewCell.swift
//  Lentach
//
//  Created by Dzianis Baidan on 21.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import MapKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundWhiteView: UIView!
    @IBOutlet weak var taskMapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureBackground()
    }
    
    func set(task: TaskModel) {
        self.nameLabel.text = task.title
        self.priceLabel.text = "\(task.sum)руб."
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: task.place.lat, longitude: task.place.long)
        self.taskMapView.addAnnotation(annotation)
        
        let camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 3500, pitch: 20, heading: 20)
        self.taskMapView.setCamera(camera, animated: false)
    }
    
    func configureBackground() {
        self.backgroundWhiteView.backgroundColor = UIColor.white
        self.backgroundWhiteView.layer.cornerRadius = 5
        self.backgroundWhiteView.layer.masksToBounds = false
        self.backgroundWhiteView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundWhiteView.layer.shadowRadius = 10
        self.backgroundWhiteView.layer.shadowOpacity = 1
        self.backgroundWhiteView.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
    }
    
}
