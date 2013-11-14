//
//  NewsService.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

#define HOST_NAME @"http://192.168.1.110:8080/zdezServer/"

@interface NewsService : NSObject

- (NSMutableArray *)getNews;
- (NSString *)getContent:(int)newsId;
- (void)sendAck:(NSMutableArray *)newsList;
- (void)changeIsReadState:(News *)newsMsg;
- (void)getAllByRefreshCount:(int)count;

@end
