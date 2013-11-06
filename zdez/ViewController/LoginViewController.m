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
    
//    if ([username.text isEqualToString:@"jokinryou"] && [password.text isEqualToString:@"123"]) {
//        [self performSegueWithIdentifier:@"login" sender:self];
//    }
    LoginService *lservice = [[LoginService alloc]init];
    NSString *usrname = username.text;
    NSString *pwd = password.text;
    [lservice login:usrname secondParameter:pwd];
    
    [self performSegueWithIdentifier:@"login" sender:self];
    
}
@end
