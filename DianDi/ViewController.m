//
//  ViewController.m
//  DianDi
//
//  Created by ㊣Trying-X™ on 13-12-3.
//  Copyright (c) 2013年 Gavin. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/NSString+Common.h>
#import "AGViewDelegate.h"
#import "AppDelegate.h"
#import <RenRenConnection/RenRenConnection.h>
//#import <ShareSDK/ShareSDK.h>
#import "NewsInfo.h"
#import "UIImageView+WebCache.h"
#import "NBRequestManager.h"
#import "MJRefresh.h"

@interface ViewController()  <MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSMutableArray *_deals;
}
@end

@implementation ViewController
{
    NSMutableArray *newsInfoArray;
}

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

-(void)awakeFromNib
{
    newsInfoArray = [[NSMutableArray alloc]init];
}
- (void)request:(NBRequestManager *)request didFinishLoadingWithInfo:(id)info
{
    NSArray *tempArray = [info objectForKey:@"news"];
    for (NSDictionary *item in tempArray) {
        self.newsInfo = [[NewsInfo alloc]init];
        self.newsInfo.title = [item objectForKey:@"title"];
        self.newsInfo.summary = [item objectForKey:@"summary"];
        self.newsInfo.newsUrl = [item objectForKey:@"newsUrl"];
        self.newsInfo.picUrl = [item objectForKey:@"picUrl"];
        self.newsInfo.commentCount = [item objectForKey:@"commentCount"];
        self.newsInfo.publishDate = [item objectForKey:@"PUBLISHDATE"];
        self.newsInfo.lastUpdateTime = [self dateFormatterFromString:[item objectForKey:@"lastUpdateTime"]];
        [newsInfoArray addObject:self.newsInfo];
    }
    [self.newsTV reloadData];
}
#pragma mark -dateFormatterString
-(NSString *)dateFormatterFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormtter = [[NSDateFormatter alloc]init];
    [dateFormtter setDateFormat:@"MM月dd日"];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[dateString integerValue]];
    
    return [dateFormtter stringFromDate:date];
}
#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) { // 下拉刷新
        _startRecord +=30;
        [self.requestManager URLRefresh:self.startRecord];
        
        // 2秒后刷新表格
        [self performSelector:@selector(reloadDeals) withObject:nil afterDelay:2];
    }
}
- (void)reloadDeals
{
//    [self.newsTV reloadData];
    // 结束刷新状态
    [_header endRefreshing];
    [_footer endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.startRecord = 1;
    //网络请求
    NBRequestManager *requestManager = [NBRequestManager sharedRequest];
    requestManager.delegate = self;
    
    [requestManager URLRefresh:self.startRecord];
    //上下拉刷新
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained ViewController *vc = self;
    
    // 3.3行集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.newsTV;
    _header.delegate = self;
    
    // 4.3行集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.newsTV;
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        _startRecord +=30;
        // 增加5个假数据
        [requestManager URLRefresh:self.startRecord];
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:2];
    };
    
    // 5.0.5秒后自动下拉刷新
    [_header performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.5];
    
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    //对菜单栏的手势
    self.diandikaiqi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTodiandikaiqi:)];
    _diandikaiqi.numberOfTapsRequired = 1;
    _diandikaiqi.numberOfTouchesRequired = 1;
    [self.DianDiKaiQI addGestureRecognizer:_diandikaiqi];
    self.xiritoutiao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickToxiritoutiao:)];
    _xiritoutiao.numberOfTapsRequired = 1;
    _xiritoutiao.numberOfTouchesRequired = 1;
    [self.XiRiTouTiao addGestureRecognizer:_xiritoutiao];
    self.tushuoshijie = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTotushuoshijie:)];
    _tushuoshijie.numberOfTapsRequired = 1;
    _tushuoshijie.numberOfTouchesRequired = 1;
    [self.TuShuoTianXia addGestureRecognizer:_tushuoshijie];
    self.jujiao_redian = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTojujiaoredian:)];
    self.jujiao_redian.numberOfTapsRequired = 1;
    self.jujiao_redian.numberOfTouchesRequired = 1;
    [self.JuJiaoReDian addGestureRecognizer:self.jujiao_redian];
    self.wodeguanzhu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTowodeguanzhu:)];
    _wodeguanzhu.numberOfTapsRequired = 1;
    _wodeguanzhu.numberOfTouchesRequired = 1;
    [self.WoDeGuanZhu addGestureRecognizer:_wodeguanzhu];
    self.xitongshezhi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickToxitongshezhi:)];
    _xitongshezhi.numberOfTapsRequired = 1;
    _xitongshezhi.numberOfTouchesRequired = 1;
    [self.XiTongSheZhi addGestureRecognizer:_xitongshezhi];
    
#pragma mark - 初始化状态
    self.state_frame = @"新闻列表";
    self.state_news = @"再次";
    
#pragma mark 初始化开始版块为点滴开启
    self.bankuai = 1;
    
#pragma mark 初始化新闻列表页标题位置状态
    self.state_title = 1;
    
#pragma mark 初始化打开页面天色状态
    self.state_Tian = 1;
    
#pragma mark 弹窗状态
    self.state_Tanchuang = 1;
    
#pragma mark 关注状态
    self.state_guanzhu = 0;
    
