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

@implementation ZdezMsgService

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
            NSLog(@"can't get data... error: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        // 没有用户id了，返回登录页面
    }
    
    return arrayDesc;
}

- (NSString *)getContent:(int)msgId
{
    NSString *htmlContent = [[NSString alloc] init];
    ZdezMsgDao *dao = [[ZdezMsgDao alloc] init];
    htmlContent = [dao getContent:msgId];
    return htmlContent;
}

@end
