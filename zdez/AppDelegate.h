//
//  AppDelegate.h
//  zdez
//
//  Created by Jokinryou Tsui on 11/6/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability *hostReach;
}

@property (strong, nonatomic) UIWindow *window;

@end
