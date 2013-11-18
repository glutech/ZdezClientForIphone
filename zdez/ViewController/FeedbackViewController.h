//
//  FeedbackViewController.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/18/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTextViewPlaceholder.h"

# define PLACE_HOLDER @"写下您对本软件或本公司的建议，帮助我们改进，谢谢!"

@interface FeedbackViewController : UITableViewController

@property (weak, nonatomic) IBOutlet CPTextViewPlaceholder *textView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

- (IBAction)submit:(id)sender;

@end
