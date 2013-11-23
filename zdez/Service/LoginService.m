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
#import "NewsService.h"
#import "SchoolMsgService.h"
#import "ZdezMsgService.h"

@implementation LoginService

extern NSString* deviceid;

- (int)login:(NSString *)username secondParameter:(NSString *)password
{
    int result = 0;
    
    NSString *postURL = [NSString stringWithFormat:@"IosClient_StudentLoginCheck"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
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
            
            // 用户id保存到NSUserDefaults内
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:user.userId forKey:@"userId"];
            [userDefaults setObject:user.username forKey:@"username"];
            [userDefaults setObject:user.name forKey:@"name"];
            // 保存到磁盘上
            [userDefaults synchronize];
            
            // 修改badge
            NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
            badge += [[[NewsService alloc] init] getUnreadMsgCount];
            badge += [[[SchoolMsgService alloc] init] getUnreadMsgCount];
            badge += [[[ZdezMsgService alloc] init] getUnreadMsgCount];
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            
            result = 1;
        } else {
            // 返回为fail时
            result = 0;
        }
    } else {
        // 网络连接不可用时
        result = 2;
    }
    
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

- (BOOL)logOut
{
    BOOL flag = false;
    
    // 给服务器发送信号，告诉服务器不要再给这个帐号发送推送通知了
    flag = [self noNotificationAnyMore];
    if (flag) {
        UserDao *dao = [[UserDao alloc] init];
        [dao logOut];
    }
    
    return flag;
}

- (void)reLogin
{
    UserDao *dao = [[UserDao alloc] init];
    [dao logOut];
}

- (BOOL)noNotificationAnyMore
{
    BOOL flag = false;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults stringForKey:@"username"];
    NSString *staus = @"106289999";
    
    NSString *postURL = [NSString stringWithFormat:@"Ios_Client_NoNotificationAnyMore"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:username forKey:@"username"];
    
    [request addPostValue:staus forKey:@"staus"];
    
    [request startSynchronous];
    
    NSError *error = request.error;
    if (error == nil) {
        NSString *flagStr = [[NSString alloc] initWithData:[request responseData] encoding:NSASCIIStringEncoding];
        if ([flagStr isEqualToString:@"true"]){
            flag = true;
        }
    }
    
    return flag;
}

@end