#pragma mark 分享弹窗视图状态
    self.state_share = 0;
    
    self.show_All.hidden = YES;
    //关于点滴View
    self.about = [[UIView alloc] initWithFrame:CGRectMake(200, 341, 2, 2)];
    self.about.backgroundColor = [UIColor whiteColor];
    self.about.alpha = 0.0;
    self.about.hidden = YES;
    [self.view addSubview:self.about];
    
    //关于点滴文本信息
    self.about_info = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 5, 5)];
    self.about_info.textAlignment = 1;
    self.about_info.font = [UIFont systemFontOfSize:14];
    self.about_info.text = @"㊣Trying-X™ • 激情为梦想而生版权所有";
    self.about_info.lineBreakMode = NSLineBreakByCharWrapping;
    self.about_info.numberOfLines = 0;
    [self.about addSubview:self.about_info];
    
    self.diandi_logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.diandi_logo.frame = CGRectMake(0, 0, 10, 10);
    [self.about addSubview:self.diandi_logo];
    
    self.about_text = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    self.about_text.text = @"关于点滴";
    [self.about addSubview:self.about_text];
    
    self.about_less = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    [self.about_less setTitle:@"取消" forState:UIControlStateNormal];
    [self.about_less setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.about_less.tintColor = [UIColor blackColor];
    [self.about_less addTarget:self action:@selector(didChangeToAbout) forControlEvents:UIControlEventTouchUpInside];
    [self.about addSubview:self.about_less];
    
    //新闻详情网页页面
    self.newsinfo = [[UIWebView alloc] initWithFrame:CGRectMake(218, 85, 581, 681)];
    self.newsinfo.backgroundColor = [UIColor whiteColor];
    self.newsinfo.alpha = 1;
    self.newsinfo.hidden = YES;
    self.newsinfo.delegate = self;
    
    //新闻详情页面标题
    self.tintV = [[UIView alloc] initWithFrame:CGRectMake(Heng_Before_NewsTV_x, StateColumn, Heng_After_NewsV_x-Heng_Before_NewsTV_x, Bar_height)];
    self.tintL = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 200, 60)];
    self.tintL.font = [UIFont fontWithName:@"Chalkboard SE" size:28.0f];
    self.tintL.text = @"新闻详情";
    self.tintL.textAlignment = NSTextAlignmentCenter;
    self.tintL.hidden = YES;
    self.tintL.textColor = [UIColor whiteColor];
    self.tintV.backgroundColor = [UIColor colorWithRed:0.345098 green:0.560784 blue:0.996078 alpha:1];
    self.tintV.alpha = 1;
    self.tintV.hidden = YES;
    [self.tintV addSubview:self.tintL];
    [self.view addSubview:self.tintV];
    
    //分享按钮
    self.share = [[UIButton alloc] initWithFrame:CGRectMake(470, 13, 40, 40)];
    [_share
     setTitle:@"分享" forState:UIControlStateNormal];
    [_share setImage:[UIImage imageNamed:@"fenxiang.png"] forState:UIControlStateNormal];
    _share.titleLabel.font = [UIFont systemFontOfSize:23.0];
    [_share setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_share addTarget:self action:@selector(didChangeToShare) forControlEvents:UIControlEventTouchUpInside];
    
    //关注按钮
    self.guanzhu = [[UIButton alloc] initWithFrame:CGRectMake(520, 20, 30, 30)];
    [_guanzhu setTitle:@"关注" forState:UIControlStateNormal];
    [_guanzhu setImage:[UIImage imageNamed:@"guanzhu1.png"] forState:UIControlStateNormal];
    _guanzhu.titleLabel.font = [UIFont systemFontOfSize:23.0];
    [_guanzhu setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [_guanzhu addTarget:self action:@selector(didChangeToGuanzhu) forControlEvents:UIControlEventTouchUpInside];
    
    //分享界面
    self.share_View = [[UIView alloc] initWithFrame:CGRectMake(380, 0, 200, 2)];
    self.share_View.alpha = 0.2;
    self.share_View.backgroundColor = [UIColor colorWithRed:0.345098 green:0.560784 blue:0.996078 alpha:0.75];
    self.share_View.hidden = YES;
    [self.newsinfo addSubview:self.share_View];

    
    //关注页面
    self.guanzhu_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 580, 40)];
    self.guanzhu_View.alpha = 0.2;
    self.guanzhu_View.backgroundColor = [UIColor redColor];
    self.guanzhu_View.hidden = YES;
    
    //关注页面显示内容
    self.guanzhu_sucess = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 100, 40)];
    _guanzhu_sucess.text = @"关注成功";
    _guanzhu_sucess.font = [UIFont boldSystemFontOfSize:20];
    _guanzhu_sucess.textColor = [UIColor whiteColor];
    [self.guanzhu_View addSubview:_guanzhu_sucess];
    
    [self.newsinfo addSubview:self.guanzhu_View];
    [self.view addSubview:self.newsinfo];
    [self.tintV addSubview:_share];
    [self.tintV addSubview:_guanzhu];

    //初始化时间表界面隐藏
    self.time_list_view.hidden = YES;
    
}

#pragma mark - tableview的Cell设置
//返回群组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
//返回群组内的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.set_View) {
        return 7;
    }else if (tableView == self.share_list){
        return 5;
    }else{
        NSLog(@"luge%@",[newsInfoArray description]);
        return newsInfoArray.count;
    }
}
//返回群组内每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.set_View) {
        return 57.1;
    }else if (tableView == self.share_list){
        return 70;
    }else{
        return 170;
    }
}
#pragma mark -  清除缓存
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.set_View) {
        if (indexPath.row == 1) {
            NSArray *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [caches objectAtIndex:0];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:cachePath error:nil];
            if ([fileManager isDeletableFileAtPath:cachePath]) {
                [fileManager removeItemAtPath:cachePath error:nil];
                [fileManager setAttributes:attributes ofItemAtPath:cachePath error:nil];
                UIAlertView *guanzhu = [[UIAlertView alloc]initWithTitle:@"系统提示" message:@"清除缓存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [guanzhu show];
            }
        }
    }
}

