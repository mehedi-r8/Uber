//
//  HomeVCMapViewExtention.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/27/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import Foundation
import MapKit

extension HomeVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation ) {
        
        
        UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
        UpdateService.instance.updateDriverLocation(withCoordinate: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let identifier = "driver"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "driverAnnotation")
            return view
        } else if let annotation = annotation as? PassengerAnnotation {
            let identifier = "driver"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "currentLocationAnnotation")
            return view
        } else if let annotation = annotation as? MKPointAnnotation{
            let identifier = "destination"
            var annotaionView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotaionView == nil {
                annotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                //annotaionView?.image = UIImage(named: "destinationAnnotation")
                annotaionView?.annotation = annotation
            }
            
            annotaionView?.image = UIImage(named: "destinationAnnotation")
            return annotaionView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        centerBtn.fadeTo(alphaValue: 1.0, withDuration: 0.2)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineRender = MKPolylineRenderer(overlay: self.route.polyline)
        lineRender.strokeColor = UIColor.green
        lineRender.lineWidth = 3
        //lineRender.lineJoin = .round
        
        return lineRender
    }
    
    func perfromSearch() {
        matchingLocation.removeAll()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = destinationTxtField.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if error != nil {
                print(error as Any)
            } else if response!.mapItems.count == 0{
                print("no result")
            } else {
                for mapItem in response!.mapItems {
                    self.matchingLocation.append(mapItem as MKMapItem)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func dropPinFor(palacemark: MKPlacemark) {
        selectedPlacemrk = palacemark
        for annotation in mapView.annotations {
            if annotation.isKind(of: MKPointAnnotation.self) {
                mapView.removeAnnotation(annotation)
            }
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = palacemark.coordinate
        mapView.addAnnotation(annotation)
        
    }
    
    func searchMapkitForResultsWithPolyLine(formapItem mapItem: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapItem
        request.transportType = MKDirectionsTransportType.any
        
        //let direction = MKDirections(request: request)
        
        let direction = MKDirections(request: request)
        
        direction.calculate { (response, error) in
            guard let response = response else {
                print("😂😂\(error.debugDescription)")
                return
            }
            
            self.route = response.routes[0]
            self.mapView.addOverlay(self.route.polyline)
            print("😝success😝")
            
        }
    }
}
