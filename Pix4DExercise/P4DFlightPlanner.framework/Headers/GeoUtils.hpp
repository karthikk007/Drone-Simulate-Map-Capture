//
//  PX4DGeo.hpp
//  Pix4Dcapture
//
//  Created by Andrei Mitache on 20.05.17.
//  Copyright © 2017 pix4d. All rights reserved.
//


#pragma once

#include <vector>
#include "Coordinate2D.hpp"
#include "Rectangle.hpp"
#include "Size.hpp"
#include "CameraParameters.hpp"



namespace px4d
{
    class GeoUtils
    {
    public:
        
        /// returns direction in degrees between two coordinates
        static double heading(const Coordinate2D& from, const Coordinate2D& to);
        
        /// returns distance in meters between two coordinates
        static double distance(const Coordinate2D& from, const Coordinate2D& to);
        
        /// returns a location offset by distance in direction heading from given location
        static Coordinate2D movedLocation(const Coordinate2D& from, double heading, double distance);
        
        /// returns a list of 4 coordinates at the corners of the rectangle with inner border
        static std::vector<px4d::Coordinate2D> rectangleOutline(const Rectangle& rectangle, double border);
        
        /// returns the size of the projection on the ground from altitude, given the camera parameters
        static Size photoProjectionSize(const CameraParameters& cameraParameters, double altitude);
        
    };
}
