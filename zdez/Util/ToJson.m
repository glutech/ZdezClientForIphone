//
//  ToJson.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "ToJson.h"

@implementation ToJson

- (NSString *)toJson:(AckType *)ackType
{
    // convert AckType to NSDictionary
    NSMutableDictionary *tempDiction = [[NSMutableDictionary alloc] init];
    [tempDiction setObject:ackType.userIdStr forKey:@"userId"];
    [tempDiction setObject:ackType.msgIdList forKey:@"msgIds"];
    
    NSData *resultData = [[NSData alloc] init];
    
    NSError *error = nil;
    resultData = [NSJSONSerialization dataWithJSONObject:tempDiction options:0 error:&error];
    
    NSString *result = [[NSString alloc] initWithData:resultData encoding:NSASCIIStringEncoding];
    
    return result;
}

@end
