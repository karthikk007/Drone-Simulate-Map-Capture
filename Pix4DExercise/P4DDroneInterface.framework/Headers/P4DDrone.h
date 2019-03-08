//
//  P4DDrone.h
//  P4DDroneInterface
//
//  Created by Andrei Mitache on 20.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P4DDroneUtil.h"
#import "P4DDroneState.h"
#import "P4DCamera.h"
#import "P4DDroneMission.h"

@interface P4DDrone : NSObject

/// State information for the drone
@property(nonatomic,strong) P4DDroneState *_Nonnull state;

/// Camera instance
@property(nonatomic,strong) P4DCamera *_Nonnull camera;


/// Start the connection to the drone.
- (void)connectWithCompletion:(P4DCompletionBlock)completionBlock;

// Stop and loiter, stop any ongoing mission
- (void)stopAndLoiterWithCompletion:(P4DCompletionBlock)completionBlock;

/// Send a go home command to the drone.
- (void)goHomeWithCompletion:(P4DCompletionBlock)completionBlock
                  withFinish:(P4DCompletionBlock)finishBlock;

/// Prepare for the given mission. Each implementation should convert the mission to the required format and upload it to the drone.
- (void)prepareMission:(P4DDroneMission*_Nonnull)mission
          withProgress:(P4DProgressBlock)progressBlock
            withFinish:(P4DCompletionBlock)finishBlock;

/// Start the mission that was prepared before.
/// The finishBlock will be called when the mission is finished.
- (void)startMissionWithCompletion:(P4DCompletionBlock)block
                        withFinish:(P4DCompletionBlock)finishBlock;

@end
