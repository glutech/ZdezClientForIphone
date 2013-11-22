//
//  MsgListViewController.m
//  ZdezDemo
//
//  Created by Jokinryou Tsui on 13-10-18.
//  Copyright (c) 2013年 Jokinryou Tsui. All rights reserved.
//

#import "MsgListViewController.h"

#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "MJRefresh.h"
#import "MsgCell.h"
#import "SchoolMsg.h"
#import "SchoolMsgDao.h"
#import "SchoolMsgService.h"
#import "News.h"
#import "NewsDao.h"
#import "NewsService.h"
#import "ZdezMsg.h"
#import "ZdezMsgDao.h"
#import "ZdezMsgService.h"
#import "WebContentController.h"
#import "SettingsViewController.h"
#import "UserService.h"
#import "ASIHTTPRequest.h"
#import "ParseJson.h"
#import "Reachability.h"

#import <QuartzCore/QuartzCore.h>

@interface MsgListViewController () <UITableViewDataSource, UITableViewDelegate, MenuViewControllerDelegate, MJRefreshBaseViewDelegate> {
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    NSMutableArray *_newsList;
    NSMutableArray *_schoolMsgList;
    NSMutableArray *_zdezMsgList;
    NSIndexPath *_selectRow;
    NSString *_htmlContent;
    int _msgId;
    
    // 记录刷新次数，用于分段加载信息
    int _newsRefreshCount;
    int _sMsgRefreshCount;
    int _zMsgRefreshCount;
    
    BOOL newsUnreadStatus;
    BOOL schoolMsgUnreadStatus;
    BOOL zdezMsgUnreadStatus;
    
    NSInteger newsUnreadCount;
    NSInteger schoolMsgUnreadCount;
    NSInteger zdezMsgUnreadCount;
}

@property (nonatomic, weak) IBOutlet UINavigationItem *navigationTitle;
@property (nonatomic, strong) NSArray *msgCategories;
@property (nonatomic, assign) NSInteger selectedCategory;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) Reachability *hostReach;

@end

@implementation MsgListViewController

@synthesize titleLabel, delegate;

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
    
    // 开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //    self.hostReach = [[Reachability reachabilityWithHostName:@"www.apple.com"] init];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [self.hostReach startNotifier];
//    [self updateInterfaceWithReachability:self.hostReach];
    
    newsUnreadCount = 0;
    schoolMsgUnreadCount = 0;
    zdezMsgUnreadCount = 0;
    
    //默认首先进入资讯频道
    self.selectedCategory = 0;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
    // 数据
    _newsList = [NSMutableArray array];
    _schoolMsgList = [NSMutableArray array];
    _zdezMsgList = [NSMutableArray array];
    
    _newsRefreshCount = 1;
    _sMsgRefreshCount = 1;
    _zMsgRefreshCount = 1;
    
    NewsService *newsService = [[NewsService alloc] init];
    SchoolMsgService *sMsgService = [[SchoolMsgService alloc] init];
    ZdezMsgService *zMsgService = [[ZdezMsgService alloc] init];
    
    // view初始化时就进行刷新，并获取数据库中最新的20条数据
    [self refreshViewBeginRefreshing:_header];
    if (self.selectedCategory == 0) {
        _newsList = [newsService getByRefreshCount:_newsRefreshCount];
    } else if (self.selectedCategory == 1) {
        _schoolMsgList = [sMsgService getByRefreshCount:_sMsgRefreshCount];
    } else if (self.selectedCategory == 2) {
        _zdezMsgList = [zMsgService getByRefreshCount:_zMsgRefreshCount];
    }
    
    // 定义侧滑菜单选项
    self.msgCategories = @[@"资讯频道", @"校园频道", @"找得着"];
    self.navigationTitle.title = self.msgCategories[self.selectedCategory];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nv_bg.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [(MenuViewController *)self.slidingViewController.underLeftViewController setDelegate:self];
    self.delegate = (MenuViewController *)self.slidingViewController.underLeftViewController;
}

