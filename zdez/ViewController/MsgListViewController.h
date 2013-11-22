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

@protocol MsgListViewControllerDelegate;

@interface MsgListViewController : UIViewController <WebContentControllerDelegate, SettingsViewControllerDelegate>

@property (nonatomic, weak) id <MsgListViewControllerDelegate> delegate;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@protocol MsgListViewControllerDelegate

- (void)msgListViewControllerChangeMenuUnreadStatus:(BOOL)newsUnreadStatus isSchoolMsgUnRead:(BOOL)schoolMsgUnreadStatus isZdezMsgUnread:(BOOL)zdezMsgUnReadStatus;

@end
