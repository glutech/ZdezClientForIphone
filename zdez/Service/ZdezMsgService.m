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

@implementation ZdezMsgService

- (NSMutableArray *)getZdezMsg
{
    NSURL *url = [NSURL URLWithString:@"http://www.zdez.com.cn:9080/zdezServer/AndroidClient_GetUpdateZdezMsg?user_id=4"];
    
    // 构造ASIHTTPRequest对象
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:10];
    [request startSynchronous];
    
    //    NSString *response = [[NSString alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *arrayDesc = [[NSMutableArray alloc] init];
    
    NSError *error = request.error;
    
    if (error == nil) {
        
        ParseJson *parser = [[ParseJson alloc] init];
        array = [parser parseSchoolMsg:[request responseData]];
        
        int count = [array count];
        for (int i = count-1; i >= 0; i--) {
            [arrayDesc addObject:[array objectAtIndex:i]];
        }
        
    } else {
        NSLog(@"can't get data... error: %@", error);
    }
    
    return arrayDesc;
}

@end
