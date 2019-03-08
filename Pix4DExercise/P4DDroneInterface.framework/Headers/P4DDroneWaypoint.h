//
//  P4DDroneWaypoint.h
//  P4DDroneInterface
//
//  Created by Andrei Mitache on 20.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P4DDroneState.h"

@interface P4DDroneWaypoint : NSObject

@property(nonatomic,assign) P4DDroneLocation location;
@property(nonatomic,assign) P4DDroneOrientation orientation;

@property(nonatomic,assign) BOOL takePhoto;
@property(nonatomic,assign) BOOL lineStart;
@property(nonatomic,assign) BOOL lineEnd;

@end
