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
#import "ParseJson.h"
#import "User.h"
#import "UserDao.h"

@implementation LoginService

extern NSString* deviceid;

- (int)login:(NSString *)username secondParameter:(NSString *)password
{
    int result = 0;
    
    NSString *postURL = [NSString stringWithFormat:@"http://192.168.1.110:8080/zdezServer/IosClient_StudentLoginCheck"];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:username forKey:@"username"];
    
    [request addPostValue:password forKey:@"password"];
    
    [request addPostValue:deviceid forKey:@"deviceid"];
    
    [request startSynchronous];
    
    NSError *error = request.error;
    if (error == nil) {
        if ([NSJSONSerialization isValidJSONObject:[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:&error]]) {
            // 返回的数据是合法的json格式数据时，将返回的数据写入本地数据库
            ParseJson *pj = [[ParseJson alloc] init];
            User *user = [pj parseLoginCheckMsg:[request responseData]];
            UserDao *dao = [[UserDao alloc] init];
            [dao saveUserInfo:user];
            result = 1;
        } else {
            // 返回为fail时
            result = 0;
        }
    } else {
        // 网络连接不可用时
        result = 2;
    }
    
    /*[request responseData]；后半部分留给徐*/
    
    NSLog(@"My token is: %@", deviceid);
    
    return result;
}

- (BOOL)isLogined
{
    BOOL flag = false;
    UserDao *uDao = [[UserDao alloc] init];
    flag = [uDao isLogined];
    return flag;
}

- (void)logOut
{
    UserDao *dao = [[UserDao alloc] init];
    [dao logOut];
}

@end
