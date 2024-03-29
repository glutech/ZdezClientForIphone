//
//  SchoolMsgService.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "SchoolMsgService.h"
#import "ASIHTTPRequest.h"
#import "ParseJson.h"
#import "UserDao.h"
#import "SchoolMsgDao.h"
#import "AckType.h"
#import "ToJson.h"
#import "ASIFormDataRequest.h"

@implementation SchoolMsgService

- (ASIHTTPRequest *)getRequest
{
    ASIHTTPRequest *request = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger userId = [userDefaults integerForKey:@"userId"];
    if (userId != 0) {
        NSString *idStr = [NSString stringWithFormat:@"%lu", (unsigned long)userId];
        NSString *address = @"AndroidClient_GetUpdateSchoolMsg?user_id=";
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

- (NSMutableArray *)getSchoolMsg
{
    NSMutableArray *arrayDesc = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int userId = [userDefaults integerForKey:@"userId"];
    if (userId != 0) {
        
        NSString *idStr = [NSString stringWithFormat:@"%d", userId];
        NSString *address = @"AndroidClient_GetUpdateSchoolMsg?user_id=";
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
            array = [parser parseSchoolMsg:[request responseData]];
            
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

- (int)insert:(NSMutableArray *)schoolMsgArray
{
    SchoolMsgDao *dao = [[SchoolMsgDao alloc] init];
    return [dao insert:schoolMsgArray];
}

- (NSString *)getContent:(int)msgId
{
    NSString *htmlContent = [[NSString alloc] init];
    SchoolMsgDao *dao = [[SchoolMsgDao alloc] init];
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
    for (SchoolMsg *msg in msgList) {
        [temp addObject:[[NSString alloc] initWithFormat:@"%d", msg.schoolMsgId]];
    }
    ackType.msgIdList = temp;
    
    ToJson *toJson = [[ToJson alloc] init];
    NSString *ack = [toJson toJson:ackType];
    
    NSString *postURL = [NSString stringWithFormat:@"AndroidClient_UpdateSchoolMsgReceived"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:ack forKey:@"ack"];
    
    [request startAsynchronous];
    
}

- (void)changeIsReadState:(SchoolMsg *)sMsg
{
    SchoolMsgDao *dao = [[SchoolMsgDao alloc] init];
    [dao changeIsReadState:sMsg];
}

- (NSMutableArray *)getByRefreshCount:(int)count
{
    SchoolMsgDao *dao = [[SchoolMsgDao alloc] init];
    return [dao getByRefreshCount:count];
}

- (NSInteger)getUnreadMsgCount
{
    SchoolMsgDao *dao = [[SchoolMsgDao alloc] init];
    return [dao getUnreadMsgCount];
}

@end