// 用户点击菜单栏中的某一项时
- (void)menuViewControllerDidFinishWithCategoryId:(NSInteger)categoryId
{
    
    self.selectedCategory = categoryId;
    self.navigationTitle.title = self.msgCategories[self.selectedCategory];
    
    _newsList = [NSMutableArray array];
    _schoolMsgList = [NSMutableArray array];
    _zdezMsgList = [NSMutableArray array];
    
    NewsService *newsService = [[NewsService alloc] init];
    SchoolMsgService *sMsgService = [[SchoolMsgService alloc] init];
    ZdezMsgService *zMsgService = [[ZdezMsgService alloc] init];
    
    // 从服务器获取最新信息
    [self refreshViewBeginRefreshing:_header];
    
    // 并取得数据库中的最新的20条信息进行显示
    if (self.selectedCategory == 0) {
        _newsList = [newsService getByRefreshCount:1];
    } else if (self.selectedCategory == 1) {
        _schoolMsgList = [sMsgService getByRefreshCount:1];
    } else if (self.selectedCategory == 2) {
        _zdezMsgList = [zMsgService getByRefreshCount:1];
    }
    [self.tableView reloadData];
    [self.slidingViewController resetTopView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add a shadow to the top view so it looks like it is on the top of the others
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    // Tell it which view should be created under left
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]){
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
        
        [(MenuViewController *)self.slidingViewController.underLeftViewController setCategoryList:self.msgCategories];
    }
    
    // Add the pan gesture to allow sliding
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    
    int count = 0;
    
    if (self.selectedCategory == 0) {
        count = _newsList.count;
    } else if (self.selectedCategory == 1) {
        count = _schoolMsgList.count;
    } else if (self.selectedCategory == 2) {
        count = _zdezMsgList.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MsgCell *cell = (MsgCell *)[tableView dequeueReusableCellWithIdentifier:@"MsgCell"];
    
    SchoolMsg *sMsg = [[SchoolMsg alloc] init];
    ZdezMsg *zMsg = [[ZdezMsg alloc] init];
    News *nMsg = [[News alloc] init];
    
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (self.selectedCategory == 0) {
        nMsg = _newsList[indexPath.row];
        
        cell.titleLabel.text = nMsg.title;
        // 如果信息未读
        if (nMsg.isRead == 0) {
            // 设置标题颜色为橘黄色
            cell.titleLabel.textColor = [UIColor orangeColor];
        } else {
            // 如果信息已读，则标题为黑色
            cell.titleLabel.textColor = [UIColor blackColor];
        }
        NSString *detaStr = [dFormatter stringFromDate:nMsg.date];
        cell.dateLabel.text = detaStr;
        
    } else if (self.selectedCategory == 1) {
        sMsg = _schoolMsgList[indexPath.row];
        
        cell.titleLabel.text = sMsg.title;
        if (sMsg.isRead == 0) {
            cell.titleLabel.textColor = [UIColor orangeColor];
        } else {
            cell.titleLabel.textColor = [UIColor blackColor];
        }
        NSString *detaStr = [dFormatter stringFromDate:sMsg.date];
        cell.dateLabel.text = detaStr;
        
    } else if (self.selectedCategory == 2) {
        zMsg = _zdezMsgList[indexPath.row];
        
        cell.titleLabel.text = zMsg.title;
        if (zMsg.isRead == 0) {
            cell.titleLabel.textColor = [UIColor orangeColor];
        } else {
            cell.titleLabel.textColor = [UIColor blackColor];
        }
        NSString *detaStr = [dFormatter stringFromDate:zMsg.date];
        cell.dateLabel.text = detaStr;
        
    }
    
    return cell;
}

