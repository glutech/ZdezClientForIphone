//
//  MenuViewController.m
//  ZdezDemo
//
//  Created by Jokinryou Tsui on 13-10-18.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "MenuCell.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MenuViewController

@synthesize categoryList, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:190.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    self.categoryList = @[];
    self.usernameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    NSString *menuName = self.categoryList[indexPath.row];
    
    cell.menuItem.text = menuName;
    if (indexPath.row == 0) {
        cell.msgImage.image = [UIImage imageNamed:@"msg_type_0.png"];
    } else if (indexPath.row == 1) {
        cell.msgImage.image = [UIImage imageNamed:@"msg_type_1.png"];
    } else if (indexPath.row == 2) {
        cell.msgImage.image = [UIImage imageNamed:@"msg_type_2.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate menuViewControllerDidFinishWithCategoryId:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)opneZdez:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.zdez.cn"]];
}
@end