//设置行内显示内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //判断哪一个tableview
    if (tableView == self.set_View) {
        
        //取得指定的newsCell
        static NSString *newsCellIdentifier = @"set_Cell";
        UITableViewCell *set_cell = [tableView dequeueReusableCellWithIdentifier:
                                     newsCellIdentifier];
        
        if (!set_cell) {
            set_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellIdentifier];
        }
        //设置tableview不能滚动
        self.set_View.scrollEnabled = NO;
        
        //设置分割线样式
        self.set_View.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //设置Cell中每一行被选中时的样式
        set_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
            {
                set_cell.textLabel.text = @"系统 • 设置";
                set_cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
                set_cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
                break;
            case 1:
            {
                set_cell.textLabel.text = @"清除缓存";
                set_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.75];
                
                
                
                [UIView commitAnimations];
                
            }
                break;
            case 2:
            {
                set_cell.textLabel.text = @"关于点滴";
                set_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                UITapGestureRecognizer *about_gesturerecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChangeToAbout)];
                [set_cell addGestureRecognizer:about_gesturerecognizer];
            }
                break;
            case 3:
            {
                set_cell.textLabel.text = @"意见反馈";
                set_cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
                break;
            case 4:
            {
                set_cell.textLabel.text = @"取消";
                set_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                UITapGestureRecognizer *set_quxiao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChangeToquxiao)];
                [set_cell addGestureRecognizer:set_quxiao];
            }
                break;
            default:
                break;
        }
        return set_cell;
    }else if(tableView == self.share_list){
        //取得指定的newsCell
        static NSString *newsCellIdentifier = @"share_Cell";
        UITableViewCell *share_cell = [tableView dequeueReusableCellWithIdentifier:
                                     newsCellIdentifier];
        
        if (!share_cell) {
            share_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellIdentifier];
        }
        //设置tableview不能滚动
        self.share_list.scrollEnabled = NO;
        
        //设置分割线样式
        self.share_list.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //设置Cell中每一行被选中时的样式
        share_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
            {
                share_cell.textLabel.text = @"分享到新浪微博";
                share_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                share_cell.backgroundColor = [UIColor clearColor];
            }
                break;
            case 1:
            {
                share_cell.textLabel.text = @"分享到腾讯微博";
                share_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                share_cell.backgroundColor = [UIColor clearColor];
            }
                break;
            case 2:
            {
                share_cell.textLabel.text = @"分享到QQ空间";
                share_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                share_cell.backgroundColor = [UIColor clearColor];
            }
                break;
            case 3:
            {
                share_cell.textLabel.text = @"分享到微信";
                share_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                share_cell.backgroundColor = [UIColor clearColor];

            }
                break;
            case 4:
            {
                share_cell.textLabel.text = @"分享到人人";
                share_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                share_cell.backgroundColor = [UIColor clearColor];

            }
                break;
            case 5:
            {
                share_cell.textLabel.text = @"分享到校内";
                share_cell.textLabel.textAlignment = NSTextAlignmentCenter;
                share_cell.backgroundColor = [UIColor clearColor];
            }
                break;
            default:
                break;
        }
        return share_cell;
    }else{
        //取得storyboard中指定的newsCell
        static NSString *news_CellIdentifier = @"news_Cell";
        self.newscell = [tableView dequeueReusableCellWithIdentifier:
                         news_CellIdentifier];
        
        //查看新闻详情手势方法
        self.check_news = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCheckNews:)];
        [self.newscell addGestureRecognizer:self.check_news];
        //        self.state_news = @"收起";
        if ([self.state_news isEqualToString:@"再次"]) {
            NSLog(@"状态显示：%@进入显示",self.state_news);
            self.newsInfo = [newsInfoArray objectAtIndex:indexPath.row];
            switch (self.bankuai) {
                    //点滴开启
                case 1:
                    if ([self.state_frame isEqualToString:@"新闻详情"]) {
                        //进入新闻详情界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        
                        //切换动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        //移除收缩的新闻列表手势
                        [self.newscell removeGestureRecognizer:self.check_news];
                        //显示新闻详情时的显示界面
                        self.newscell.news_image.frame = CGRectMake(35, 55, 165, 110);
                        self.newscell.news_title.frame = CGRectMake(5, 0, 215, 65);
                        self.newscell.news_info.frame = CGRectMake(5, 45, 0, 0);
                        self.newscell.news_time.frame = CGRectMake(685, 5, 0, 0);
                        [UIView commitAnimations];
                        
                        self.newscell.news_title.font = [UIFont boldSystemFontOfSize:16];
                        self.newscell.news_title.lineBreakMode = 0;
                        self.newscell.news_title.numberOfLines = 0;
                        
                        
                        //新闻列表页标题设置
                        self.newstint.text = @"点滴 • 开启";
                        self.newstint.textAlignment = NSTextAlignmentCenter;
                        self.newstint.font = [UIFont fontWithName:@"Chalkboard SE" size:28.0f];
                        self.newstint.frame = CGRectMake(0, 0, Heng_After_NewsV_width - 160, Bar_height);
                        
                        //界面显示状态
                        //隐藏Cell中新闻内容简介
                        self.newscell.news_info.hidden = YES;
                        //隐藏Cell中新闻时间
                        self.newscell.news_time.hidden = YES;
                        //显示新闻详情页标题
                        self.tintL.hidden = NO;
                        //显示新闻详情页webview
                        self.tintV.hidden = NO;
//                        //显示新闻详情内容简介
//                        self.newsinfo.hidden = NO;
                        
                        self.newscell.news_time.text = self.newsInfo.lastUpdateTime;
                        self.newscell.news_title.text = self.newsInfo.title;
                        self.newscell.news_info.text = self.newsInfo.summary;
                        [self.newscell.news_image setImageWithURL:[NSURL URLWithString:self.newsInfo.picUrl] placeholderImage:[UIImage imageNamed:@"logo.png"]];
                        
                    }else{
                        //进入新闻列表界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        
                        //开启动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        
                        //显示新闻列表时的显示界面
                        self.newscell.news_image.frame = CGRectMake(5, 5, 156, 156);
                        self.newscell.news_title.frame = CGRectMake(190, 5, 590, 45);
                        self.newscell.news_info.frame = CGRectMake(180, 50, 590, 105);
                        self.newscell.news_time.frame = CGRectMake(630, 5, 170, 45);
                        
                        self.newscell.news_info.lineBreakMode = NSLineBreakByTruncatingTail;
                        self.newscell.news_info.numberOfLines = 0;
                        //提交动画
                        [UIView commitAnimations];
                        
                        self.newstint.text = @"点滴 • 开启";
                        //设置版块视图显示状态
                        //点滴开启tableview隐藏
                        self.newsTV.hidden = NO;
                        //昔日头条tableview显示
                        self.newstoutiaoTV.hidden = YES;
                        //图说天下tableview隐藏
                        self.newsCV.hidden = YES;
                        //聚焦热点tableview隐藏
                        self.jujiaoredian.hidden = YES;
                        //我的关注tableview隐藏
                        self.myguanzhu.hidden = YES;
                        
                        //显示Cell中新闻内容简介
                        self.newscell.news_info.hidden = NO;
                        //显示Cell中新闻内容时间
                        self.newscell.news_time.hidden = NO;
                        //隐藏新闻详情页标题
                        self.tintL.hidden = YES;
                        //隐藏新闻详情页webview
                        self.tintV.hidden = YES;
                        //隐藏收起新闻列表页的新闻内容view
                        self.newsinfo.hidden = YES;
                        //隐藏收起新闻列表页的新闻标题
                        self.newstint.hidden = NO;
                        //隐藏时间表
                        self.time_list_view.hidden = YES;
                        self.newscell.news_time.text = self.newsInfo.lastUpdateTime;
                        self.newscell.news_title.text = self.newsInfo.title;
                        self.newscell.news_info.text = self.newsInfo.summary;
                        [self.newscell.news_image setImageWithURL:[NSURL URLWithString:self.newsInfo.picUrl] placeholderImage:[UIImage imageNamed:@"logo.png"]];
                        self.newsTV.separatorColor = [UIColor blueColor];
                        self.newsTV.separatorStyle = UITableViewCellSeparatorStyleNone;
                    }
                    break;
                    
                    //昔日头条
                case 2:
                    if ([self.state_frame isEqualToString:@"新闻详情"]) {
                        //进入新闻详情界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        //切换动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        
                        //移除收缩的新闻列表手势
                        [self.newscell removeGestureRecognizer:self.check_news];
                        
                        //显示新闻详情时的显示界面
                        self.newscell.news_image.frame = CGRectMake(35, 50, 160, 160);
                        self.newscell.news_title.frame = CGRectMake(5, 5, 215, 40);
                        
                        
                        //提交动画
                        [UIView commitAnimations];
                        
                        //新闻详情页标题设置
                        self.newstint.text = @"昔日 • 头条";
                        self.newstint.textAlignment = NSTextAlignmentCenter;
                        self.newstint.font = [UIFont fontWithName:@"Chalkboard SE" size:28.0f];
                        self.newstint.frame = CGRectMake(0, 0, Heng_After_NewsV_width - 160, Bar_height);
                        
                        //界面显示状态
                        //隐藏Cell中新闻内容简介
                        self.newscell.news_info.hidden = YES;
                        //显示新闻详情页标题
                        self.tintL.hidden = NO;
                        //显示新闻详情页webview
                        self.tintV.hidden = NO;
                        //显示新闻详情内容简介
                        self.newsinfo.hidden = NO;
                        
                        self.newscell.news_time.text = self.newsInfo.lastUpdateTime;
                        self.newscell.news_title.text = self.newsInfo.title;
                        self.newscell.news_info.text = self.newsInfo.summary;
                        [self.newscell.news_image setImageWithURL:[NSURL URLWithString:self.newsInfo.picUrl] placeholderImage:[UIImage imageNamed:@"logo.png"]];
                        
                    }else{
                        //进入新闻列表界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        
                        //开启动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        
                        //显示新闻列表时的显示界面
                        self.newscell.news_image.frame = CGRectMake(5, 5, 156, 156);
                        self.newscell.news_title.frame = CGRectMake(190, 5, 635, 45);
                        self.newscell.news_info.frame = CGRectMake(180, 50, 600, 105);
                        
                        self.newscell.news_info.lineBreakMode = 0;
                        self.newscell.news_info.numberOfLines = 0;
                        //提交动画
                        [UIView commitAnimations];
                        
                        //改变新闻的版块名称
                        self.newstint.text = @"昔日 • 头条";
                        
                        //设置版块视图显示状态
                        //点滴开启tableview隐藏
                        self.newsTV.hidden = YES;
                        //昔日头条tableview显示
                        self.newstoutiaoTV.hidden = NO;
                        //图说天下tableview隐藏
                        self.newsCV.hidden = YES;
                        //聚焦热点tableview隐藏
                        self.jujiaoredian.hidden = YES;
                        //我的关注tableview隐藏
                        self.myguanzhu.hidden = YES;
                        
                        //设置视图的显示状态
                        //显示Cell中新闻内容简介
                        self.newscell.news_info.hidden = NO;
                        //隐藏新闻详情页标题
                        self.tintL.hidden = YES;
                        //隐藏新闻详情页webview
                        self.tintV.hidden = YES;
                        //隐藏收起新闻列表页的新闻内容view
                        self.newsinfo.hidden = YES;
                        //显示收起新闻列表页的新闻标题
                        self.newstint.hidden = NO;
                        //隐藏tableview的headview
                        self.time_list_view.hidden = YES;
                        //显示时间列表
                        self.time_list_view.hidden = NO;
                        
                        self.newscell.news_time.text = self.newsInfo.lastUpdateTime;
                        self.newscell.news_title.text = self.newsInfo.title;
                        self.newscell.news_info.text = self.newsInfo.summary;
                        NSLog(@"%@",self.newsInfo.commentCount);
                        self.newscell.news_redu.text = [NSString stringWithFormat:@"%@",self.newsInfo.commentCount];
                        [self.newscell.news_image setImageWithURL:[NSURL URLWithString:self.newsInfo.picUrl] placeholderImage:[UIImage imageNamed:@"logo.png"]];
                        
                    }
                    break;
                    //图说天下
                case 3:
                    
                    if ([self.state_frame isEqualToString:@"新闻详情"]) {
                        //进入新闻详情界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        //切换动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        
                        //移除收缩的新闻列表手势
                        [self.newscell removeGestureRecognizer:self.check_news];
                        
                        //显示新闻详情时的显示界面
                        self.newscell.news_image.frame = CGRectMake(35, 50, 160, 160);
                      
                        //提交动画
                        [UIView commitAnimations];
                        
                        //新闻详情页标题设置
                        self.newstint.text = @"图说 • 天下";
                        self.newstint.textAlignment = NSTextAlignmentCenter;
                        self.newstint.font = [UIFont fontWithName:@"Chalkboard SE" size:28.0f];
                        self.newstint.frame = CGRectMake(0, 0, Heng_After_NewsV_width - 160, Bar_height);
                        
                        //界面显示状态
                        //隐藏Cell中新闻内容简介
                        self.newscell.news_info.hidden = YES;
                        //显示新闻详情页标题
                        self.tintL.hidden = NO;
                        //显示新闻详情页webview
                        self.tintV.hidden = NO;
                        //显示新闻详情内容简介
                        self.newsinfo.hidden = NO;
                        
                        [self.newscell.news_image setImageWithURL:[NSURL URLWithString:self.newsInfo.picUrl] placeholderImage:[UIImage imageNamed:@"logo.png"]];
                        
                    }else{
                        
                        //进入新闻列表界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        
                        //改变新闻的版块名称
                        self.newstint.text = @"图说 • 天下";
                        
                        //设置版块视图显示状态
                        //点滴开启tableview隐藏
                        self.newsTV.hidden = YES;
                        //昔日头条tableview显示
                        self.newstoutiaoTV.hidden = YES;
                        //图说天下tableview隐藏
                        self.newsCV.hidden = NO;
                        //聚焦热点tableview隐藏
                        self.jujiaoredian.hidden = YES;
                        //我的关注tableview隐藏
                        self.myguanzhu.hidden = YES;
                        
                        //设置视图的显示状态
                        //显示Cell中新闻内容简介
                        self.newscell.news_info.hidden = YES;
                        //隐藏新闻详情页标题
                        self.tintL.hidden = YES;
                        //隐藏新闻详情页webview
                        self.tintV.hidden = YES;
                        //隐藏收起新闻列表页的新闻内容view
                        self.newsinfo.hidden = YES;
                        //隐藏收起新闻列表页的新闻标题
                        self.newstint.hidden = NO;
                        //隐藏tableview的headview
                        self.time_list_view.hidden = YES;
                        self.show_All.hidden = YES;
                        
                        
                        [self.newscell.news_image setImageWithURL:[NSURL URLWithString:self.newsInfo.picUrl] placeholderImage:[UIImage imageNamed:@"logo.png"]];
                    }
                    break;
                    
                    //聚焦热点
                case 4:
                    if ([self.state_frame isEqualToString:@"新闻详情"]) {
                        //进入新闻详情界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        
                        //切换动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        //移除收缩的新闻列表手势
                        [self.newscell removeGestureRecognizer:self.check_news];
                        //显示新闻详情时的显示界面
                        self.newscell.news_image.frame = CGRectMake(35, 50, 165, 110);
                        self.newscell.news_title.frame = CGRectMake(5, 5, 215, 40);
                        self.newscell.news_info.frame = CGRectMake(5, 45, 0, 0);
                        self.newscell.news_time.frame = CGRectMake(685, 5, 0, 0);
                        [UIView commitAnimations];
                        
                        //新闻详情页标题设置
                        self.newstint.text = @"聚焦 • 热点";
                        self.newstint.textAlignment = NSTextAlignmentCenter;
                        self.newstint.font = [UIFont fontWithName:@"Chalkboard SE" size:28.0f];
                        self.newstint.frame = CGRectMake(0, 0, Heng_After_NewsV_width - 160, Bar_height);
                        
                        //界面显示状态
                        //隐藏Cell中新闻内容简介
                        self.newscell.news_info.hidden = YES;
                        //隐藏Cell中新闻时间
                        self.newscell.news_time.hidden = YES;
                        //显示新闻详情页标题
                        self.tintL.hidden = NO;
                        //显示新闻详情页webview
                        self.tintV.hidden = NO;
                        //显示新闻详情内容简介
                        self.newsinfo.hidden = NO;
                    }else{
                        //进入新闻列表界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        
                        //开启动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        
                        //显示新闻列表时的显示界面
                        self.newscell.news_image.frame = CGRectMake(5, 5, 156, 156);
                        self.newscell.news_title.frame = CGRectMake(167, 5, 513, 45);
                        self.newscell.news_info.frame = CGRectMake(167, 56, 635, 105);
                        self.newscell.news_time.frame = CGRectMake(685, 5, 115, 45);
                        
                        //提交动画
                        [UIView commitAnimations];
                        
                        self.newstint.text = @"聚焦 • 热点";
                        //设置版块视图显示状态
                        //点滴开启tableview隐藏
                        self.newsTV.hidden = NO;
                        //昔日头条tableview显示
                        self.newstoutiaoTV.hidden = YES;
                        //图说天下tableview隐藏
                        self.newsCV.hidden = YES;
                        //聚焦热点tableview隐藏
                        self.jujiaoredian.hidden = YES;
                        //我的关注tableview隐藏
                        self.myguanzhu.hidden = YES;
                        
                        //显示Cell中新闻内容简介
                        self.newscell.news_info.hidden = NO;
                        //显示Cell中新闻内容时间
                        self.newscell.news_time.hidden = NO;
                        //隐藏新闻详情页标题
                        self.tintL.hidden = YES;
                        //隐藏新闻详情页webview
                        self.tintV.hidden = YES;
                        //隐藏收起新闻列表页的新闻内容view
                        self.newsinfo.hidden = YES;
                        //隐藏收起新闻列表页的新闻标题
                        self.newstint.hidden = NO;
                        //隐藏时间表
                        self.time_list_view.hidden = YES;
                        
                    }
                    break;
                    
                    //我的关注
                case 5:
                    if ([self.state_frame isEqualToString:@"新闻详情"]) {
                        //进入新闻详情界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        
                        //切换动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        //移除收缩的新闻列表手势
                        [self.newscell removeGestureRecognizer:self.check_news];
                        //显示新闻详情时的显示界面
                        self.newscell.news_image.frame = CGRectMake(35, 50, 165, 110);
                        self.newscell.news_title.frame = CGRectMake(5, 5, 215, 40);
                        self.newscell.news_info.frame = CGRectMake(5, 45, 0, 0);
                        self.newscell.news_time.frame = CGRectMake(685, 5, 0, 0);
                        [UIView commitAnimations];
                        
                        //新闻详情页标题设置
                        self.newstint.text = @"我的 • 关注";
                        self.newstint.textAlignment = NSTextAlignmentCenter;
                        self.newstint.font = [UIFont fontWithName:@"Chalkboard SE" size:28.0f];
                        self.newstint.frame = CGRectMake(0, 0, Heng_After_NewsV_width - 160, Bar_height);
                        
                        //界面显示状态
                        //隐藏Cell中新闻内容简介
                        self.newscell.news_info.hidden = YES;
                        //隐藏Cell中新闻时间
                        self.newscell.news_time.hidden = YES;
                        //显示新闻详情页标题
                        self.tintL.hidden = NO;
                        //显示新闻详情页webview
                        self.tintV.hidden = NO;
                        //显示新闻详情内容简介
                        self.newsinfo.hidden = NO;
                    }else{
                        //进入新闻列表界面
                        NSLog(@"状态显示：Frame%@状态",self.state_frame);
                        
                        //开启动画
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.75];
                        
                        //显示新闻列表时的显示界面
                        self.newscell.news_image.frame = CGRectMake(5, 5, 156, 156);
                        self.newscell.news_title.frame = CGRectMake(167, 5, 513, 45);
                        self.newscell.news_info.frame = CGRectMake(167, 56, 635, 105);
                        self.newscell.news_time.frame = CGRectMake(685, 5, 115, 45);
                        
                        //提交动画
                        [UIView commitAnimations];
                        
                        self.newstint.text = @"我的 • 关注";
                        //设置版块视图显示状态
                        //点滴开启tableview隐藏
                        self.newsTV.hidden = NO;
                        //昔日头条tableview显示
                        self.newstoutiaoTV.hidden = YES;
                        //图说天下tableview隐藏
                        self.newsCV.hidden = YES;
                        //聚焦热点tableview隐藏
                        self.jujiaoredian.hidden = YES;
                        //我的关注tableview隐藏
                        self.myguanzhu.hidden = YES;
                        
                        //显示Cell中新闻内容简介
                        self.newscell.news_info.hidden = NO;
                        //显示Cell中新闻内容时间
                        self.newscell.news_time.hidden = NO;
                        //隐藏新闻详情页标题
                        self.tintL.hidden = YES;
                        //隐藏新闻详情页webview
                        self.tintV.hidden = YES;
                        //隐藏收起新闻列表页的新闻内容view
                        self.newsinfo.hidden = YES;
                        //隐藏收起新闻列表页的新闻标题
                        self.newstint.hidden = NO;
                        //隐藏时间表
                        self.time_list_view.hidden = YES;
                    }
                    break;
                    
                default:
                    break;
            }
        }else{
            //第一次进入程序的板块视图显示情况=================================
            //显示点滴开启版块的视图
            self.newsTV.hidden = NO;
            //隐藏昔日头条版块的视图
            self.newstoutiaoTV.hidden = YES;
            //隐藏聚焦热点版块的视图
            self.jujiaoredian.hidden = YES;
            //隐藏图说天下版块的视图
            self.newsCV.hidden = YES;
            //隐藏我的关注版块的视图
            self.myguanzhu.hidden = YES;
            //隐藏新闻列表标题view
            self.tintV.hidden = YES;
            //显示新闻列表时的显示界面
            self.news_cell.frame = CGRectMake(20, 20, 20, 20);
            //初始化弹窗状态为0
            self.state_second = 0;
        }
        
        //newsCell内容构建
        return self.newscell;
    }
}
#pragma mark - 图说天下collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return newsInfoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //取得storyboard中指定的newsCell
    static NSString *news_CellIdentifier = @"tushuotianxia";
    self.news_cell = [collectionView dequeueReusableCellWithReuseIdentifier:news_CellIdentifier forIndexPath:indexPath];
    collectionView.alpha = 1;
    self.news_cell.backgroundColor = [UIColor whiteColor];
    self.news_cell.alpha = 1;
    NewsInfo *newsInfo = [newsInfoArray objectAtIndex:indexPath.row];
    [self.news_cell.tushuoshijie_image setImageWithURL:[NSURL URLWithString:newsInfo.picUrl] placeholderImage:[UIImage imageNamed:@"logo.png"]];
    return self.news_cell;
}

