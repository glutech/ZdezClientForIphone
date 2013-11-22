//
//  NewsService.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "NewsService.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ParseJson.h"
#import "NewsDao.h"
#import "UserDao.h"
#import "AckType.h"
#import "ToJson.h"

@implementation NewsService

- (ASIHTTPRequest *)getNewsRequest
{
    ASIHTTPRequest *request = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger userId = [userDefaults integerForKey:@"userId"];
    if (userId != 0) {
        NSString *idStr = [NSString stringWithFormat:@"%lu", (unsigned long)userId];
        NSString *address = @"AndroidClient_GetUpdateNews?user_id=";
        address = [address stringByAppendingString:idStr];
        address = [HOST_NAME stringByAppendingString:address];
        
        NSURL *url = [NSURL URLWithString:address];
        
        // 构造ASIHTTPRequest对象
        request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request setTimeOutSeconds:5];
    }
    
    return request;
}

- (NSMutableArray *)getNews
{
    NSMutableArray *arrayDesc = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger userId = [userDefaults integerForKey:@"userId"];
    if (userId != 0) {
        NSString *idStr = [NSString stringWithFormat:@"%lu", (unsigned long)userId];
        NSString *address = @"AndroidClient_GetUpdateNews?user_id=";
        address = [address stringByAppendingString:idStr];
        address = [HOST_NAME stringByAppendingString:address];
        
        NSURL *url = [NSURL URLWithString:address];
        
        // 构造ASIHTTPRequest对象
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request setTimeOutSeconds:5];
        [request startSynchronous];
        
        //    NSString *response = [[NSString alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSError *error = request.error;
        
        if (error == nil) {
            
            ParseJson *parser = [[ParseJson alloc] init];
            array = [parser parseNewsMsg:[request responseData]];
            
            int count = [array count];
            for (int i = count-1; i >= 0; i--) {
                [arrayDesc addObject:[array objectAtIndex:i]];
            }
            
        } else {
//            NSLog(@"can't get data... error: %@", error);
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
        }
    } else {
        // 没有用户id了，返回登录页面
    }
    
    return arrayDesc;
}

- (int)insert:(NSMutableArray *)newsArray
{
    NewsDao *dao = [[NewsDao alloc] init];
    return [dao insert:newsArray];
}

- (NSString *)getContent:(int)newsId
{
    NSString *htmlContent = [[NSString alloc] init];
    NewsDao *dao = [[NewsDao alloc] init];
    htmlContent = [dao getContent:newsId];
    return htmlContent;
}

- (void)sendAck:(NSMutableArray *)newsList
{
    AckType *ackType = [[AckType alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int userId = [userDefaults integerForKey:@"userId"];
    NSString *userIdStr = [[NSString alloc] initWithFormat:@"%d", userId];
    ackType.userIdStr = userIdStr;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (News *n in newsList) {
        [temp addObject:[[NSString alloc] initWithFormat:@"%d", n.newsId]];
    }
    ackType.msgIdList = temp;
    
    ToJson *toJson = [[ToJson alloc] init];
    NSString *ack = [toJson toJson:ackType];
    
    NSString *postURL = [NSString stringWithFormat:@"AndroidClient_UpdateNewsReceived"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:ack forKey:@"ack"];
    
    [request startAsynchronous];
    
}

- (void)changeIsReadState:(News *)newsMsg
{
    NewsDao *dao = [[NewsDao alloc] init];
    [dao changeIsReadState:newsMsg];
}

- (NSMutableArray *)getByRefreshCount:(int)count
{
    NewsDao *dao = [[NewsDao alloc] init];
    return [dao getByRefreshCount:count];
}

- (NSInteger)getUnreadMsgCount
{
    NewsDao *dao = [[NewsDao alloc] init];
    return [dao getUnreadMsgCount];
}

@end
