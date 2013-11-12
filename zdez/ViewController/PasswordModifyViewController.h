//
//  PasswordModifyViewController.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface PasswordModifyViewController : UIViewController <UIAlertViewDelegate>
@interface PasswordModifyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPsw;

@property (weak, nonatomic) IBOutlet UITextField *nPsw;

@property (weak, nonatomic) IBOutlet UITextField *pswCfm;

- (IBAction)confirmModify:(id)sender;
- (IBAction)editDone:(id)sender;

@end
