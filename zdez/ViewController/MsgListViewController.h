//
//  MsgListViewController.h
//  ZdezDemo
//
//  Created by Jokinryou Tsui on 13-10-18.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebContentController.h"
#import "SettingsViewController.h"

@interface MsgListViewController : UIViewController <WebContentControllerDelegate, SettingsViewControllerDelegate>

@property (strong, nonatomic) UILabel *titleLabel;

@end
