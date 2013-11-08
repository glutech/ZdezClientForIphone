//
//  LoginViewController.m
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 11/5/13.
//  Copyright (c) 2013 Jokinryou Tsui. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize username, password;

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

- (IBAction)login:(id)sender {
    
     //验证登录界面的输入，已可用
//    if (username.text.length == 0 || password.text.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    } else {
//        LoginService *lservice = [[LoginService alloc]init];
//        NSString *usrname = username.text;
//        NSString *pwd = password.text;
//        if ([lservice login:usrname secondParameter:pwd] == 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            return;
//        } else {
//            // 用户名和密码均正确
//            [self performSegueWithIdentifier:@"login" sender:self];
//        }
//    }
    [self performSegueWithIdentifier:@"login" sender:self];
    
    
}
@end
