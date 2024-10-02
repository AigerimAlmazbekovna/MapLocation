//
//  ViewController.swift
//  MapLocationAigerim
//
//  Created by Айгерим on 01.10.2024.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController {
    
    //22 нояб. 2021 г. — Москва — большой город. Расположение — RU:Россия, при 55°44′24.00″ северной //широты и 37°36′36.00″ восточной долготы.
    
    let locationManager = CLLocationManager()
    
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        setUpConstraints()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        //locationManager.delegate = self
        locationManager.startUpdatingLocation()
        //  locationManager.stopUpdatingLocation()
        
     
        
        
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate(
            [mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
             mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
             mapView.topAnchor.constraint(equalTo: view.topAnchor),
             mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

        override func viewDidAppear(_ animated: Bool) {
            //55,9142 северной широты и 37,8256
            let center = CLLocationCoordinate2D(latitude: 55.4424, longitude: 37.3636)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            
            addAnnotation(coordinate: center, title: "Moskow")
        }

        
        
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MyAnnotation(object: title)
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
        
    }
    

class MyAnnotation: MKPointAnnotation {
var object: String
init(object: String) {
    self.object = object
}
}


extension ViewController: MKMapViewDelegate {
func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if let myAnnotation = view.annotation as? MyAnnotation {
        print(myAnnotation.object)
    }
    //print(view.annotation?.title ?? "-")
}
}

extension ViewController: CLLocationManagerDelegate {
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
        goToCenter(location: location)
        addAnnotation(coordinate: location.coordinate, title: Date.now.formatted())
    }
}

func goToCenter(location: CLLocation) {
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
    mapView.setRegion(region, animated: true)
}
}
