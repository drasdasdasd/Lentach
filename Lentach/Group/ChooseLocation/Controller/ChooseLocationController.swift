//
//  ChooseLocationController.swift
//  Lentach
//
//  Created by Dzianis Baidan on 22.10.17.
//  Copyright © 2017 Dzianis Baidan. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD

class ChooseLocationController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationHandler: ((_ address: String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        SVProgressHUD.show()
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        DispatchQueue.global().async { [weak self] in
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location2, completionHandler: { [weak self] (placemarks, error) in
                DispatchQueue.main.async { [weak self] in
                    SVProgressHUD.dismiss()
                    let placeMark = placemarks?.first
                    if let locationName = placeMark?.addressDictionary?["Name"] as? NSString {
                        let address = locationName
                        self?.locationHandler(address as String)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
}
