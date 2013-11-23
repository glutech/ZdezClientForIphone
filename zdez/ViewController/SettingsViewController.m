//
//  SettingsViewController.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginService.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ProgressHUD.h"

@interface SettingsViewController ()
{
    NSString *updateAddress;
}

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
    self.updateImage.image = [UIImage imageNamed:@"update.png"];
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
    alert.tag = 1;
    [alert show];
    return;
}

- (IBAction)checkUpdate:(id)sender {
    
    NSString *appAddr = @"http://itunes.apple.com/lookup?id=";
    appAddr = [appAddr stringByAppendingString:@"764327939"];
    
    NSURL *url = [NSURL URLWithString:appAddr];
    ASIHTTPRequest *versionRequest = [ASIFormDataRequest requestWithURL:url];
    [versionRequest setRequestMethod:@"GET"];
    [versionRequest setDelegate:self];
    [versionRequest setTimeOutSeconds:150];
    [versionRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    [ProgressHUD show:@"请等待..."];
    [versionRequest startAsynchronous];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str = [NSString stringWithFormat:@"%@", [alertView buttonTitleAtIndex:buttonIndex]];
    if ([str isEqualToString:@"确定"]){
        if (alertView.tag == 1) {
            LoginService *service = [[LoginService alloc] init];
            if ([service logOut]) {
                
                // 清除NSUserDefaults
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"userId"];
                [userDefaults removeObjectForKey:@"username"];
                
                [userDefaults synchronize];
                
                // 清除badge
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                
                [self performSegueWithIdentifier:@"logout" sender:self];
            } else {
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert1 show];
                return;
            }
        } else if (alertView.tag == 2) {
//            NSString *iTunesLink = @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=";
//            NSString *appId = [[NSBundle mainBundle] bundleIdentifier];
//            iTunesLink = [iTunesLink stringByAppendingString:appId];
//            iTunesLink = [iTunesLink stringByAppendingString:@"&mt=8"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateAddress]];
        }
 
    }
}

#pragma mark - ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [ProgressHUD dismiss];
    NSString *version = @"";
    
    //Response string of our REST call
    NSData *jsonResponseData = [request responseData];
    
    NSError *error;
    
    NSDictionary *loginAuthenticationResponse = [NSJSONSerialization JSONObjectWithData:jsonResponseData options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *configData = [loginAuthenticationResponse valueForKey:@"results"];
    
    for (id config in configData)
    {
        version = [config valueForKey:@"version"];
        updateAddress = [config valueForKey:@"trackViewUrl"];
    }
    
    // get installed client version
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNum = [infoDict objectForKey:@"CFBundleVersion"];
    
    //Check your version with the version in app store
    if (![version isEqualToString:@""]) {
        if (![version isEqualToString:versionNum])
        {
            UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"有新版本" message: @"软件有新版本可用，请更新！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"下载", nil];
            createUserResponseAlert.tag = 2;
            [createUserResponseAlert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已是最新版本！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络错误，请稍后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    return;
}

@end
