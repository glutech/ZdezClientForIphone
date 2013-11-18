//
//  SettingsViewController.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginService.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    self.viewUserInfoImage.image = [UIImage imageNamed:@"view_user_info.png"];
    self.modifyPswImage.image = [UIImage imageNamed:@"modify_psw.png"];
    self.bokeTechImage.image = [UIImage imageNamed:@"boke_tech.png"];
    self.softwareImage.image = [UIImage imageNamed:@"about_software.png"];
    self.feedbackImage.image = [UIImage imageNamed:@"feedback.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didDone:(id)sender
{
    [self.delegate settingsViewControllerDidDone:self];
}

- (IBAction)didLogOut:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str = [NSString stringWithFormat:@"%@", [alertView buttonTitleAtIndex:buttonIndex]];
    if ([str isEqualToString:@"确定"]){
        LoginService *service = [[LoginService alloc] init];
        if ([service logOut]) {
            
            // 清除NSUserDefaults
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"userId"];
            [userDefaults removeObjectForKey:@"username"];
            
            [userDefaults synchronize];
            
            [self performSegueWithIdentifier:@"logout" sender:self];
        } else {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert1 show];
            return;
        }
 
    }
}

@end
