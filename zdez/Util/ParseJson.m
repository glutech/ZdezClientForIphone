//
//  ParseJson.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "ParseJson.h"
#import "SchoolMsg.h"
#import "ZdezMsg.h"
#import "News.h"
#import "User.h"

@implementation ParseJson

- (NSMutableArray *)parseSchoolMsg:(NSData *)schoolMsgList
{
    NSError *error;
    
    // 传进来的schoolMsg可能有多条，所以options要用NSJSONReadingMutableContainers，可以解析出多条
    NSDictionary *schoolMsgDic = [NSJSONSerialization JSONObjectWithData:schoolMsgList options:NSJSONReadingMutableContainers error:&error];
    
    // 将Dictionary转为array返回
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    SchoolMsg *sMsg;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [[NSDate alloc] init];
    
    for (NSDictionary *dic in schoolMsgDic) {
        NSLog(@"schoolMsg: %@", dic);
        sMsg = [[SchoolMsg alloc] init];
        sMsg.schoolMsgId = [[dic objectForKey:@"schoolMsgId"] integerValue];
        sMsg.title = [dic objectForKey:@"title"];
        sMsg.content = [dic objectForKey:@"content"];
        sMsg.remarks = [dic objectForKey:@"remarks"];
        
        destDate = [dateFormatter dateFromString:[dic objectForKey:@"date"]];
        sMsg.date = destDate;
        
        [array addObject:sMsg];
        
    }
    
    return array;
}

- (NSMutableArray *)parseNewsMsg:(NSData *)newsMsgList
{
    NSError *error;
    
    // 传进来的newsMsg可能有多条，所以options要用NSJSONReadingMutableContainers，可以解析出多条
    NSDictionary *newsMsgDic = [NSJSONSerialization JSONObjectWithData:newsMsgList options:NSJSONReadingMutableContainers error:&error];
    
    // 将Dictionary转为array返回
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    News *news = [[News alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [[NSDate alloc] init];
    
    for (NSDictionary *dic in newsMsgDic) {
        news = [[News alloc] init];
        news.newsId = [[dic objectForKey:@"id"] integerValue];
        news.title = [dic objectForKey:@"title"];
        news.content = [dic objectForKey:@"content"];
        
        destDate = [dateFormatter dateFromString:[dic objectForKey:@"date"]];
        news.date = destDate;
        
        [array addObject:news];
        
    }
    
    return array;
}

- (NSMutableArray *)parseZdezMsg:(NSData *)zdezMsgList
{
    
    NSError *error;
    
    // 传进来的zdezMsgList可能有多条，所以options要用NSJSONReadingMutableContainers，可以解析出多条
    NSDictionary *zdezMsgDic = [NSJSONSerialization JSONObjectWithData:zdezMsgList options:NSJSONReadingMutableContainers error:&error];
    
    // 将Dictionary转为array返回
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ZdezMsg *zMsg = [[ZdezMsg alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [[NSDate alloc] init];
    
    for (NSDictionary *dic in zdezMsgDic) {
        zMsg = [[ZdezMsg alloc] init];
        zMsg.zdezMsgId = [[dic objectForKey:@"zdezMsgId"] integerValue];
        zMsg.title = [dic objectForKey:@"title"];
        zMsg.content = [dic objectForKey:@"content"];
        
        destDate = [dateFormatter dateFromString:[dic objectForKey:@"date"]];
        zMsg.date = destDate;
        
        [array addObject:zMsg];
        
    }
    
    return array;
}

- (User *)parseLoginCheckMsg:(NSData *)result
{
    NSError *error;
    
    NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"userInfo: %@", userInfoDic);
    
    User *user = [[User alloc] init];
        NSLog(@"userInfoDic: %@", userInfoDic);
        user.userId = [[userInfoDic objectForKey:@"id"] integerValue];
        user.username = [userInfoDic objectForKey:@"username"];
        user.name = [userInfoDic objectForKey:@"name"];
        user.gender = [userInfoDic objectForKey:@"gender"];
        user.grade = [userInfoDic objectForKey:@"grade"];
        user.major = [userInfoDic objectForKey:@"major"];
        user.department = [userInfoDic objectForKey:@"department"];
        //    user.school = [userInfoDic objectForKey:@"school"];
        user.deviceId = [userInfoDic objectForKey:@"staus"];
    
    return user;
}

@end
