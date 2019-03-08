//
//  P4DDroneMission.h
//  P4DDroneInterface
//
//  Created by Andrei Mitache on 20.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P4DDroneWaypoint.h"

@interface P4DDroneMission : NSObject

@property(nonatomic,strong) NSArray<P4DDroneWaypoint*>*_Nonnull waypoints;

@end