#pragma mark - 横扫方法
//横扫查看新闻详情
-(void)didClickCheckNews:(UISwipeGestureRecognizer *)sender{
    
    switch (self.bankuai) {
        case 1:
        {
            CGPoint point = [sender locationInView:self.newsTV];
            self.indexPath = [self.newsTV indexPathForRowAtPoint:point];
        }
            break;
        case 2:
        {
            CGPoint point = [sender locationInView:self.newstoutiaoTV];
            self.indexPath = [self.newstoutiaoTV indexPathForRowAtPoint:point];
        }
            break;
        case 4:
        {
            CGPoint point = [sender locationInView:self.jujiaoredian];
            self.indexPath = [self.jujiaoredian indexPathForRowAtPoint:point];
        }
            break;
        case 5:
        {
            CGPoint point = [sender locationInView:self.myguanzhu];
            self.indexPath = [self.myguanzhu indexPathForRowAtPoint:point];
        }
            break;
        default:
            break;
    }
    
    self.state_news = @"再次";
    NSLog(@"%@",self.state_news);
    self.state_frame = @"新闻详情";
    NSLog(@"%@",self.state_frame);
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.75];
    
    //动画的内容
    self.newsV_diandi.frame = CGRectMake(Heng_After_NewsV_x, StateColumn, Heng_After_NewsV_width, Heng_After_NewsV_height);
    //tableview重载
    switch (self.bankuai) {
        case 1:
            [self.newsTV reloadData];
            break;
        case 2:
            [self.newstoutiaoTV reloadData];
            break;
        case 4:
            [self.jujiaoredian reloadData];
            break;
        case 5:
            [self.myguanzhu reloadData];
            break;
        default:
            break;
    }
    //动画结束
    [UIView commitAnimations];
    
    //设置新闻列表页主版块标题位置状态
    self.state_title = 0;
    
    //设置视图状态
    self.tintV.hidden = NO;
    self.tintL.hidden = NO;
    
    NSLog(@"%d",self.bankuai);

    
    //请求web页面进行显示
    NSString *newsurl = [[NSString alloc] init];
    newsurl = ((NewsInfo *)[newsInfoArray objectAtIndex:_indexPath.row]).newsUrl;
    NSURL *newsinfo_web = [NSURL URLWithString:newsurl];
    NSMutableURLRequest *newsinfo_request = [[NSMutableURLRequest alloc] initWithURL:newsinfo_web];
    [self.newsinfo loadRequest:newsinfo_request];
}

