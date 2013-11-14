//
//  AckType.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AckType : NSObject

@property (nonatomic, strong) NSString *userIdStr;
@property (nonatomic, strong) NSMutableArray *msgIdList;

@end
