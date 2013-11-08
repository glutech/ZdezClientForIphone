//
//  UserDao.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/7/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"

#define DBFILE_NAME @"zdez.sqlite3"

@interface UserDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和user表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 存储用户信息
- (void)saveUserInfo:(User *)user;

// 查询所有user方法
- (NSMutableArray *)getUserInfo;

// 检测是否已经有用户登录
- (BOOL)isLogined;


@end
