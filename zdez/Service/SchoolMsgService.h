//
//  SchoolMsgService.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolMsgService : NSObject

- (NSMutableArray *)getSchoolMsg;
- (NSString *)getContent:(int)msgId;

@end
