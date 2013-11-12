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

#import <QuartzCore/QuartzCore.h>

@interface MsgListViewController () <UITableViewDataSource, UITableViewDelegate, MenuViewControllerDelegate, MJRefreshBaseViewDelegate> {
    
//    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    NSMutableArray *_newsList;
    NSMutableArray *_schoolMsgList;
    NSMutableArray *_zdezMsgList;
    NSIndexPath *_selectRow;
    NSString *_htmlContent;
    int *_msgId;
}

@property (nonatomic, weak) IBOutlet UINavigationItem *navigationTitle;
@property (nonatomic, strong) NSArray *msgCategories;
@property (nonatomic, assign) NSInteger selectedCategory;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation MsgListViewController

@synthesize titleLabel;

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
    
    //默认首先进入校园通知
    self.selectedCategory = 1;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    // 上拉加载更多
//    _footer = [[MJRefreshFooterView alloc] init];
//    _footer.delegate = self;
//    _footer.scrollView = self.tableView;
    
    // 假数据
    _newsList = [NSMutableArray array];
    _schoolMsgList = [NSMutableArray array];
    _zdezMsgList = [NSMutableArray array];
    
    NewsDao *newsDao = [[NewsDao alloc] init];
    SchoolMsgDao *schoolMsgDao = [[SchoolMsgDao alloc] init];
    ZdezMsgDao *zdezMsgDao = [[ZdezMsgDao alloc] init];
    
    //设置导航条标题
//    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
//    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
//    titleLabel.textColor = [UIColor colorWithRed:(0.0/255.0) green:(255.0 / 255.0) blue:(0.0 / 255.0) alpha:1];  //设置文本颜色
//    titleLabel.textAlignment = NSTextAlignmentCenter;
////    titleLabel.text = @"新闻咨询";  //设置标题
//    self.navigationItem.titleView = self.titleLabel;
    
    [self refreshViewBeginRefreshing:_header];
    if (self.selectedCategory == 0) {
        _newsList = [newsDao findAll];
    } else if (self.selectedCategory == 1) {
        _schoolMsgList = [schoolMsgDao findAll];
    } else if (self.selectedCategory == 2) {
        _zdezMsgList = [zdezMsgDao findAll];
    }
    
    // 定义侧滑菜单选项
    self.msgCategories = @[@"新闻资讯", @"校园通知", @"找得着"];
    self.navigationTitle.title = self.msgCategories[self.selectedCategory];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [(MenuViewController *)self.slidingViewController.underLeftViewController setDelegate:self];
}

- (void)menuViewControllerDidFinishWithCategoryId:(NSInteger)categoryId
{
    self.selectedCategory = categoryId;
    self.navigationTitle.title = self.msgCategories[self.selectedCategory];
    
    _newsList = [NSMutableArray array];
    _schoolMsgList = [NSMutableArray array];
    _zdezMsgList = [NSMutableArray array];
    
    NewsDao *newsDao = [[NewsDao alloc] init];
    SchoolMsgDao *schoolMsgDao = [[SchoolMsgDao alloc] init];
    ZdezMsgDao *zdezMsgDao = [[ZdezMsgDao alloc] init];
    
    [self refreshViewBeginRefreshing:_header];
    if (self.selectedCategory == 0) {
        _newsList = [newsDao findAll];
    } else if (self.selectedCategory == 1) {
        _schoolMsgList = [schoolMsgDao findAll];
    } else if (self.selectedCategory == 2) {
        _zdezMsgList = [zdezMsgDao findAll];
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
//    [_footer endRefreshing];
    
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

//获取消息上的缩略图，此处也应由网络图片设定
- (UIImage *)imageForMessage:(int)msgId
{
    return [UIImage imageNamed:@"test.jpg"];
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
        NSString *detaStr = [dFormatter stringFromDate:nMsg.date];
        cell.dateLabel.text = detaStr;
        
    } else if (self.selectedCategory == 1) {
        sMsg = _schoolMsgList[indexPath.row];
        
        cell.titleLabel.text = sMsg.title;
        NSString *detaStr = [dFormatter stringFromDate:sMsg.date];
        cell.dateLabel.text = detaStr;
        
    } else if (self.selectedCategory == 2) {
        zMsg = _zdezMsgList[indexPath.row];
        
        cell.titleLabel.text = zMsg.title;
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
    } else if (self.selectedCategory == 1) {
        SchoolMsg *sMsg = _schoolMsgList[indexPath.row];
        SchoolMsgService *sMsgService = [[SchoolMsgService alloc] init];
        _htmlContent = [sMsgService getContent:sMsg.schoolMsgId];
    } else if (self.selectedCategory == 2) {
        ZdezMsg *zMsg = _zdezMsgList[indexPath.row];
        ZdezMsgService *zMsgService = [[ZdezMsgService alloc] init];
        _htmlContent = [zMsgService getContent:zMsg.zdezMsgId];
    }
    
    [self performSegueWithIdentifier:@"toWebContent" sender:self];
}

#pragma mark 代理方法-进入刷新状态就会执行
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (_header == refreshView) {
        // 下拉
        
        if (self.selectedCategory == 0) {
            NewsService *newsService = [[NewsService alloc] init];
            _newsList = [newsService getNews];
            NewsDao *newsDao = [[NewsDao alloc] init];
            [newsDao insert:_newsList];
        } else if (self.selectedCategory == 1) {
            SchoolMsgService *schoolMsgService = [[SchoolMsgService alloc] init];
            _schoolMsgList = [schoolMsgService getSchoolMsg];
            SchoolMsgDao *schoolMsgDao = [[SchoolMsgDao alloc] init];
            [schoolMsgDao insert:_schoolMsgList];
        } else if (self.selectedCategory == 2) {
            ZdezMsgService *zdezMsgService = [[ZdezMsgService alloc] init];
            _zdezMsgList = [zdezMsgService getZdezMsg];
            ZdezMsgDao *zdezMsgDao = [[ZdezMsgDao alloc] init];
            [zdezMsgDao insert:_zdezMsgList];
        }
        
    } else {
        // 上拉
    }
    
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
//    [_footer free];
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
    [self.tableView deselectRowAtIndexPath:_selectRow animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SettingsViewControllerDelegate

- (void)settingsViewControllerDidDone:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
