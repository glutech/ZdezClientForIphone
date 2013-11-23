//
//  BokeTechInfoViewController.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "BokeTechInfoViewController.h"

@interface BokeTechInfoViewController ()

@end

@implementation BokeTechInfoViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.zdezInfo.image = [UIImage imageNamed:@"ZDEZ-CN-client.png"];
//    self.zdezInfo.image = [UIImage imageNamed:@"zdezInfo.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
