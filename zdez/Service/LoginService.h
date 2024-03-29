//
//  LoginService.h
//  zdez
//
//  Created by glu on 13-11-6.
//  Copyright (c) 2013年 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserService.h"

//#define HOST_NAME @"http://192.168.1.110:8080/zdezServer/"

@interface LoginService : NSObject

-(int)login:(NSString*)username secondParameter:(NSString*)password;

- (BOOL)isLogined;

- (BOOL)logOut;

// 用户修改密码之后，删除user表中的数据
- (void)reLogin;

@end
