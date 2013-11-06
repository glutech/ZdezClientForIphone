//
//  LoginDao.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"

@interface LoginDao : NSObject
{
    sqlite3 *db;
}

// 检测用户名密码是否正确
- (int)loginCheck:(User *)user;

// 存储用户信息
- (int)saveUserInfo:(User *)user;

@end
