//
//  MenuViewController.h
//  ZdezDemo
//
//  Created by Jokinryou Tsui on 13-10-18.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgListViewController.h"

@protocol MenuViewControllerDelegate;

@interface MenuViewController : UIViewController <MsgListViewControllerDelegate>

@property (nonatomic, weak) id <MenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *categoryList;

@property (nonatomic) BOOL isNewsUnreadStatus;
@property (nonatomic) BOOL isSchoolMsgUnreadStatus;
@property (nonatomic) BOOL isZdezMsgUnreadStatus;

- (IBAction)opneZdez:(id)sender;
- (IBAction)openZdezComCn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;

@end

@protocol MenuViewControllerDelegate

- (void)menuViewControllerDidFinishWithCategoryId:(NSInteger)categoryId;

@end
