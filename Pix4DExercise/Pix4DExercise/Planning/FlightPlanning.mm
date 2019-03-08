//
//  FlightPlanning.m
//  Pix4DExercise
//
//  Created by Andrei Mitache on 21.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#import "FlightPlanning.h"

#import <P4DFlightPlanner/P4DFlightPlanner.h>

/*
#import "Coordinate2D.hpp"
#import "Size.hpp"
#import "GeoUtils.hpp"
*/

@implementation FlightPlanning

+ (P4DDroneMission*_Nonnull)createDroneMissionWithCapturePlan:(CapturePlan)capturePlan
                                             cameraParameters:(P4DCameraParameters)cameraParameters
{
    // TODO: add implementation to create a mission that captures a rectangular area as decribed by the capturePlan
    
    // use px4d::GeoUtils::photoProjectionSize to get the size of the image footprint on the ground
    // this can be used to compute the distance between images (front and side) according to the required overlap
    
    // use px4d::GeoUtils::movedLocation to compute positions of successive waypoints
    
    // image rotation should be in the direction of flight
    // images will be taken rotated at the angle specified in waypoint.yaw
    
    
    
    
    
    // Example mission with waypoints on the edge of the rectangle
    
    NSMutableArray *waypoints = [NSMutableArray new];
    
    px4d::Rectangle rectangle;
    rectangle.center = px4d::Coordinate2D(capturePlan.centerCoordinate.latitude, capturePlan.centerCoordinate.longitude);
    rectangle.size.width = capturePlan.rectangleWidth;
    rectangle.size.height = capturePlan.rectangleHeight;
    rectangle.rotation = capturePlan.rectangleRotation;
    
    px4d::CameraParameters parameters;
    parameters.focalLength = cameraParameters.focalLength;
    parameters.imageHeight = cameraParameters.imageHeight;
    parameters.imageWidth = cameraParameters.imageWidth;
    parameters.sensorWidth = cameraParameters.sensorWidth;
    
    px4d::Size size = px4d::GeoUtils::photoProjectionSize(parameters, capturePlan.flightAltitude);
    double overlapFront = capturePlan.overlapFront;
    double overlapSide = capturePlan.overlapSide;
    
    printf("kk size height - %f width - %f\n", size.height, size.width);
    printf("kk overlapFront - %f overlapFront - %f\n", overlapFront, overlapSide);
    
    // get a list of coordinates describing the ractangle with inner border
    std::vector<px4d::Coordinate2D> coords = px4d::GeoUtils::rectangleOutline(rectangle, capturePlan.rectangleBorder);
    
    std::vector<px4d::Coordinate2D> coordsToFollow;
    
    
    double overlapHeight = size.height * ((1 - capturePlan.overlapFront) == 0 ? 1.0 : (1 - capturePlan.overlapFront));
    double overlapWidth = size.width * ((1 - capturePlan.overlapSide) == 0 ? 1.0 : (1 - capturePlan.overlapSide));
    
    printf("kk overlapHeight - %f overlapWidth - %f\n", overlapHeight, overlapWidth);
    
    double finalHeight = ceil(rectangle.size.height / overlapHeight);
    double finalWidth = ceil(rectangle.size.width / overlapWidth);
    
    printf("kk finalHeight - %f finalWidth - %f\n", finalHeight, finalWidth);
    printf("kk rectangle.size.height - %f rectangle.size.width - %f\n", rectangle.size.height, rectangle.size.width);
    
    
    int n = (rectangle.size.height / size.height);
    int m = (rectangle.size.width / size.width);
    
//    int overlap = n * (1.4);
    
    printf("kk height - %d width - %d\n", n, m);
    
    
    px4d::Coordinate2D currentCoord;
    double yaw = 0;
    
    printf("kk coords[0] = %f, %f\n", coords[0].latitude, coords[0].longitude);
    printf("kk coords[1] = %f, %f\n", coords[1].latitude, coords[1].longitude);
    
//    double distance = px4d::GeoUtils::distance(coords[0], coords[1]) / finalHeight;
    printf("kk distance = %f\n", px4d::GeoUtils::distance(coords[0], coords[1]));
    double hDistance = px4d::GeoUtils::distance(coords[0], coords[1]) / finalHeight;
    double wDistance = px4d::GeoUtils::distance(coords[1], coords[2]) / finalWidth;
    
    for(int i=0; i<=finalWidth; i++) {
        
        yaw = px4d::GeoUtils::heading(coords[1], coords[2]);
        
        printf("kk yaw = %f\n", yaw);
        
        if(i == 0) {
            currentCoord = coords[0];
        } else {
            currentCoord = px4d::GeoUtils::movedLocation(currentCoord, yaw, wDistance);
        }
        
        
        for(int j=0; j<=finalHeight; j++) {
            
            if(i % 2 == 0) {
                yaw = px4d::GeoUtils::heading(coords[0], coords[1]);
            } else {
                yaw = px4d::GeoUtils::heading(coords[1], coords[0]);
            }
            
            if (j != 0) {
                currentCoord = px4d::GeoUtils::movedLocation(currentCoord, yaw, hDistance);
            }
            
            
            P4DDroneOrientation orientation;
            orientation.roll = 0;
            orientation.pitch = capturePlan.cameraPitch;
            orientation.yaw = yaw;
            
            P4DDroneLocation location;
            location.location2D = CLLocationCoordinate2DMake(currentCoord.latitude, currentCoord.longitude);
            location.altitude = capturePlan.flightAltitude;
            
            P4DDroneWaypoint *waypoint = [P4DDroneWaypoint new];
            waypoint.location = location;
            waypoint.orientation = orientation;
            waypoint.takePhoto = YES;
            
            [waypoints addObject:waypoint];
            
            printf("kk currentCoord = %f, %f\n", currentCoord.latitude, currentCoord.longitude);
            
        }
    }
    
    P4DDroneMission *mission = [P4DDroneMission new];
    mission.waypoints = waypoints;
    
    return mission;
}

