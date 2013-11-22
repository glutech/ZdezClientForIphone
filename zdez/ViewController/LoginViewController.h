//
//  LoginViewController.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 11/5/13.
//  Copyright (c) 2013 Jokinryou Tsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *zdezIcon;

- (IBAction)login:(id)sender;

- (IBAction)editDone:(id)sender;
@end
