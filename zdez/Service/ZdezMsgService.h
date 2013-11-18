//
//  ZdezMsgService.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZdezMsg.h"
#import "ASIHTTPRequest.h"

#define HOST_NAME @"http://192.168.1.106:8080/zdezServer/"

@interface ZdezMsgService : NSObject

- (ASIHTTPRequest *)getRequest;
- (NSMutableArray *)getZdezMsg;
- (int)insert:(NSMutableArray *)zdezMsgArray;
- (NSString *)getContent:(int)msgId;
- (void)sendAck:(NSMutableArray *)msgList;
- (void)changeIsReadState:(ZdezMsg *)zMsg;
- (NSMutableArray *)getByRefreshCount:(int)count;

@end