#pragma mark - 网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改服务器页面的meta的值
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", self.newsinfo.frame.size.width];
    [self.newsinfo stringByEvaluatingJavaScriptFromString:meta];
    
    //给网页增加css样式
    [self.newsinfo stringByEvaluatingJavaScriptFromString:
     @"var tagHead =document.documentElement.firstChild;"
     "var tagStyle = document.createElement(\"style\");"
     "tagStyle.setAttribute(\"type\", \"text/css\");"
     "tagStyle.appendChild(document.createTextNode(\".controll{display:none}\"));"
     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];
    //显示新闻详情内容简介
    self.newsinfo.hidden = NO;

}
//#pragma mark 分享方法
//-(void)didChangeToShare{
//    
////    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"fthat"  ofType:@"jpg"];
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:self.newsInfo.title
//                                       defaultContent:@"来自点滴分享"
//                                                image:[ShareSDK imageWithUrl:self.newsInfo.picUrl]
//                                                title:self.newsInfo.title
//                                                  url:self.newsInfo.newsUrl
//                                          description:@"这是一条测试信息"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(390, -60, 200, 60)];
//    [self.newsinfo addSubview:view];
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionUp];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(@"分享成功");
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//                                }
//                            }];
//    
////    //分享界面显示内容
////    self.share_list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 2)];
////    self.share_list.delegate = self;
////    self.share_list.dataSource = self;
////    self.share_list.backgroundColor = [UIColor clearColor];
////    self.share_list.hidden = YES;
////    [self.share_View addSubview:self.share_list];
////    if (self.state_share) {
////        [UIView beginAnimations:nil context:nil];
////        [UIView setAnimationDuration:0.75];
////        self.share_View.frame = CGRectMake(380, 0, 200, 2);
////        self.share_list.frame = CGRectMake(0, 0, 200, 2);
////        self.share_View.alpha = 0.0;
////        self.share_View.hidden = NO;
////        self.share_list.hidden = NO;
////        [UIView commitAnimations];
////        self.state_share = 0;
////    }else{
////        [UIView beginAnimations:nil context:nil];
////        [UIView setAnimationDuration:0.75];
////        self.share_View.frame = CGRectMake(380, 0, 200, 350);
////        self.share_list.frame = CGRectMake(0, 0, 200, 350);
////        self.share_View.alpha = 1;
////        self.share_View.hidden = NO;
////        self.share_list.hidden = NO;
////        [UIView commitAnimations];
////        self.state_share = 1;
////    }
//}
#pragma mark 关注方法
-(void)didChangeToGuanzhu{
    if (self.state_guanzhu) {
        [self.guanzhu setImage:[UIImage imageNamed:@"guanzhu1"] forState:UIControlStateNormal];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        self.guanzhu_View.alpha = 1;
        self.guanzhu_View.hidden = NO;
        self.guanzhu_sucess.text = @"取消关注";
        [UIView commitAnimations];
        if (self.guanzhu_View.alpha == 1) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            self.guanzhu_View.alpha = 0.0;
            [UIView commitAnimations];
        }
        self.state_guanzhu = 0;
        NSLog(@"%@",[self.tintV.backgroundColor description]);
    }else{
        [self.guanzhu setImage:[UIImage imageNamed:@"guanzhu2"] forState:UIControlStateNormal];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        self.guanzhu_View.alpha = 1;
        self.guanzhu_View.hidden = NO;
        self.guanzhu_sucess.text = @"关注成功";
        [UIView commitAnimations];
        if (self.guanzhu_View.alpha == 1) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            self.guanzhu_View.alpha = 0.0;
            [UIView commitAnimations];
        }
        self.state_guanzhu = 1;
    }
    
}
#pragma mark - 点击点滴开启菜单
//点滴开启
-(void)didClickTodiandikaiqi:(UITapGestureRecognizer *)sender{
    NSLog(@"点击“点滴开启”-----进入点滴开启版块");
    if ([self.state_news isEqualToString:@"首次"]) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(334, 0, 807, 64);
    }else if (!self.state_title) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(0, 0, 807, 64);
    }
    
    //标记展示版块
    self.bankuai = 1;
    
    //设置新闻列表页主版块标题位置状态
    self.state_title = 1;
    
    //点击菜单按钮动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置菜单栏按钮View显示状态
    self.DianDiKaiQI.alpha = 0.5;
    self.XiRiTouTiao.alpha = 1;
    self.TuShuoTianXia.alpha = 1;
    self.JuJiaoReDian.alpha = 1;
    self.WoDeGuanZhu.alpha = 1;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
    
    //界面布局设置
    self.newsV_diandi.frame = CGRectMake(217, StateColumn, Heng_Before_NewsTV_width, Heng_After_NewsV_height);

    //标记状态
    self.state_news = @"再次";
    //设置frame显示状态
    self.state_frame = @"新闻列表";
    NSLog(@"Frame:%@",self.state_frame);
    
    //重载tableView
    [self.newsTV reloadData];
    
