//
//  FeedbackViewController.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/18/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CPTextViewPlaceholder.h"
#import "UserService.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize tempLabel, textView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    [doneButton setTintColor:[UIColor orangeColor]];
    
    NSArray *buttonArray = [NSArray arrayWithObject:doneButton];
    [topView setItems:buttonArray];
    [self.textView setInputAccessoryView:topView];

    self.textView.placeholder = PLACE_HOLDER;
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyBoard
{
    [self.textView resignFirstResponder];
}
- (IBAction)submit:(id)sender
{
    NSString *feedback = self.textView.text;
    if ([feedback isEqualToString:PLACE_HOLDER]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写您的意见或建议，谢谢！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        UserService *service = [[UserService alloc] init];
        
        [service sendFeedbackMsg:feedback];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交成功，感谢您的配合！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str = [NSString stringWithFormat:@"%@", [alertView buttonTitleAtIndex:buttonIndex]];
    if ([str isEqualToString:@"确定"]){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

@end
