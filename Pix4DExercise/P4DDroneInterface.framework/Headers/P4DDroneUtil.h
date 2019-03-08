//
//  P4DDroneUtil.h
//  P4DDroneInterface
//
//  Created by Andrei Mitache on 20.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "P4DDroneMediaDescriptor.h"


typedef void (^_Nullable P4DCompletionBlock)(NSError *_Nullable error);

typedef void (^_Nullable P4DProgressBlock)(float progress);

typedef void (^_Nullable P4DMediaGeneratedBlock)(P4DDroneMediaDescriptor *_Nonnull missionPhoto);

typedef void (^_Nullable P4DCameraPrepareCompletionBlock)(NSDictionary *_Nullable info, NSError *_Nullable error);

typedef void (^_Nullable P4DMediaListBlock)(NSArray<P4DDroneMediaDescriptor*> *_Nullable mediaList, NSError *_Nullable error);

typedef void (^_Nullable P4DMediaDownloadBlock)(P4DDroneMediaDescriptor*_Nullable mediaDescriptor, NSData *_Nullable data, NSError *_Nullable error);