//回收设置界面动画
    //如果系统设置未收起，将它收起
    self.state_Tanchuang = 1;
    //设置界面
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.set_View.alpha = 0.2;
    self.set_View.frame = CGRectMake(215, 630, 0, 0);
    self.show_All.hidden = YES;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
    
}
#pragma mark 点击昔日头条菜单
//昔日头条
-(void)didClickToxiritoutiao:(UITapGestureRecognizer *)sender{
    NSLog(@"点击“昔日头条”-----进入昔日头条版块");

    if ([self.state_news isEqualToString:@"首次"]) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(334, 0, 807, 64);
    }else if (!self.state_title) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(0, 0, 807, 64);
    }
    
    //标记展示版块
    self.bankuai = 2;
    
    //设置新闻列表页主版块标题位置状态
    self.state_title = 1;
    
    //点击菜单按钮动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置菜单栏按钮View显示状态
    self.DianDiKaiQI.alpha = 1;
    self.XiRiTouTiao.alpha = 0.5;
    self.TuShuoTianXia.alpha = 1;
    self.JuJiaoReDian.alpha = 1;
    self.WoDeGuanZhu.alpha = 1;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];

    //界面布局设置
    self.newsV_diandi.frame = CGRectMake(217, StateColumn, Heng_Before_NewsTV_width, Heng_After_NewsV_height);
    
    //标记状态
    self.state_news = @"再次";
    //设置frame显示状态
    self.state_frame = @"新闻列表";
    NSLog(@"Frame:%@",self.state_frame);
    
    //重载tableView
    [self.newstoutiaoTV reloadData];
    
