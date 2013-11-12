//
//  UserService.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "UserService.h"
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

@end
