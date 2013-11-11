//
//  WebContentController.m
//  ZdezClientForIphone
//
//  Created by glu on 13-10-26.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "WebContentController.h"

@interface WebContentController ()

@property(nonatomic,weak)NSString *content;

@end

@implementation WebContentController

@synthesize content;
@synthesize delegate;

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
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 320, 432)];
    
    // 加载html代码
    [webView loadHTMLString:content baseURL:nil];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didDone:(id)sender {
    [self.delegate webContentControllerDidDone:self];
}
@end