//回收设置界面动画
    //如果系统设置未收起，将它收起
    self.state_Tanchuang = 1;
    //设置界面
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.set_View.alpha = 0.2;
    self.set_View.frame = CGRectMake(215, 630, 0, 0);
    self.show_All.hidden = YES;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
 
}
#pragma mark 点击图说天下菜单
//图说天下
-(void)didClickTotushuoshijie:(UITapGestureRecognizer *)sender{
    
    NSLog(@"点击“图说天下”-----进入图说天下版块");
    
    if ([self.state_news isEqualToString:@"首次"]) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(334, 0, 807, 64);
    }else if (!self.state_title) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(0, 0, 807, 64);
    }
    
    //标记展示版块
    self.bankuai = 3;
    
    //设置新闻列表页主版块标题位置状态
    self.state_title = 1;
    
    //改变版块标题名称
    self.newstint.text = @"图说 • 天下";
    
    //点击菜单按钮动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置菜单栏按钮View显示状态
    self.DianDiKaiQI.alpha = 1;
    self.XiRiTouTiao.alpha = 1;
    self.TuShuoTianXia.alpha = 0.5;
    self.JuJiaoReDian.alpha = 1;
    self.WoDeGuanZhu.alpha = 1;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
    
    //界面布局设置
    self.newsV_diandi.frame = CGRectMake(217, StateColumn, Heng_Before_NewsTV_width, Heng_After_NewsV_height);
    //重载tableView
    [self.newsCV reloadData];
    //标记状态
    self.state_news = @"再次";
    //设置frame显示状态
    self.state_frame = @"新闻列表";
    NSLog(@"Frame:%@",self.state_frame);
    
    
    
    //回收设置界面动画
    //如果系统设置未收起，将它收起
    self.state_Tanchuang = 1;
    //设置界面
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.set_View.alpha = 0.2;
    self.set_View.frame = CGRectMake(215, 630, 0, 0);
    self.show_All.hidden = YES;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
    

}
#pragma  mark 点击聚焦热点菜单
//聚焦热点
-(void)didClickTojujiaoredian:(UITapGestureRecognizer *)sender{
    NSLog(@"点击“图说天下”-----进入图说天下版块");
    
    if ([self.state_news isEqualToString:@"首次"]) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(334, 0, 807, 64);
    }else if (self.state_title) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(334, 0, 807, 64);
    }else{
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(0, 0, 807, 64);
    }
    
    //标记展示版块
    self.bankuai = 4;
    
    //设置新闻列表页主版块标题位置状态
    self.state_title = 1;
    
    //点击菜单按钮动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置菜单栏按钮View显示状态
    self.DianDiKaiQI.alpha = 1;
    self.XiRiTouTiao.alpha = 1;
    self.TuShuoTianXia.alpha = 1;
    self.JuJiaoReDian.alpha = 0.5;
    self.WoDeGuanZhu.alpha = 1;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
    
    //界面布局设置
    self.newsV_diandi.frame = CGRectMake(217, StateColumn, Heng_Before_NewsTV_width, Heng_After_NewsV_height);
    
    //标记状态
    self.state_news = @"再次";
    //设置frame显示状态
    self.state_frame = @"新闻列表";
    NSLog(@"Frame:%@",self.state_frame);
    
    //重载tableView
    [self.jujiaoredian reloadData];
    
    //回收设置界面动画
    //如果系统设置未收起，将它收起
    self.state_Tanchuang = 1;
    //设置界面
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.set_View.alpha = 0.2;
    self.set_View.frame = CGRectMake(215, 630, 0, 0);
    self.show_All.hidden = YES;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
}
#pragma mark 点击我的关注菜单
//我的关注
-(void)didClickTowodeguanzhu:(UITapGestureRecognizer *)sender{
    NSLog(@"点击“图说天下”-----进入图说天下版块");
    
    if ([self.state_news isEqualToString:@"首次"]) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(334, 0, 807, 64);
    }else if (self.state_title) {
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(334, 0, 807, 64);
    }else{
        //规划新闻列表页主版块标题位置
        self.newstint.frame = CGRectMake(0, 0, 807, 64);
    }
    
    //标记展示版块
    self.bankuai = 5;
    
    //设置新闻列表页主版块标题位置状态
    self.state_title = 1;
    
    //点击菜单按钮动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置菜单栏按钮View显示状态
    self.DianDiKaiQI.alpha = 1;
    self.XiRiTouTiao.alpha = 1;
    self.TuShuoTianXia.alpha = 1;
    self.JuJiaoReDian.alpha = 1;
    self.WoDeGuanZhu.alpha = 0.5;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
    
    //界面布局设置
    self.newsV_diandi.frame = CGRectMake(217, StateColumn, Heng_Before_NewsTV_width, Heng_After_NewsV_height);
    
    //标记状态
    self.state_news = @"再次";
    //设置frame显示状态
    self.state_frame = @"新闻列表";
    NSLog(@"Frame:%@",self.state_frame);
    
    //重载tableView
    [self.myguanzhu reloadData];
    
    //回收设置界面动画
    //如果系统设置未收起，将它收起
    self.state_Tanchuang = 1;
    //设置界面
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.set_View.alpha = 0.2;
    self.set_View.frame = CGRectMake(215, 630, 0, 0);
    self.show_All.hidden = YES;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
}
#pragma mark 点击系统设置菜单
//系统设置
-(void)didClickToxitongshezhi:(UITapGestureRecognizer *)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.DianDiKaiQI.alpha = 1;
    self.XiRiTouTiao.alpha = 1;
    self.TuShuoTianXia.alpha = 1;
    self.JuJiaoReDian.alpha = 1;
    self.WoDeGuanZhu.alpha = 1;
    self.XiTongSheZhi.alpha = 0.5;
    [UIView commitAnimations];
    
    //判断弹窗状态
    if (self.state_Tanchuang) {
        self.state_Tanchuang = 0;
        self.show_All.hidden = NO;
        self.newsinfo.hidden = YES;
        self.tintV.hidden = YES;
        //设置界面
        self.set_View = [[UITableView alloc] initWithFrame:CGRectMake(215, 545, 20, 85) style:UITableViewStylePlain];
        self.set_View.backgroundColor = [UIColor cyanColor];
        self.set_View.delegate = self;
        self.set_View.dataSource = self;
        self.set_View.alpha = 0.2;
        self.time_list_view.hidden = YES;
        [self.view addSubview:self.set_View];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        self.set_View.alpha = 1;
        self.set_View.frame = CGRectMake(222, 340, 250, 290);
        if (self.bankuai == 2) {
            self.time_list_view.hidden = NO;
        }else{
            self.time_list_view.hidden = YES;
        }
        [UIView commitAnimations];
        
        
    }else{
        self.state_Tanchuang = 1;
        //设置界面
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        self.set_View.alpha = 0.2;
        self.set_View.frame = CGRectMake(215, 630, 0, 0);
        self.show_All.hidden = YES;
        self.XiTongSheZhi.alpha = 1;
        if (self.bankuai == 2) {
            self.time_list_view.hidden = NO;
        }else{
            self.time_list_view.hidden = YES;
        }
        [UIView commitAnimations];
    }
}
#pragma mark - 内存警告
//内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 夜间模式切换
- (IBAction)dayTonightSwitch:(UISwitch *)sender {
    if (self.state_Tian) {
        [self changeBackgroundNight];
    }else{
        [self changeBackgroundDay];
    }
}
#pragma mark 夜晚模式
-(void)changeBackgroundNight
{
    //如果系统设置未收起，将它收起
    self.state_Tanchuang = 1;
    //设置界面
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.set_View.alpha = 0.2;
    self.set_View.frame = CGRectMake(215, 630, 0, 0);
    self.show_All.hidden = YES;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
    
    [self.newsinfo stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.color='#fff'"];
    
    [self.newsinfo stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#222'"];
    
    [self.newsinfo stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('h1')[0].style.color='#fff'"];
    
    self.state_Tian = 0;
}
#pragma mark 白天模式
-(void)changeBackgroundDay
{
    //如果系统设置未收起，将它收起
    self.state_Tanchuang = 1;
    //设置界面
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.set_View.alpha = 0.2;
    self.set_View.frame = CGRectMake(215, 630, 0, 0);
    self.show_All.hidden = YES;
    self.XiTongSheZhi.alpha = 1;
    [UIView commitAnimations];
    
    [self.newsinfo stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.color='#222'"];
    
    [self.newsinfo stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#fff'"];
    
    [self.newsinfo stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('h1')[0].style.color='#000'"];
    
    self.state_Tian = 1;
}
#pragma mark - 收起设置菜单
-(void)didChangeToquxiao{
    self.state_Tanchuang = 1;
    //设置界面
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.set_View.alpha = 0.2;
    self.set_View.frame = CGRectMake(215, 630, 0, 0);
    self.show_All.hidden = YES;
    if (self.bankuai == 2) {
        self.time_list_view.hidden = NO;
    }else{
        self.time_list_view.hidden = YES;
    }
    [UIView commitAnimations];
}
#pragma mark - 昔日头条 前一天
//昔日头条版块的前一天的头条
-(IBAction)lastDay:(id)sender{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.time_list_time.text = @"2013.12.05";
    self.newstoutiaoTV.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.newstoutiaoTV.transform = CGAffineTransformMakeScale(1.0, 1.0);
    //更新tableview中的数据
    [self.newstoutiaoTV reloadData];
    [UIView commitAnimations];
    
}
#pragma mark 昔日头条 后一天
//昔日头条版块的后一天的头条
-(IBAction)afterDay:(id)sender{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.time_list_time.text = @"2013.12.07";
    self.newstoutiaoTV.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.newstoutiaoTV.transform = CGAffineTransformMakeScale(1.0, 1.0);
    //更新tableview的数据
    [self.newstoutiaoTV reloadData];
    [UIView commitAnimations];
    
}
//图说天下版块收缩新闻列表
-(void)didChangeTonewslist{
    self.state_news = @"再次";
    NSLog(@"%@",self.state_news);
    self.state_frame = @"新闻详情";
    NSLog(@"%@",self.state_frame);
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.75];
    
    NSLog(@"%d==============",self.bankuai);
    
    //动画的内容
    self.newsV_diandi.frame = CGRectMake(Heng_After_NewsV_x, StateColumn, Heng_After_NewsV_width, Heng_After_NewsV_height);
    //tableview重载
    [self.newsCV reloadData];
    //动画结束
    [UIView commitAnimations];
    
    //设置新闻列表页主版块标题位置状态
    self.state_title = 0;
    
    //设置视图状态
    self.tintV.hidden = NO;
    self.tintL.hidden = NO;
    
    
    NSLog(@"%d",self.bankuai);
    
    //请求web页面进行显示
    NSURL *newsinfo_web = [NSURL URLWithString:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/Site_PV_Count.ashx?newsId=B73369177C55A801&createDate=20131204&PID=213&UpdateTime=1386148311"];
    NSMutableURLRequest *newsinfo_request = [[NSMutableURLRequest alloc] initWithURL:newsinfo_web];
    
    [self.newsinfo loadRequest:newsinfo_request];
}
#pragma mark - 关于点滴
-(void)didChangeToAbout{
    if (self.state_second) {
        self.about.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        
        self.about.frame = CGRectMake(200, 341, 2, 2);
        self.about.alpha = 0.0;
        [UIView commitAnimations];
        self.state_second = 0;
    }else{
        self.about.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        self.about.frame = CGRectMake(500, 341, 250, 290);
        self.about_text.frame = CGRectMake(90, 10, 100, 40);
        self.about_info.frame = CGRectMake(30, 165, 195, 100);
        self.about_less.frame = CGRectMake(80, 239, 100, 40);
        self.diandi_logo.frame = CGRectMake(70, 60, 120, 120);
        self.about_text.font = [UIFont boldSystemFontOfSize:18];
        self.about.alpha = 1;
        
        [UIView commitAnimations];
        self.state_second = 1;
    }
    
}

//- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
//    
//    if (sender.state == UIGestureRecognizerStateEnded)
//    {
//        CGPoint initialPinchPoint = [sender locationInView:self.newsCV];
//        NSIndexPath* tappedCellPath = [self.newsCV indexPathForItemAtPoint:initialPinchPoint];
//        if (tappedCellPath!=nil)
//        {
//            self.cellCount = self.cellCount - 1;
//            [self.newsCV performBatchUpdates:^{
//                [self.newsCV deleteItemsAtIndexPaths:[NSArray arrayWithObject:tappedCellPath]];
//                
//            } completion:nil];
//        }
//        else
//        {
//            self.cellCount = self.cellCount + 1;
//            [self.newsCV performBatchUpdates:^{
//                [self.newsCV insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
//            } completion:nil];
//        }
//    }
//}
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortraitUpsideDown;//这里返回哪个值，就看你想支持那几个方向了。这里必须和后面plist文件里面的一致（我感觉是这样的）。
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            
            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}
//- (BOOL)shouldAutorotate {
//    return NO;//支持转屏
//}

@end
