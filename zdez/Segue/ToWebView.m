//
//  ToWebView.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/8/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "ToWebView.h"

@implementation ToWebView

- (void)perform
{
    UIViewController *current = self.sourceViewController;
    UIViewController *next = self.destinationViewController;
    [current presentModalViewController:next animated:YES];
}

@end
