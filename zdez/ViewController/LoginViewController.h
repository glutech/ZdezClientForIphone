//
//  LoginViewController.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 11/5/13.
//  Copyright (c) 2013 Jokinryou Tsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;

@end
