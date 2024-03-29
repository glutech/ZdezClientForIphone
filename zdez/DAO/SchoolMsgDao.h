//
//  SchoolMsgDao.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SchoolMsg.h"

// for HOST_NAME
#import "UserService.h"

#define DBFILE_NAME @"zdez.sqlite3"

@interface SchoolMsgDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和schoolMsg表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 插入schoolMsg方法
- (int)insert:(NSMutableArray *)schoolMsgArray;

// 查询所有schoolMsg方法
- (NSMutableArray *)findAll;

- (NSString *)getContent:(int)msgId;

- (void)changeIsReadState:(SchoolMsg *)sMsg;

// 分段加载信息
- (NSMutableArray *)getByRefreshCount:(int)count;

- (NSInteger)getUnreadMsgCount;

@end
