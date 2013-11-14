//
//  ZdezMsgDao.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "ZdezMsgDao.h"
#import "ZdezMsg.h"

@implementation ZdezMsgDao

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
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS zdezMsg (zdezMsgId INTEGER PRIMARY KEY , title String, content String, date Date, isRead INTEGER DEFAULT 0);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed...,%s", err);
        } else {
            NSLog(@"create table success!!");
        }
        
        sqlite3_close(db);
    }
}

- (int)insert:(NSMutableArray *)zdezMsgArray
{
    // 如果需要的表不存在，则创建
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        
        // 循环插入数据
        for (ZdezMsg *msg in zdezMsgArray) {
            
            msg.content = [msg.content stringByReplacingOccurrencesOfString:@"img src=\"/zdezServer/" withString:@"img src=\"http:192.168.1.110:8080/zdezServer/"];
            
            NSString *sqlStr = @"INSERT OR REPLACE INTO zdezMsg (zdezMsgId, title, content, date) VALUES (?,?,?,?);";
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                
                NSLog(@"inserting..");
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSString *nsDate = [dateFormatter stringFromDate:msg.date];
                
                // 绑定参数
                sqlite3_bind_int(statement, 1, msg.zdezMsgId);
                sqlite3_bind_text(statement, 2, [msg.title UTF8String], -1, NULL);
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
        NSString *sql = @"SELECT zdezMsgId, title, date, isRead FROM zdezMsg ORDER BY zdezMsgId DESC";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int zdezMsgId = (int)sqlite3_column_int(statement, 0);
                
                char *ctitle = (char *)sqlite3_column_text(statement, 1);
                NSString *nsTitle = [[NSString alloc] initWithUTF8String:ctitle];
                
                char *cdate = (char *)sqlite3_column_text(statement, 2);
                NSString *nsDate = [[NSString alloc] initWithUTF8String:cdate];
                
                int isRead = (int)sqlite3_column_int(statement, 3);
                
                ZdezMsg *msg = [[ZdezMsg alloc] init];
                msg.zdezMsgId = zdezMsgId;
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

- (NSString *)getContent:(int)msgId
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSString *htmlContent = [[NSString alloc] init];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        NSString *sql = @"SELECT content FROM zdezMsg WHERE zdezMsgId = ?";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, msgId);
            
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

- (void)changeIsReadState:(ZdezMsg *)zMsg
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        NSString *sql = @"UPDATE zdezMsg set isRead = 1 WHERE zdezMsgId = ?";
        //        NSString *sql = @"SELECT content FROM news WHERE newsId = ?";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, zMsg.zdezMsgId);
            
            sqlite3_step(statement);
            
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(db);
    }
}

@end
