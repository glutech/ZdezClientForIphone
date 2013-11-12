//
//  NewsService.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST_NAME @"http://192.168.1.110:8080/zdezServer/"

@interface NewsService : NSObject

- (NSMutableArray *)getNews;
- (NSString *)getContent:(int)newsId;

@end
