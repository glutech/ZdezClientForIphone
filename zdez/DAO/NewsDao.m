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

- (NSString *)generateDBFilename
{
    NSString *dbFilename = [[NSString alloc] init];
    // 每个用户使用不同的数据库
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int userId = [userDefaults integerForKey:@"userId"];
    NSString *idStr = [NSString stringWithFormat:@"%d", userId];
    idStr = [idStr stringByAppendingString:@"_"];
    dbFilename = [dbFilename stringByAppendingString:idStr];
    dbFilename = [dbFilename stringByAppendingString:DBFILE_NAME];
    return dbFilename;
}

- (NSString *)applicationDocumentsDirectoryFile
{
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    
    NSString *filename = [myDocPath stringByAppendingPathComponent:[self generateDBFilename]];
    
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
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS news (newsId INTEGER PRIMARY KEY , title String, content String, date Date, isRead INTEGER DEFAULT 0, isTop INTEGER);"];
        
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
            
            NSString *sqlStr = @"INSERT OR REPLACE INTO news (newsId, title, content, date, isTop) VALUES (?,?,?,?,?);";
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                
                NSLog(@"inserting..");
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *nsDate = [dateFormatter stringFromDate:msg.date];
                
                // 绑定参数
                sqlite3_bind_int(statement, 1, msg.newsId);
                sqlite3_bind_text(statement, 2, [msg.title UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 3, [msg.content UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 4, [nsDate UTF8String], -1, NULL);
                sqlite3_bind_int(statement, 5, msg.isTop);
                
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
        NSString *sql = @"SELECT newsId, title, date, isRead FROM news ORDER BY newsId DESC";
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
                
                int isRead = (int)sqlite3_column_int(statement, 3);
                
                News *msg = [[News alloc] init];
                msg.newsId= newsId;
                msg.title = nsTitle;
                msg.date = [dateFormatter dateFromString:nsDate];
                msg.isRead = isRead;
                
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
        NSString *sql = @"SELECT title, content, date FROM news WHERE newsId = ?";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, newsId);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *ctitle = (char *)sqlite3_column_text(statement, 0);
                NSString *title = [[NSString alloc] initWithUTF8String:ctitle];
                NSString *header = @"<html><body><h2>";
                header = [header stringByAppendingString:title];
                header = [header stringByAppendingString:@"</h2>"];
                header = [header stringByAppendingString:@"<p><font size=\"2\">发送时间: "];
                
                char *cdate = (char *)sqlite3_column_text(statement, 2);
                NSString *nsDate = [[NSString alloc] initWithUTF8String:cdate];
                
                header = [header stringByAppendingString:nsDate];
                header = [header stringByAppendingString:@"</font></p><hr>"];
                
                char *ccontent = (char *)sqlite3_column_text(statement, 1);
                htmlContent = [[NSString alloc] initWithUTF8String:ccontent];
                
                htmlContent = [header stringByAppendingString:htmlContent];
                htmlContent = [htmlContent stringByAppendingString:@"</body></html>"];
            }
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
    }
    
    return htmlContent;
}

- (void)changeIsReadState:(News *)news
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        NSString *sql = @"UPDATE news set isRead = 1 WHERE newsId = ?";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, news.newsId);
            
            sqlite3_step(statement);
                
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
    }
}

- (NSMutableArray *)getByRefreshCount:(int)count
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    // 确定查询的开始与结束位置
    int begin = (count-1) * 20;
    int end = (count) * 20;
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        NSString *sql = @"SELECT newsId, title, date, isRead FROM news ORDER BY newsId DESC LIMIT ?, ?";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(statement, 1, begin);
            sqlite3_bind_int(statement, 2, end);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int newsId= (int)sqlite3_column_int(statement, 0);
                
                char *ctitle = (char *)sqlite3_column_text(statement, 1);
                NSString *nsTitle = [[NSString alloc] initWithUTF8String:ctitle];
                
                char *cdate = (char *)sqlite3_column_text(statement, 2);
                NSString *nsDate = [[NSString alloc] initWithUTF8String:cdate];
                
                int isRead = (int)sqlite3_column_int(statement, 3);
                
                News *msg = [[News alloc] init];
                msg.newsId= newsId;
                msg.title = nsTitle;
                msg.date = [dateFormatter dateFromString:nsDate];
                msg.isRead = isRead;
                
                [data addObject:msg];
            }
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
    }
    
    return data;
}

@end
