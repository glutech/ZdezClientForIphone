//
//  WebContentController.m
//  ZdezClientForIphone
//
//  Created by glu on 13-10-26.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "WebContentController.h"

@interface WebContentController ()

@property(nonatomic,weak)NSString *address;

@end

@implementation WebContentController

@synthesize address;

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
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, 320, 480)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