+ (NSMutableArray *_Nonnull)getRectanglePoints:(CapturePlan)capturePlan
                                             cameraParameters:(P4DCameraParameters)cameraParameters
{
    // TODO: add implementation to create a mission that captures a rectangular area as decribed by the capturePlan
    
    // use px4d::GeoUtils::photoProjectionSize to get the size of the image footprint on the ground
    // this can be used to compute the distance between images (front and side) according to the required overlap
    
    // use px4d::GeoUtils::movedLocation to compute positions of successive waypoints
    
    // image rotation should be in the direction of flight
    // images will be taken rotated at the angle specified in waypoint.yaw
    
    
    
    
    
    // Example mission with waypoints on the edge of the rectangle
    
    NSMutableArray *waypoints = [NSMutableArray new];
    
    px4d::Rectangle rectangle;
    rectangle.center = px4d::Coordinate2D(capturePlan.centerCoordinate.latitude, capturePlan.centerCoordinate.longitude);
    rectangle.size.width = capturePlan.rectangleWidth;
    rectangle.size.height = capturePlan.rectangleHeight;
    rectangle.rotation = capturePlan.rectangleRotation;
    
    
    // get a list of coordinates describing the ractangle with inner border
    std::vector<px4d::Coordinate2D> coords = px4d::GeoUtils::rectangleOutline(rectangle, capturePlan.rectangleBorder);
    
    
    for(int i=0; i<coords.size(); i++)
    {
        // compute yaw to be in the direction of flight
        // since coords describes the outline of the rectangle we have 2 lines, 4 waypoints, 2 directions
        
        double yaw = 0;
        if(i < 2)
        {
            yaw = px4d::GeoUtils::heading(coords[0], coords[1]);
        }
        else
        {
            yaw = px4d::GeoUtils::heading(coords[2], coords[3]);
        }
        
        P4DDroneOrientation orientation;
        orientation.roll = 0;
        orientation.pitch = capturePlan.cameraPitch;
        orientation.yaw = yaw;
        
        P4DDroneLocation location;
        location.location2D = CLLocationCoordinate2DMake(coords[i].latitude, coords[i].longitude);
        location.altitude = capturePlan.flightAltitude;
        
        P4DDroneWaypoint *waypoint = [P4DDroneWaypoint new];
        waypoint.location = location;
        waypoint.orientation = orientation;
        waypoint.takePhoto = YES;
        
        [waypoints addObject:waypoint];
    }
    
    return waypoints;
}


@end
