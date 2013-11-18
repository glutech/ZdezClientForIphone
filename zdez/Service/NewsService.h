//
//  NewsService.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"
#import "ASIHTTPRequest.h"

#define HOST_NAME @"http://192.168.1.106:8080/zdezServer/"

@interface NewsService : NSObject

- (ASIHTTPRequest *)getNewsRequest;
- (NSMutableArray *)getNews;
- (int)insert:(NSMutableArray *)newsArray;
- (NSString *)getContent:(int)newsId;
- (void)sendAck:(NSMutableArray *)ewsList;
- (void)changeIsReadState:(News *)newsMsg;
- (NSMutableArray *)getByRefreshCount:(int)count;

@end
