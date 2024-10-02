//
//  RoutViewController.swift
//  MapLocationAigerim
//
//  Created by Айгерим on 02.10.2024.
//

import UIKit
import MapKit
import CoreLocation


class RoutViewController: UIViewController, MKMapViewDelegate {
    var mapView2: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView2)
        setUpConstraints()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        mapView2.addGestureRecognizer(longPress)
        mapView2.delegate = self
    }
    @objc
    func longPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView2)
        let location = mapView2.convert(point, toCoordinateFrom: mapView2)
        
        if annotationSourse == nil {
            annotationSourse = MKPointAnnotation()
            annotationSourse?.coordinate = location
            annotationSourse?.title = "Source"
            mapView2.addAnnotation(annotationSourse!)
        } else {
            annotationDestination = MKPointAnnotation()
            annotationDestination?.coordinate = location
            annotationDestination?.title = "Destination"
            mapView2.addAnnotation(annotationDestination!)
        }
        
    }
    
    var annotationSourse: MKPointAnnotation?
    var annotationDestination: MKPointAnnotation?
    
    
     @objc func pushCreateRouteAction(_ sender: Any) {
        guard let annotationSourse, let annotationDestination else {
            return
        }
        
        //создать запрос
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: annotationSourse.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotationDestination.coordinate))

        //создать направление
        let direction = MKDirections(request: request)
        
        //посчитать направление
        direction.calculate { [weak self] responce, error in
            if let responce, let route = responce.routes.first {
                self?.mapView2.addOverlay(route.polyline)
                self?.mapView2.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }

    }
    
    //вывести маршрут на карту
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate(
            [mapView2.leftAnchor.constraint(equalTo: view.leftAnchor),
             mapView2.rightAnchor.constraint(equalTo: view.rightAnchor),
             mapView2.topAnchor.constraint(equalTo: view.topAnchor),
             mapView2.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
