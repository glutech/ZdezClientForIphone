//
//  SettingsViewController.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginService.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didDone:(id)sender
{
    [self.delegate settingsViewControllerDidDone:self];
}

- (IBAction)didLogOut:(id)sender
{
    [self performSegueWithIdentifier:@"logout" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"logout"]) {
        LoginService *service = [[LoginService alloc] init];
        [service logOut];
    }
}

@end
