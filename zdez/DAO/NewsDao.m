//
//  NewsDao.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "NewsDao.h"
#import "News.h"

@implementation NewsDao

- (NSString *)applicationDocumentsDirectoryFile
{
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    NSString *filename = [myDocPath stringByAppendingPathComponent:DBFILE_NAME];
    
    return filename;
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([writableDBPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        
        NSLog(@"creating table...");
        
        char *err;
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS news (newsId INTEGER PRIMARY KEY , title String, content String, date Date);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed...,%s", err);
        } else {
            NSLog(@"create table success!!");
        }
        
        sqlite3_close(db);
    }
}

- (int)insert:(NSMutableArray *)newsArray
{
    // 如果需要的表不存在，则创建
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        
        // 循环插入数据
        for (News *msg in newsArray) {
            
            msg.content = [msg.content stringByReplacingOccurrencesOfString:@"img src=\"/zdezServer/" withString:@"img src=\"http:192.168.1.110:8080/zdezServer/"];
            
            NSString *sqlStr = @"INSERT OR REPLACE INTO news (newsId, title, content, date) VALUES (?,?,?,?);";
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                
                NSLog(@"inserting..");
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *nsDate = [dateFormatter stringFromDate:msg.date];
                
                // 绑定参数
                sqlite3_bind_int(statement, 1, msg.newsId);
                sqlite3_bind_text(statement, 2, [msg.title UTF8String], -1, NULL);
//                sqlite3_bind_text(statement, 3, [content UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 3, [msg.content UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 4, [nsDate UTF8String], -1, NULL);
                
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    NSAssert(NO, @"insert failed...");
                }
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(db);
    }
    
    return 0;
}

- (NSMutableArray *)findAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        NSString *sql = @"SELECT newsId, title, date FROM news ORDER BY newsId DESC";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int newsId= (int)sqlite3_column_int(statement, 0);
                
                char *ctitle = (char *)sqlite3_column_text(statement, 1);
                NSString *nsTitle = [[NSString alloc] initWithUTF8String:ctitle];
                
                char *cdate = (char *)sqlite3_column_text(statement, 2);
                NSString *nsDate = [[NSString alloc] initWithUTF8String:cdate];
                
                News *msg = [[News alloc] init];
                msg.newsId= newsId;
                msg.title = nsTitle;
                msg.date = [dateFormatter dateFromString:nsDate];
                
                [data addObject:msg];
            }
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
    }
    
    return data;
}

- (NSString *)getContent:(int)newsId
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSString *htmlContent = [[NSString alloc] init];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        NSString *sql = @"SELECT content FROM news WHERE newsId = ?";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, newsId);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *ccontent = (char *)sqlite3_column_text(statement, 0);
                htmlContent = [[NSString alloc] initWithUTF8String:ccontent];
            }
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
    }
    
    return htmlContent;
}

@end
