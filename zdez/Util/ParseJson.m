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

@end
