//
//  ZdezMsgService.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "ZdezMsgService.h"
#import "ASIHTTPRequest.h"
#import "ParseJson.h"
#import "UserDao.h"
#import "ZdezMsgDao.h"
#import "AckType.h"
#import "ToJson.h"
#import "ASIFormDataRequest.h"
#import "ZdezMsg.h"

@implementation ZdezMsgService

- (ASIHTTPRequest *)getRequest
{
    ASIHTTPRequest *request = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger userId = [userDefaults integerForKey:@"userId"];
    if (userId != 0) {
        NSString *idStr = [NSString stringWithFormat:@"%lu", (unsigned long)userId];
        NSString *address = @"AndroidClient_GetUpdateZdezMsg?user_id=";
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

- (NSMutableArray *)getZdezMsg
{
    
    NSMutableArray *arrayDesc = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int userId = [userDefaults integerForKey:@"userId"];
    if (userId != 0) {
        
        NSString *idStr = [NSString stringWithFormat:@"%d", userId];
        NSString *address = @"AndroidClient_GetUpdateZdezMsg?user_id=";
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
            array = [parser parseZdezMsg:[request responseData]];
            
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

- (int)insert:(NSMutableArray *)zdezMsgArray
{
    ZdezMsgDao *dao = [[ZdezMsgDao alloc] init];
    return [dao insert:zdezMsgArray];
}

- (NSString *)getContent:(int)msgId
{
    NSString *htmlContent = [[NSString alloc] init];
    ZdezMsgDao *dao = [[ZdezMsgDao alloc] init];
    htmlContent = [dao getContent:msgId];
    return htmlContent;
}

- (void)sendAck:(NSMutableArray *)msgList
{
    AckType *ackType = [[AckType alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int userId = [userDefaults integerForKey:@"userId"];
    NSString *userIdStr = [[NSString alloc] initWithFormat:@"%d", userId];
    ackType.userIdStr = userIdStr;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (ZdezMsg *msg in msgList) {
        [temp addObject:[[NSString alloc] initWithFormat:@"%d", msg.zdezMsgId]];
    }
    ackType.msgIdList = temp;
    
    ToJson *toJson = [[ToJson alloc] init];
    NSString *ack = [toJson toJson:ackType];
    
    NSString *postURL = [NSString stringWithFormat:@"AndroidClient_UpdateZdezMsgReceived"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:ack forKey:@"ack"];
    
    [request startAsynchronous];
    
}

- (void)changeIsReadState:(ZdezMsg *)zMsg
{
    ZdezMsgDao *dao = [[ZdezMsgDao alloc] init];
    [dao changeIsReadState:zMsg];
}

- (NSMutableArray *)getByRefreshCount:(int)count
{
    ZdezMsgDao *dao = [[ZdezMsgDao alloc] init];
    return [dao getByRefreshCount:count];
}

- (NSInteger)getUnreadMsgCount
{
    ZdezMsgDao *dao=  [[ZdezMsgDao alloc] init];
    return [dao getUnreadMsgCount];
}

@end
