//
//  MenuCell.h
//  ZdezClientForIphone
//
//  Created by Jokinryou Tsui on 13-10-22.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *menuItem;
@property (weak, nonatomic) IBOutlet UIImageView *isUnreadState;
@property (weak, nonatomic) IBOutlet UIImageView *msgImage;

@end
