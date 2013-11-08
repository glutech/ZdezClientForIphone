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
    NSMutableArray *array = [[NSMutableArray alloc] init];
    return array;
}

- (NSMutableArray *)parseZdezMsg:(NSData *)zdezMsgList
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    return array;
}

- (User *)parseLoginChekMsg:(NSData *)result
{
    NSError *error;
    
    NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"userInfo: %@", userInfoDic);
    
    User *user = [[User alloc] init];
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