//列表项选中的事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 用于返回时清除已选项
    _selectRow = indexPath;
    
    if (self.selectedCategory == 0) {
        News *n = _newsList[indexPath.row];
        NewsService *newsService = [[NewsService alloc] init];
        _htmlContent = [newsService getContent:n.newsId];
        
        // 设置已读
        if (n.isRead == 0 ) {
            [newsService changeIsReadState:n];
            
            // 已读，角标-1
            NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
            if (badge > 0) {
                badge--;
                [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            }
            
            // 更改被点击信息条目的已读标志位，用于改变标题颜色
            n.isRead = 1;
            _newsList[indexPath.row] = n;
        }
        
    } else if (self.selectedCategory == 1) {
        SchoolMsg *sMsg = _schoolMsgList[indexPath.row];
        SchoolMsgService *sMsgService = [[SchoolMsgService alloc] init];
        _htmlContent = [sMsgService getContent:sMsg.schoolMsgId];
        
        // 设置已读
        if (sMsg.isRead == 0) {
            [sMsgService changeIsReadState:sMsg];
            
            NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
            if (badge > 0) {
                badge--;
                [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            }
            // 更改被点击信息条目的已读标志位，用于改变标题颜色
            sMsg.isRead = 1;
            _schoolMsgList[indexPath.row] = sMsg;
        }
        
    } else if (self.selectedCategory == 2) {
        ZdezMsg *zMsg = _zdezMsgList[indexPath.row];
        ZdezMsgService *zMsgService = [[ZdezMsgService alloc] init];
        _htmlContent = [zMsgService getContent:zMsg.zdezMsgId];
        
        // 设置已读
        if (zMsg.isRead == 0) {
            [zMsgService changeIsReadState:zMsg];
            
            NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
            if (badge > 0) {
                badge--;
                [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            }
            // 更改被点击信息条目的已读标志位，用于改变标题颜色
            zMsg.isRead = 1;
            _zdezMsgList[indexPath.row] = zMsg;
        }
        
    }
    
    [self performSegueWithIdentifier:@"toWebContent" sender:self];
}

#pragma mark 代理方法-进入刷新状态就会执行
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    // 开始刷新的时候把所有信息的未读数和状态均初始化
    newsUnreadCount = 0;
    schoolMsgUnreadCount = 0;
    zdezMsgUnreadCount = 0;
    
    if (_header == refreshView) {
        // 下拉
        
        if (self.selectedCategory == 0) {
            NewsService *newsService = [[NewsService alloc] init];
            ASIHTTPRequest *request = [newsService getNewsRequest];
            [request setDelegate:self];
            [request startAsynchronous];
        } else if (self.selectedCategory == 1) {
            SchoolMsgService *schoolMsgService = [[SchoolMsgService alloc] init];
            ASIHTTPRequest *request = [schoolMsgService getRequest];
            [request setDelegate:self];
            [request startAsynchronous];
        } else if (self.selectedCategory == 2) {
            ZdezMsgService *zdezMsgService = [[ZdezMsgService alloc] init];
            ASIHTTPRequest *request = [zdezMsgService getRequest];
            [request setDelegate:self];
            [request startAsynchronous];
        }
        
    } else {
        // 上拉
        
        if (self.selectedCategory == 0) {
            NewsService *newsService = [[NewsService alloc] init];
            _newsRefreshCount ++;
            NSMutableArray *tempList = [newsService getByRefreshCount:_newsRefreshCount];
            for (int i=0; i<[tempList count]; i++) {
                [_newsList addObject:[tempList objectAtIndex:i]];
            }
        } else if (self.selectedCategory == 1) {
            SchoolMsgService *schoolMsgService = [[SchoolMsgService alloc] init];
            _sMsgRefreshCount ++;
            NSMutableArray *tempList = [schoolMsgService getByRefreshCount:_sMsgRefreshCount];
            for (int i=0; i<[tempList count]; i++) {
                [_schoolMsgList addObject:[tempList objectAtIndex:i]];
            }
        } else if (self.selectedCategory == 2) {
            ZdezMsgService *zdezMsgService = [[ZdezMsgService alloc] init];
            _zMsgRefreshCount ++;
            NSMutableArray *tempList = [zdezMsgService getByRefreshCount:_zMsgRefreshCount];
            for (int i=0; i<[tempList count]; i++) {
                [_zdezMsgList addObject:[tempList objectAtIndex:i]];
            }
        }
    }
    
    // 拿到数据后，刷新列表
    [NSTimer scheduledTimerWithTimeInterval:1 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
    
}

//从标题列表跳转到web content的传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toWebContent"]) //"toWebContent"是SEGUE连线的标识
    {
        UINavigationController *navigationController = segue.destinationViewController;
        WebContentController *webContentController = [[navigationController viewControllers] objectAtIndex:0];
        webContentController.delegate = self;
        [webContentController setValue:_htmlContent forKey:@"content"];
    } else if ([segue.identifier isEqualToString:@"toSettings"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SettingsViewController *settingsViewController = [[navigationController viewControllers] objectAtIndex:0];
        settingsViewController.delegate = self;
    }
}

- (void)dealloc
{
    [_footer free];
    [_header free];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebContentControllerDelegate

- (void)webContentControllerDidDone:(WebContentController *)controller
{
    if (self.selectedCategory == 0) {
        NewsService *nService = [[NewsService alloc] init];
        if ([nService getUnreadMsgCount] > 0) {
            newsUnreadStatus = true;
        } else {
            newsUnreadStatus = false;
        }
    } else if (self.selectedCategory == 1) {
        SchoolMsgService *sService = [[SchoolMsgService alloc] init];
        if ([sService getUnreadMsgCount] > 0) {
            schoolMsgUnreadStatus = true;
        } else {
            schoolMsgUnreadStatus = false;
        }
    } else if (self.selectedCategory == 2) {
        ZdezMsgService *zService = [[ZdezMsgService alloc] init];
        if ([zService getUnreadMsgCount] > 0) {
            zdezMsgUnreadStatus = true;
        } else {
            zdezMsgUnreadStatus = false;
        }
    }
    
    [self.delegate msgListViewControllerChangeMenuUnreadStatus:newsUnreadStatus isSchoolMsgUnRead:schoolMsgUnreadStatus isZdezMsgUnread:zdezMsgUnreadStatus];
    
    [self.tableView deselectRowAtIndexPath:_selectRow animated:YES];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SettingsViewControllerDelegate

- (void)settingsViewControllerDidDone:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ASIHTTPRequst

// 异步加载信息
// 处理获取到的信息
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSMutableArray *arrayDesc = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ParseJson *pj = [[ParseJson alloc] init];
    if (self.selectedCategory == 0) {
        array = [pj parseNewsMsg:[request responseData]];
        int count = [array count];
        for (int i = count-1; i >= 0; i--) {
            [arrayDesc addObject:[array objectAtIndex:i]];
        }
        NewsService *newsService = [[NewsService alloc] init];
        [newsService insert:arrayDesc];
        
        // 告诉服务器我收到这些信息了
        [newsService sendAck:arrayDesc];
        
        // 每次下拉刷新都是加载最新的20条
        _newsRefreshCount = 1;
        _newsList = [newsService getByRefreshCount:_newsRefreshCount];
        
        if ([newsService getUnreadMsgCount] > 0) {
            newsUnreadStatus = true;
        } else {
            newsUnreadStatus = false;
        }
        
    } else if (self.selectedCategory == 1) {
        array = [pj parseSchoolMsg:[request responseData]];
        int count = [array count];
        for (int i = count-1; i >= 0; i--) {
            [arrayDesc addObject:[array objectAtIndex:i]];
        }
        SchoolMsgService *sMsgService = [[SchoolMsgService alloc] init];
        [sMsgService insert:arrayDesc];
        
        // 告诉服务器我收到了这些信息
        [sMsgService sendAck:arrayDesc];
        
        // 每次下拉刷新都是加载最新的20条信息
        _sMsgRefreshCount = 1;
        _schoolMsgList = [sMsgService getByRefreshCount:_sMsgRefreshCount];
        
        if ([sMsgService getUnreadMsgCount] > 0) {
            schoolMsgUnreadStatus = true;
        } else {
            schoolMsgUnreadStatus = false;
        }
        
    } else if (self.selectedCategory == 2) {
        array = [pj parseZdezMsg:[request responseData]];
        int count = [array count];
        for (int i = count-1; i >= 0; i--) {
            [arrayDesc addObject:[array objectAtIndex:i]];
        }
        ZdezMsgService *zMsgService = [[ZdezMsgService alloc] init];
        [zMsgService insert:arrayDesc];
        
        // 告诉服务器我收到了这些信息
        [zMsgService sendAck:arrayDesc];
        
        // 每次下拉刷新都是加载最新的20条信息
        _zMsgRefreshCount = 1;
        _zdezMsgList = [zMsgService getByRefreshCount:_zMsgRefreshCount];
        
        if ([zMsgService getUnreadMsgCount] > 0) {
            zdezMsgUnreadStatus = true;
        } else {
            zdezMsgUnreadStatus = false;
        }
        
    }
    
    // 更改角标
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge = badge + [arrayDesc count];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    // 告诉menuView要根据三种信息的未读状态更新menu项了
    [self.delegate msgListViewControllerChangeMenuUnreadStatus:newsUnreadStatus isSchoolMsgUnRead:schoolMsgUnreadStatus isZdezMsgUnread:zdezMsgUnreadStatus];
    
}

// 请求失败时
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    if (self.selectedCategory == 0) {
        NewsService *nService = [[NewsService alloc] init];
        if ([nService getUnreadMsgCount] > 0) {
            newsUnreadStatus = true;
        } else {
            newsUnreadStatus = false;
        }
    } else if (self.selectedCategory == 1) {
        SchoolMsgService *sService = [[SchoolMsgService alloc] init];
        if ([sService getUnreadMsgCount] > 0) {
            schoolMsgUnreadStatus = true;
        } else {
            schoolMsgUnreadStatus = false;
        }
    } else if (self.selectedCategory == 2) {
        ZdezMsgService *zService = [[ZdezMsgService alloc] init];
        if ([zService getUnreadMsgCount] > 0) {
            zdezMsgUnreadStatus = true;
        } else {
            zdezMsgUnreadStatus = false;
        }
    }
    
    [self.delegate msgListViewControllerChangeMenuUnreadStatus:newsUnreadStatus isSchoolMsgUnRead:schoolMsgUnreadStatus isZdezMsgUnread:zdezMsgUnreadStatus];
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

@end
