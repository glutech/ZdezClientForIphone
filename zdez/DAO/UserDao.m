//
//  UserDao.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/7/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "UserDao.h"
#import "User.h"

@implementation UserDao

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
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS user (userId INTEGER PRIMARY KEY , username String, name String, gender String, grade String, major String, department String, deviceId String);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed...,%s", err);
        } else {
            NSLog(@"create table success!!");
        }
        
        sqlite3_close(db);
    }
}

- (void)saveUserInfo:(User *)user
{
    // 如果需要的表不存在，则创建
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        
        //插入数据
            
            NSString *sqlStr = @"INSERT OR REPLACE INTO user (userId, username, name, gender, grade, major, department, deviceId) VALUES (?,?,?,?,?,?,?,?);";
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                
                NSLog(@"inserting..");
                
                // 绑定参数
                sqlite3_bind_int(statement, 1, user.userId);
                sqlite3_bind_text(statement, 2, [user.username UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 3, [user.name UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 4, [user.gender UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 5, [user.grade UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 6, [user.major UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 7, [user.department UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 8, [user.deviceId UTF8String], -1, NULL);
                
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    NSAssert(NO, @"insert failed...");
                }
            }
            sqlite3_finalize(statement);
        
        sqlite3_close(db);
    }
    
}

- (NSMutableArray *)getUserInfo
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        NSString *sql = @"SELECT userId, username, name, gender, grade, major, department, deviceId FROM user";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int userId = (int)sqlite3_column_int(statement, 0);
                
                char *username = (char *)sqlite3_column_text(statement, 1);
                NSString *nsUsername = [[NSString alloc] initWithUTF8String:username];
                
                char *name = (char *)sqlite3_column_text(statement, 2);
                NSString *nsName = [[NSString alloc] initWithUTF8String:name];
                
                char *gender = (char *)sqlite3_column_text(statement, 3);
                NSString *nsGender = [[NSString alloc] initWithUTF8String:gender];
                
                char *grade = (char *)sqlite3_column_text(statement, 4);
                NSString *nsGrade = [[NSString alloc] initWithUTF8String:grade];
                
                char *major = (char *)sqlite3_column_text(statement, 5);
                NSString *nsMajor = [[NSString alloc] initWithUTF8String:major];
                
                char *department = (char *)sqlite3_column_text(statement, 6);
                NSString *nsDepartment = [[NSString alloc] initWithUTF8String:department];
                
                char *deviceId = (char *)sqlite3_column_text(statement, 7);
                NSString *nsDeviceId = [[NSString alloc] initWithUTF8String:deviceId];
                
                User *user = [[User alloc] init];
                user.userId = userId;
                user.username = nsUsername;
                user.name = nsName;
                user.gender = nsGender;
                user.grade = nsGrade;
                user.major = nsMajor;
                user.department = nsDepartment;
//                user.school = nsSchool;
                user.deviceId = nsDeviceId;
                
                [data addObject:user];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return data;
}

- (BOOL)isLogined
{
    BOOL flag = false;
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed...");
    } else {
        NSString *sql = @"SELECT userId FROM user";
        sqlite3_stmt *statement;
        
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int userId = (int)sqlite3_column_int(statement, 0);
                
                if (userId != 0) {
                    flag = true;
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return flag;
}

@end
