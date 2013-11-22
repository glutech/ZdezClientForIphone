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

@synthesize categoryList, delegate, isNewsUnreadStatus, isSchoolMsgUnreadStatus, isZdezMsgUnreadStatus, menuTable;

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
    
    NSLog(@"view did load........");
    
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
        if (isNewsUnreadStatus) {
            cell.isUnreadState.image = [UIImage imageNamed:@"unreadStatus.png"];
        } else {
            cell.isUnreadState.image = [UIImage imageNamed:@"noUnreadMsg.png"];
        }
    } else if (indexPath.row == 1) {
        cell.msgImage.image = [UIImage imageNamed:@"msg_type_1.png"];
        if (isSchoolMsgUnreadStatus) {
            cell.isUnreadState.image = [UIImage imageNamed:@"unreadStatus.png"];
        } else {
            cell.isUnreadState.image = [UIImage imageNamed:@"noUnreadMsg.png"];
        }
    } else if (indexPath.row == 2) {
        cell.msgImage.image = [UIImage imageNamed:@"msg_type_2.png"];
        if (isZdezMsgUnreadStatus) {
            cell.isUnreadState.image = [UIImage imageNamed:@"unreadStatus.png"];
        } else {
            cell.isUnreadState.image = [UIImage imageNamed:@"noUnreadMsg.png"];
        }
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

- (void)msgListViewControllerChangeMenuUnreadStatus:(BOOL)newsUnreadStatus isSchoolMsgUnRead:(BOOL)schoolMsgUnreadStatus isZdezMsgUnread:(BOOL)zdezMsgUnReadStatus
{
    self.isNewsUnreadStatus = newsUnreadStatus;
    self.isSchoolMsgUnreadStatus = schoolMsgUnreadStatus;
    self.isZdezMsgUnreadStatus = zdezMsgUnReadStatus;
    
    [self.menuTable reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)opneZdez:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.zdez.cn"]];
}

- (IBAction)openZdezComCn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.zdez.com.cn"]];
}
@end
