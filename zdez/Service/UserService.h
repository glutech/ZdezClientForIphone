//
//  UserService.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST_NAME @"http://192.168.1.110:8080/zdezServer/"

@interface UserService : NSObject

- (BOOL)modifyPassword:(int)userId theOldPassword:(NSString *)oldPsw theNewPassword:(NSString *)newPsw;

@end
