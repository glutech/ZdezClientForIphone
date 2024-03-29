//
//  AppDelegate.m
//  zdez
//
//  Created by Jokinryou Tsui on 11/6/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginService.h"
#import "Reachability.h"

@implementation AppDelegate

NSString *deviceid;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //判断程序是不是由推送服务完成的
    if (launchOptions) {
        // 截取apns推送的消息
        NSDictionary *pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        // 获取推送详情
        NSString *pushInfoStr = [NSString stringWithFormat:@"%@",[pushInfo objectForKey:@"aps"]];
        NSLog(@"userInfo: %@", pushInfoStr);
    }
    
    // 开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //    self.hostReach = [[Reachability reachabilityWithHostName:@"www.apple.com"] init];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    if (height > 500) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // 判断是否已登录过，如果已登录过，则直接进入程序主界面，否则进入登录页面
        LoginService *ls = [[LoginService alloc] init];
        if (ls.isLogined) {
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"initialView"];
        } else {
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        }
        
        [self.window makeKeyAndVisible];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main35" bundle:nil];
        
        // 判断是否已登录过，如果已登录过，则直接进入程序主界面，否则进入登录页面
        LoginService *ls = [[LoginService alloc] init];
        if (ls.isLogined) {
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"initialView"];
        } else {
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        }
        
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //deviceid = [[NSString alloc] initWithData:deviceToken  encoding:NSUTF8StringEncoding];
    deviceid = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //处理推送消息
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // 判断是否已登录过，如果已登录过，则直接进入程序主界面，否则进入登录页面
    LoginService *ls = [[LoginService alloc] init];
    if (ls.isLogined) {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"initialView"];
    } else {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    }
    
    [self.window makeKeyAndVisible];
}

// 连接改变
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

// 处理连接改变后的情况
- (void)updateInterfaceWithReachability:(Reachability *)curReach
{
    // 对连接改变做出响应的处理动作
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"找得着" message:@"当前无网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

// 禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
