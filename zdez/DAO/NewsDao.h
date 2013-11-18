//
//  NewsDao.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "News.h"

#define DBFILE_NAME @"zdez.sqlite3"

@interface NewsDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和news表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 插入news方法
- (int)insert:(NSMutableArray *)newsArray;

// 查询所有news方法
- (NSMutableArray *)findAll;

// 通过newsId获取新闻内容
- (NSString *)getContent:(int)newsId;

// 改变新闻的已读未读状态
- (void)changeIsReadState:(News *)news;

// 分段加载信息
- (NSMutableArray *)getByRefreshCount:(int)count;

@end
