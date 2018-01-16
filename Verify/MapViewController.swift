//
//  MapViewController.swift
//  Verify
//
//  Created by Razvan Julian on 20/10/17.
//
//

import UIKit
import MapKit
import CoreLocation

var mapTitle = ""


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var location = CLLocation(latitude: 0, longitude: 0)
    
    var mapItem = MKMapItem()
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var completeButton: UIBarButtonItem!
    @IBAction func complete(_ sender: Any) {
        
       print(location)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        self.mapItem.openInMaps(launchOptions: launchOptions)
    
        
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPressed(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
        
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        
        
        
    }

    @objc func longPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = gestureRecognizer.location(in: map)
            
            let newCoordonate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            
            location = CLLocation(latitude: newCoordonate.latitude, longitude: newCoordonate.longitude)
            
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                
                var title = ""
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    
                   
                    
                    if let placemark = placemarks?[0] {
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare! + " "
                            
                        }
                        
                        if placemark.thoroughfare != nil {
                            
                            title += placemark.thoroughfare!
                            
                        }
                        
                    }
                    
                    
                    if let placemarks = placemarks {
                        if placemarks.count > 0 {
                            
                            let mkPlacemark = MKPlacemark(placemark: placemarks[0])
                            
                            self.mapItem = MKMapItem(placemark: mkPlacemark)
                            
                            self.mapItem.name = title
                            
                        }
                    }
                    
                    
                    
                    
                }
                
                
                if title == "" {
                    
                    title = "Added \(NSDate())"
                    
                }
                
                mapTitle = title
                
                self.map.removeAnnotations(self.map.annotations)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordonate
                
                annotation.title = title
                
                
                self.map.addAnnotation(annotation)
                
                places.removeAll()
                
                places.append(["name": title, "lat": String(newCoordonate.latitude), "lon": String(newCoordonate.longitude)])
                
                print(places)
                
            })
            
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)

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
