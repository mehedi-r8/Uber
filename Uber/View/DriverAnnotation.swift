//
//  DriverAnnotation.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/26/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class DriverAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, withkey key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
    func update(annotationPosition annotion: DriverAnnotation, withCoordinate coordinate: CLLocationCoordinate2D) {
        var location =  self.coordinate
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        
        UIView.animate(withDuration: 0.2) {
            self.coordinate = location
        }
    }
}
