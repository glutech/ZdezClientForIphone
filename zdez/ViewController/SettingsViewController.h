//
//  SettingsViewController.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidDone:(SettingsViewController *)controller;

@end

@interface SettingsViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;

- (IBAction)didDone:(id)sender;

- (IBAction)didLogOut:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *viewUserInfoImage;

@property (weak, nonatomic) IBOutlet UIImageView *modifyPswImage;

@property (weak, nonatomic) IBOutlet UIImageView *bokeTechImage;

@property (weak, nonatomic) IBOutlet UIImageView *softwareImage;

@property (weak, nonatomic) IBOutlet UIImageView *feedbackImage;

@end
