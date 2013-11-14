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

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id <MenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *categoryList;

@end

@protocol MenuViewControllerDelegate

- (void)menuViewControllerDidFinishWithCategoryId:(NSInteger)categoryId;

@end
