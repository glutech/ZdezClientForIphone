//
//  ParseJson.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseJson : NSObject

- (NSMutableArray *)parseNewsMsg:(NSData *)newsMsgList;

- (NSMutableArray *)parseSchoolMsg:(NSData *)schoolMsgList;

- (NSMutableArray *)parseZdezMsg:(NSData *)zdezMsgList;

@end
