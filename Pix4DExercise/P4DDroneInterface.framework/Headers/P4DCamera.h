//
//  P4DCamera.h
//  P4DDroneInterface
//
//  Created by Andrei Mitache on 20.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P4DDroneUtil.h"
#import "P4DDroneMediaDescriptor.h"

typedef struct {
    double sensorWidth; // mm
    double focalLength; // mm
    double imageWidth;  // pixels
    double imageHeight; // pixels
    double photoIntervalMin;
} P4DCameraParameters;


@interface P4DCamera : NSObject

@property (nonatomic,assign) P4DCameraParameters cameraParameters;

/// Block used to callback when a photo was taken.
@property(nonatomic,copy) P4DMediaGeneratedBlock photoTakenCallback;

/// Send a take photo command to the drone.
- (void)takePhotoWithCompletion:(P4DCompletionBlock)block;

/// List all medias on the drone.
- (void)listMediaWithFinish:(P4DMediaListBlock)finishBlock;

/// Download medias in the given list, providing the name and raw data for each one.
- (void)downloadMediaList:(NSArray<P4DDroneMediaDescriptor*>*_Nonnull)mediaList
                     data:(P4DMediaDownloadBlock)dataBlock
               completion:(P4DCompletionBlock)completionBlock;

/// Cancel any ongoing download of media.
- (void)cancelDownloadMedia;


@end
