//
//  PersonInfoViewController.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/16/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *usernameDetails;
@property (weak, nonatomic) IBOutlet UILabel *genderDetails;
@property (weak, nonatomic) IBOutlet UILabel *dptDetails;
@property (weak, nonatomic) IBOutlet UILabel *majorDetails;

@end
