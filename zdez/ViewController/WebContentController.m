//
//  WebContentController.m
//  ZdezClientForIphone
//
//  Created by glu on 13-10-26.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "WebContentController.h"
#import "UIImageView+WebCache.h"

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
    
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    if (size_screen.height <= 480.0f) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 432)];
    } else {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, 510)];
    }
    
    webView.delegate = self;
    
    // 加载html代码
    [webView loadHTMLString:content baseURL:nil];
    
    [self.view addSubview:webView];
    
    [self addTapOnWebView];
}

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [webView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
//    NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        [self showImageURL:urlToSave point:pt];
    }
}

//呈现图片
-(void)showImageURL:(NSString *)url point:(CGPoint)point
{
//    UIImageView *showView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 470)];
//    showView.center = point;
//    [UIView animateWithDuration:0.5f animations:^{
//        CGPoint newPoint = self.view.center;
//        newPoint.y += 20;
//        showView.center = newPoint;
//    }];
//    
//    showView.backgroundColor = [UIColor blackColor];
//    showView.alpha = 0.9;
//    showView.userInteractionEnabled = YES;
//    [self.view addSubview:showView];
//    [showView setImageWithURL:[NSURL URLWithString:url]];
//    
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleViewTap:)];
//    [showView addGestureRecognizer:singleTap];
//    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


//移除图片查看视图
-(void)handleSingleViewTap:(UITapGestureRecognizer *)sender
{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改服务器页面的meta的值
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
    
    //给网页增加utf-8编码
    [webView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagMeta = document.createElement(\"meta\");"
     "tagMeta.setAttribute(\"http-equiv\", \"Content-Type\");"
     "tagMeta.setAttribute(\"content\", \"text/html; charset=utf-8\");"
     "var tagHeadAdd = tagHead.appendChild(tagMeta);"];
    
    //给网页增加css样式
    [webView stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\"BODY{padding: 20pt 15pt}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth, newheight;"
     "var maxwidth=260;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "myimg.setAttribute('style','max-width:260px;height:auto')"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

- (IBAction)didDone:(id)sender {
    [self.delegate webContentControllerDidDone:self];
}
@end
