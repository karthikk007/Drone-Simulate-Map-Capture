//
//  DroneAnnotation.swift
//  Pix4DExercise
//
//  Created by Andrei Mitache on 21.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

import UIKit
import MapKit

class DroneAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

}
