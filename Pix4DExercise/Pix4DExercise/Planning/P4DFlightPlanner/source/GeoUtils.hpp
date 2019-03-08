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
        
        static double heading(const Coordinate2D& from, const Coordinate2D& to);
        static double distance(const Coordinate2D& from, const Coordinate2D& to);
        static Coordinate2D movedLocation(const Coordinate2D& from, double heading, double distance);
        static std::vector<px4d::Coordinate2D> getRectangleOutline(const Rectangle& rectangle, double border);
        static Size photoProjectionSize(const CameraParameters& cameraParameters, double altitude);
    };
}
