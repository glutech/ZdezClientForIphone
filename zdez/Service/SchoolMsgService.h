//
//  SchoolMsgService.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolMsg.h"
#import "ASIHTTPRequest.h"

#define HOST_NAME @"http://192.168.1.106:8080/zdezServer/"

@interface SchoolMsgService : NSObject

- (ASIHTTPRequest *)getRequest;
- (NSMutableArray *)getSchoolMsg;
- (int)insert:(NSMutableArray *)schoolMsgArray;
- (NSString *)getContent:(int)msgId;
- (void)sendAck:(NSMutableArray *)msgList;
- (void)changeIsReadState:(SchoolMsg *)sMsg;
- (NSMutableArray *)getByRefreshCount:(int)count;

@end
