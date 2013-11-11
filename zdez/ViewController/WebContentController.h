//
//  WebContentController.h
//  ZdezClientForIphone
//
//  Created by glu on 13-10-26.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebContentController;

@protocol WebContentControllerDelegate <NSObject>

- (void)webContentControllerDidDone:(WebContentController *)controller;

@end

@interface WebContentController : UIViewController
{
    UIWebView *webView;
}

@property (nonatomic, weak) id <WebContentControllerDelegate> delegate;

- (IBAction)didDone:(id)sender;

@end
