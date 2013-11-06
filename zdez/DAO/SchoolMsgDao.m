//
//  SchoolMsgDao.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "SchoolMsgDao.h"
#import "SchoolMsg.h"

@implementation SchoolMsgDao

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
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS schoolMsg (schoolMsgId INTEGER PRIMARY KEY , title String, content String, date Date, remarks String);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed...,%s", err);
        } else {
            NSLog(@"create table success!!");
        }
        
        sqlite3_close(db);
    }
}

- (int)insert:(NSMutableArray *)schoolMsgArray
{
    // 如果需要的表不存在，则创建
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        
        // 循环插入数据
        for (SchoolMsg *msg in schoolMsgArray) {
            
            NSString *sqlStr = @"INSERT OR REPLACE INTO schoolMsg (schoolMsgId, title, content, date, remarks) VALUES (?,?,?,?,?);";
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                
                NSLog(@"inserting..");
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                
//                NSLog(@"title: %@", msg.title);
//                NSLog(@"content: %@", msg.content);
//                NSLog(@"date: %@", msg.date);
//                NSLog(@"remarks: %@", msg.remarks);
                
                NSString *nsDate = [dateFormatter stringFromDate:msg.date];
                
                // 绑定参数
                sqlite3_bind_int(statement, 1, msg.schoolMsgId);
                sqlite3_bind_text(statement, 2, [msg.title UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 3, [msg.content UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 4, [nsDate UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 5, [msg.remarks UTF8String], -1, NULL);
                
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
        NSString *sql = @"SELECT schoolMsgId, title, date FROM schoolMsg ORDER BY schoolMsgId DESC";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int schoolMsgId = (int)sqlite3_column_int(statement, 0);
                
                char *ctitle = (char *)sqlite3_column_text(statement, 1);
                NSString *nsTitle = [[NSString alloc] initWithUTF8String:ctitle];
                
                char *cdate = (char *)sqlite3_column_text(statement, 2);
                NSString *nsDate = [[NSString alloc] initWithUTF8String:cdate];
                
                SchoolMsg *msg = [[SchoolMsg alloc] init];
                msg.schoolMsgId = schoolMsgId;
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

@end
