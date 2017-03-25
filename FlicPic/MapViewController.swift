//
//  MApViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 25/03/17.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit
import MapKit
import FPCore
import PKHUD

class MapViewController: UIViewController {
    
    typealias ImageHash = Dictionary<MapGroup, [FPMapPhoto]>
    var images: [FPMapPhoto]?
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var locationManager: CLLocationManager!
    var locationFirstTime = true
    var pins = [MKAnnotation]()
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        self.replacePins(factor: sender.value)
        stepLabel.text = "\(stepper.value)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestWhenInUseAuthorization()
            
            
        } else {
            print("Location service not enabled")
        }
        stepLabel.text = "\(stepper.value)"
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 50000, 50000)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate {
    
    func replacePins(factor groupFactor: Double) {
        if let images = self.images {
            
            var hash = ImageHash()
            for photo in images {
                let lat = ( photo.lat * groupFactor ).rounded() / groupFactor
                let lon = ( photo.lon * groupFactor ).rounded() / groupFactor
                let mapGroup = MapGroup(lat: lat, lon: lon)
                
                if hash[mapGroup] == nil {
                    hash[mapGroup] = []
                }
                hash[mapGroup]!.append(photo)
            }
            
            mapView.removeAnnotations(mapView.annotations)
            for (key, value) in hash {
                let location = CLLocationCoordinate2D(latitude: key.lat, longitude: key.lon)
                let point = MKPointAnnotation()
                point.title = "\(value.count) photos here"
                point.coordinate = location
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(point)
                }
                
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Region changed")
        
        let span = mapView.region.span
        let center = mapView.region.center
        
        let centerL = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let edegeL = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        
        let dest = centerL.distance(from: edegeL)
        
        return
        
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(userLocation.debugDescription)
        if(self.locationFirstTime) {
            mapView.region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5000, 5000)
            self.locationFirstTime = false
        }
        let req = FPMapPhotoRequest(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
        req.exec { (err, response) in
            
            if let err = err {
                
                PKHUD.sharedHUD.contentView = PKHUDErrorView(title: "Error", subtitle: "couldn't load images")
                
                DispatchQueue.main.async {
                    PKHUD.sharedHUD.show()
                    PKHUD.sharedHUD.hide(afterDelay: 2)
                    
                }
                
                return
            }
            let response = response as! [FPMapPhoto]
            self.images = response
            
            let groupFactor = 100.0
            self.replacePins(factor: groupFactor)
            
            
            
            return
        }
    }
}

class MapGroup: Hashable, Equatable {
    var lat: Double
    var lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    var hashValue: Int {
        get {
            return "\(lat),\(lon)".hashValue
        }
    }
    
    static func ==(left: MapGroup, right: MapGroup) -> Bool {
        return left.hashValue == right.hashValue
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.locationFirstTime {
            
            let region = MKCoordinateRegionMakeWithDistance(locations.last!.coordinate, 5000, 5000)
            
            mapView.region = region
            
            
        }
    }
    
    
}
