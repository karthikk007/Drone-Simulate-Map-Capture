//
//  P4DGeo.cpp
//  Pix4Dcapture
//
//  Created by Andrei Mitache on 20.05.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#include "GeoUtils.hpp"
#include <cmath>


#define PX4D_PI ((double)3.14159265358979323846264338327950288)
#define degreesToRadians(x) (PX4D_PI * (x) / 180.0)
#define radiansToDegrees(x) ((x) * 180.0 / PX4D_PI)

namespace px4d
{

    double GeoUtils::heading(const Coordinate2D& from, const Coordinate2D& to)
    {
        double fLat = degreesToRadians(from.latitude);
        double fLng = degreesToRadians(from.longitude);
        double tLat = degreesToRadians(to.latitude);
        double tLng = degreesToRadians(to.longitude);
        
        double degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
        
        if (degree >= 0)
        {
            return degree;
        }
        else
        {
            return 360+degree;
        }
    }
    
    double GeoUtils::distance(const Coordinate2D& from, const Coordinate2D& to)
    {
        static const double EARTH_RADIUS_IN_METERS = 6371000.0;//6372797.560856;
        
        double latitudeArc  = degreesToRadians(from.latitude - to.latitude);
        double longitudeArc = degreesToRadians(from.longitude - to.longitude);
        double latitudeH = sin(latitudeArc * 0.5);
        latitudeH *= latitudeH;
        double lontitudeH = sin(longitudeArc * 0.5);
        lontitudeH *= lontitudeH;
        double tmp = cos(degreesToRadians(from.latitude)) * cos(degreesToRadians(to.latitude));
        double result = EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH + tmp*lontitudeH));
        if(std::isnan(result)){
            return 0;
        }
        return result;
    }
    
    
    px4d::Coordinate2D px4d::GeoUtils::movedLocation(const Coordinate2D& from, double heading, double distance)
    {
        const double distRadians = distance / 6371000.0;//(6372797.6); // earth radius in meters
        
        double lat1 = degreesToRadians(from.latitude);
        double lon1 = degreesToRadians(from.longitude);
        heading = degreesToRadians(heading);
        
        double lat2 = asin( sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(heading));
        double lon2 = lon1 + atan2( sin(heading) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2) );
        
        return Coordinate2D(radiansToDegrees(lat2), radiansToDegrees(lon2));
    }
    
    
    std::vector<Coordinate2D> GeoUtils::getRectangleOutline(const Rectangle& rectangle, double border)
    {
        Size size = rectangle.size;
        size.width -= border*2;
        size.height -= border*2;
        
        double rot = rectangle.rotation;
        
        Coordinate2D l0 = rectangle.center;
        Coordinate2D l1 = px4d::GeoUtils::movedLocation(l0, rot, size.height/2);
        Coordinate2D l2 = px4d::GeoUtils::movedLocation(l1, rot+90, size.width/2);
        Coordinate2D l3 = px4d::GeoUtils::movedLocation(l2, rot+180, size.height);
        Coordinate2D l4 = px4d::GeoUtils::movedLocation(l3, rot+270, size.width);
        Coordinate2D l5 = px4d::GeoUtils::movedLocation(l4, rot, size.height);
        
        std::vector<Coordinate2D> coords;
        coords.push_back(l2);
        coords.push_back(l3);
        coords.push_back(l4);
        coords.push_back(l5);
        
        return coords;
    }
    
    Size GeoUtils::photoProjectionSize(const CameraParameters& cameraParameters, double altitude)
    {
        const CameraParameters& cam = cameraParameters;
        double gsd = (cam.sensorWidth * altitude * 100) / (cam.focalLength * cam.imageWidth);
        double dW = (gsd * cameraParameters.imageWidth) / 100;
        double dH = (gsd * cameraParameters.imageHeight) / 100;
        
        Size size(dW, dH);
        return size;
    }

}

