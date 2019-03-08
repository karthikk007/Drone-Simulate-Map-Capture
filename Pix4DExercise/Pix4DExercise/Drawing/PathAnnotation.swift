//
//  PathAnnotation.swift
//  Pix4DExercise
//
//  Created by Karthik Kumar on 22/04/18.
//  Copyright © 2018 pix4d. All rights reserved.
//

import Foundation
import MapKit

class PathAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
