//
//  UserService.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define HOST_NAME @"http://192.168.1.103:8080/zdezServer/"
//#define HOST_NAME @"http://112.117.223.20:9080/zdezServer/"
//#define HOST_NAME @"http://192.168.199.139:8080/zdezServer/"

@interface UserService : NSObject

- (BOOL)modifyPassword:(int)userId theOldPassword:(NSString *)oldPsw theNewPassword:(NSString *)newPsw;

//- (void)modifyBadge:(int)userId;

- (User *)getUserInfo;

- (void)sendFeedbackMsg:(NSString *)feedbackMsg;

@end
