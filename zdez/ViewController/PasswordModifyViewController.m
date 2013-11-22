//
//  PasswordModifyViewController.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "PasswordModifyViewController.h"
#import "UserService.h"
#import "LoginService.h"

@interface PasswordModifyViewController ()

@end

@implementation PasswordModifyViewController

@synthesize oldPsw, nPsw, pswCfm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmModify:(id)sender {
    
    if (oldPsw.text.length == 0 || nPsw.text.length == 0 || pswCfm.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"三项均不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    } else {
        if (![nPsw.text isEqualToString:pswCfm.text]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"新密码与确认密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        } else {
            if (pswCfm.text.length < 6 && nPsw.text.length < 6){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"新密码不能少于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                int userId = [userDefaults integerForKey:@"userId"];
                UserService *uService = [[UserService alloc] init];
                if ([uService modifyPassword:userId theOldPassword:oldPsw.text theNewPassword:nPsw.text]) {
                    // 修改成功
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码修改成功，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                } else {
                    // 原密码不正确
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"原密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }
        }
    }
    
}

- (IBAction)editDone:(id)sender {
    [sender resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str = [NSString stringWithFormat:@"%@", [alertView buttonTitleAtIndex:buttonIndex]];
    if ([str isEqualToString:@"确定"]){
        
        LoginService *service = [[LoginService alloc] init];
        [service reLogin];
        
        
        // 清除NSUserDefaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"userId"];
        [userDefaults removeObjectForKey:@"username"];
        
        [userDefaults synchronize];
        
        [self performSegueWithIdentifier:@"relogin" sender:self];
        
//        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

@end
