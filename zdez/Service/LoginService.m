//
//  LoginService.m
//  zdez
//
//  Created by glu on 13-11-6.
//  Copyright (c) 2013年 Boke Technology co., ltd. All rights reserved.
//

#import "LoginService.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation LoginService

extern NSString* deviceid;

- (int)login:(NSString *)username secondParameter:(NSString *)password
{
    NSString *postURL = [NSString stringWithFormat:@"http://112.117.223.20:9080/zdezServer/IosClient_StudentLoginCheck"];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:username forKey:@"username"];
    
    [request addPostValue:password forKey:@"password"];
    
    [request addPostValue:deviceid forKey:@"deviceid"];
    
    [request startSynchronous];
    
    /*[request responseData]；后半部分留给徐*/
    
    NSLog(@"My token is: %@", deviceid);
    
    return 0;
}

@end
