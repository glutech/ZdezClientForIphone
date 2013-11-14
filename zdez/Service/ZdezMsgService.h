//
//  ZdezMsgService.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZdezMsg.h"

#define HOST_NAME @"http://192.168.1.110:8080/zdezServer/"

@interface ZdezMsgService : NSObject

- (NSMutableArray *)getZdezMsg;
- (NSString *)getContent:(int)msgId;
- (void)sendAck:(NSMutableArray *)msgList;
- (void)changeIsReadState:(ZdezMsg *)zMsg;

@end
