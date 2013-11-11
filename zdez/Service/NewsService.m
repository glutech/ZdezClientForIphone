//
//  NewsService.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "NewsService.h"
#import "ASIHTTPRequest.h"
#import "ParseJson.h"
#import "NewsDao.h"
#import "UserDao.h"

@implementation NewsService

- (NSMutableArray *)getNews
{
    UserDao *userDao = [[UserDao alloc] init];
    int userId = [userDao getUserId];
    NSString *idStr = [NSString stringWithFormat:@"%d", userId];
    NSString *address = @"http://192.168.1.110:8080/zdezServer/AndroidClient_GetUpdateNews?user_id=";
    address = [address stringByAppendingString:idStr];
    
    NSURL *url = [NSURL URLWithString:address];
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.110:8080/zdezServer/AndroidClient_GetUpdateNews?user_id=4"];
    
    // 构造ASIHTTPRequest对象
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:5];
    [request startSynchronous];
    
    //    NSString *response = [[NSString alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *arrayDesc = [[NSMutableArray alloc] init];
    
    NSError *error = request.error;
    
    if (error == nil) {
        
        ParseJson *parser = [[ParseJson alloc] init];
        array = [parser parseNewsMsg:[request responseData]];
        
        int count = [array count];
        for (int i = count-1; i >= 0; i--) {
            [arrayDesc addObject:[array objectAtIndex:i]];
        }
        
    } else {
        NSLog(@"can't get data... error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    return arrayDesc;
}

- (NSString *)getContent:(int)newsId
{
    NSString *htmlContent = [[NSString alloc] init];
    NewsDao *dao = [[NewsDao alloc] init];
    htmlContent = [dao getContent:newsId];
    return htmlContent;
}

@end
