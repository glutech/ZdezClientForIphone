//
//  ToJson.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AckType.h"

@interface ToJson : NSObject

- (NSString *)toJson:(AckType *)ackType;

@end
