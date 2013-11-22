//
//  UserService.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "UserService.h"
#import "UserDao.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation UserService

- (BOOL)modifyPassword:(int)userId theOldPassword:(NSString *)oldPsw theNewPassword:(NSString *)newPsw
{
    BOOL flag = false;
    
    NSString *userIdStr = [NSString stringWithFormat:@"%d", userId];
    
    NSString *postURL = [NSString stringWithFormat:@"AndroidClient_ModifyPsw"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:userIdStr forKey:@"id"];
    
    [request addPostValue:oldPsw forKey:@"oldpsw"];
    
    [request addPostValue:newPsw forKey:@"newpsw"];
    
    [request startSynchronous];
    
    NSError *error = request.error;
    if (error == nil) {
        NSString *flagStr = [[NSString alloc] initWithData:[request responseData] encoding:NSASCIIStringEncoding];
        if ([flagStr isEqualToString:@"true"]){
            flag = true;
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    return flag;
}

//- (void)modifyBadge:(int)userId
//{
//    NSString *userIdStr = [NSString stringWithFormat:@"%d", userId];
//    NSString *postURL = [NSString stringWithFormat:@"IosClient_ModifyBadge"];
//    postURL = [HOST_NAME stringByAppendingString:postURL];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
//    
//    [request addPostValue:userIdStr forKey:@"userId"];
//    // 异步处理
//    [request startAsynchronous];
//}

- (User *)getUserInfo
{
    UserDao *dao = [[UserDao alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    tempArray = [dao getUserInfo];
    User *user = [[User alloc] init];
    user = [tempArray objectAtIndex:0];
    return user;
}

- (void)sendFeedbackMsg:(NSString *)feedbackMsg
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int userId = [userDefaults integerForKey:@"userId"];
    NSString *userIdStr = [NSString stringWithFormat:@"%d", userId];
    NSString *postURL = [NSString stringWithFormat:@"AndroidClient_FeedBack"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:userIdStr forKey:@"user_id"];
    [request addPostValue:feedbackMsg forKey:@"feedback"];
    
    [request startAsynchronous];
}

@end
