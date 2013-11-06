//
//  ZdezMsgDao.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ZdezMsg.h"

#define DBFILE_NAME @"zdez.sqlite3"

@interface ZdezMsgDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和zdezMsg表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 插入zdezMsg方法
- (int)insert:(NSMutableArray *)zdezMsgArray;

// 查询所有zdezMsg方法
- (NSMutableArray *)findAll;

@end
