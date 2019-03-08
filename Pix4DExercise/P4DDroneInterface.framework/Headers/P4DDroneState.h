//
//  P4DDroneState.h
//  P4DDroneInterface
//
//  Created by Andrei Mitache on 20.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef struct {
    CLLocationCoordinate2D location2D;
    double altitude;
} P4DDroneLocation;


typedef struct {
    //in degrees:
    double yaw;
    double pitch;
    double roll;
} P4DDroneOrientation;

typedef struct {
    double magnitude;
    double x;
    double y;
    double z;
} P4DDroneVelocity;

@interface P4DDroneState : NSObject

@property (nonatomic,assign) BOOL connected;
@property (nonatomic,assign) CLLocationCoordinate2D homeLocation;

@property (nonatomic,assign) P4DDroneLocation location;
@property (nonatomic,assign) P4DDroneOrientation orientation;
@property (nonatomic,assign) P4DDroneOrientation cameraOrientation;
@property (nonatomic,assign) P4DDroneVelocity velocity;

@property (nonatomic,assign) BOOL isFlying;
@property (nonatomic,assign) NSInteger missionWaypointIndex;

@end
