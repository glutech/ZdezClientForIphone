//
//  MenuViewController.h
//  ZdezDemo
//
//  Created by Jokinryou Tsui on 13-10-18.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate;

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id <MenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *categoryList;
- (IBAction)opneZdez:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@protocol MenuViewControllerDelegate

- (void)menuViewControllerDidFinishWithCategoryId:(NSInteger)categoryId;

@end
