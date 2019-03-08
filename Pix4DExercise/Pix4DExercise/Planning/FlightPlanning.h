//
//  FlightPlanning.h
//  Pix4DExercise
//
//  Created by Andrei Mitache on 21.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <P4DDroneInterface/P4DDroneInterface.h>


typedef struct {
    CLLocationCoordinate2D centerCoordinate;
    double rectangleWidth;
    double rectangleHeight;
    double rectangleRotation;
    double rectangleBorder;
    double flightAltitude;
    double overlapFront;
    double overlapSide;
    double cameraPitch;
} CapturePlan;


@interface FlightPlanning : NSObject

+ (P4DDroneMission*_Nonnull)createDroneMissionWithCapturePlan:(CapturePlan)capturePlan
                                             cameraParameters:(P4DCameraParameters)cameraParameters;

+ (NSMutableArray *_Nonnull)getRectanglePoints:(CapturePlan)capturePlan
                              cameraParameters:(P4DCameraParameters)cameraParameters;

@end
