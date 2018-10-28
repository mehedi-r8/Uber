//
//  PassengerAnnotation.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/27/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import Foundation
import MapKit

class PassengerAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
}
