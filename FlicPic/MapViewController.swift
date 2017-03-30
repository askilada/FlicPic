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
    @IBOutlet weak var pinAnnotationView: PinAnnotationView!
    
    var selectedGroup: [FPMapPhoto]?
    var locationManager: CLLocationManager!
    var locationFirstTime = true
    var pins = [MKAnnotation]()
    var factor: Double = 100 {
        didSet {
            stepLabel.text = "\(factor)"
            self.replacePins(factor: factor)
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        factor = sender.value
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
        stepLabel.text = "\(factor)"
        stepper.value = factor
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 50000, 50000)
        
        // Do any additional setup after loading the view.
    }
    
    func loadImagesForLocation(_ location: CLLocationCoordinate2D) {
        let req = FPMapPhotoRequest(lat: location.latitude, lon: location.longitude)
        req.exec { (err, response) in
            
            if let _ = err {
                
                PKHUD.sharedHUD.contentView = PKHUDErrorView(title: "Error", subtitle: "couldn't load images")
                
                DispatchQueue.main.async {
                    PKHUD.sharedHUD.show()
                    PKHUD.sharedHUD.hide(afterDelay: 2)
                    
                }
                
                return
            }
            let response = response as! [FPMapPhoto]
            self.images = response
            

            self.replacePins(factor: self.factor)
            
            
            
            return
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("Can do segue")
        if identifier == "imageList" && self.selectedGroup == nil {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "imageList"), let dest = segue.destination as? ImageListTableViewController {
            print("Now showing table view controller")
            
            dest.images = self.selectedGroup!
            
        }
        
    }
    

}

extension MapViewController: MKMapViewDelegate {
    
    class ImageTapGesture: UITapGestureRecognizer {
        var data: [FPMapPhoto]!
    }
    
    
    func myaction(_ sender: ImageTapGesture) {
        self.selectedGroup = sender.data
        self.performSegue(withIdentifier: "imageList", sender: self)
        return
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let view = view as! MKPinAnnotationView
        if let anotation = view.annotation as? PinAnnotation {
            let tap = ImageTapGesture(target: self, action: #selector(myaction(_:)))
            tap.data = anotation.data
            view.addGestureRecognizer(tap)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "Cell") as? PinAnnotationView
        if pinView == nil {
            pinView = PinAnnotationView(annotation: annotation, reuseIdentifier: "Cell")
            pinView?.canShowCallout = true
            pinView?.animatesDrop = false
            
            let lView = UIView()
            lView.backgroundColor = .black
            lView.frame = CGRect(x: 0, y: 0, width: 20, height: pinView!.frame.height)
            
            
        }
        
        return pinView
    }
    
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
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
            }
            for (key, value) in hash {
                let location = CLLocationCoordinate2D(latitude: key.lat, longitude: key.lon)
                let point = PinAnnotation()
                point.title = "\(value.count) photos here"
                point.coordinate = location
                point.data = value
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(point)
                }
                
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Region changed")
        
        let center = mapView.region.center
        
        /*
        let centerL = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let edegeL = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        */
        self.loadImagesForLocation(center)
        
        return
        
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(userLocation.debugDescription)
        if(self.locationFirstTime) {
            mapView.region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5000, 5000)
            self.locationFirstTime = false
        }
        
        self.loadImagesForLocation(userLocation.coordinate)
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



