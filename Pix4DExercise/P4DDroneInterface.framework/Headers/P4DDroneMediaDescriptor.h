//
//  P4DDroneMediaDescriptor.h
//  P4DDroneInterface
//
//  Created by Andrei Mitache on 20.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P4DDroneMediaDescriptor : NSObject

@property(nonatomic,strong) NSString * _Nonnull mediaId;
@property(nonatomic,strong) NSMutableDictionary * _Nonnull metaData;

@end
