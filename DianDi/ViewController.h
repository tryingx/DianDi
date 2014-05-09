//
//  ViewController.h
//  DianDi
//
//  Created by ㊣Trying-X™ on 13-12-3.
//  Copyright (c) 2013年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newsCell.h"
#import "News_Cell.h"
#import "NewsCollectionView.h"
#import "NBRequestManager.h"
#import "NBRequestManager+BeijingNews.h"
#import "NewsInfo.h"



@class AppDelegate;

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,NBRequestDataDelegate>

{
    AppDelegate *_appDelegate;
}
#pragma mark - 新闻显示主视图
@property (nonatomic, retain) IBOutlet UIView *newsV_diandi;
#pragma mark -
#pragma mark 点滴开启菜单
@property (strong, nonatomic) IBOutlet UIView *DianDiKaiQI;
#pragma mark 昔日头条菜单
@property (strong, nonatomic) IBOutlet UIView *XiRiTouTiao;
#pragma mark 图说天下菜单
@property (strong, nonatomic) IBOutlet UIView *TuShuoTianXia;
#pragma mark 聚焦热点菜单
@property (strong, nonatomic) IBOutlet UIView *JuJiaoReDian;
#pragma mark 我的关注菜单
@property (strong, nonatomic) IBOutlet UIView *WoDeGuanZhu;
#pragma mark 系统设置菜单
@property (strong, nonatomic) IBOutlet UIView *XiTongSheZhi;
#pragma mark -
#pragma mark 点滴开启新闻列表
@property (nonatomic, retain) IBOutlet UITableView *newsTV;
#pragma mark 昔日头条新闻列表
@property (strong, nonatomic) IBOutlet UITableView *newstoutiaoTV;
#pragma mark 聚焦热点新闻列表
@property (nonatomic,retain) IBOutlet UITableView *jujiaoredian;
#pragma mark 我的关注
@property (nonatomic, retain) IBOutlet UITableView *myguanzhu;

#pragma mark -
#pragma mark 新闻标题视图
@property (nonatomic, retain) IBOutlet UIView *newstintV;
#pragma mark 新闻标题
@property (nonatomic, strong) IBOutlet UILabel *newstint;

#pragma mark -
#pragma mark 新闻详情网页视图
@property (nonatomic, retain) UIWebView *newsinfo;
#pragma mark 新闻详情标题视图
@property (nonatomic, retain) UIView *tintV;
#pragma mark 新闻详情标题
@property (nonatomic, retain) UILabel *tintL;
#pragma mark - 
#pragma mark 新闻浏览状态
@property (nonatomic, retain) NSString *state_news;
#pragma mark frame状态
@property (nonatomic, retain) NSString *state_frame;
#pragma mark 弹窗状态
@property (nonatomic, assign) BOOL state_Tanchuang;
#pragma mark 当前的视图版块
@property (nonatomic, assign) int bankuai;
//1:点滴开启;2:昔日头条;3:图说天下;4:聚焦热点;5:我的关注;

#pragma mark - 类库实例化

@property (nonatomic, retain) newsCell *newscell;

@property (nonatomic, retain) IBOutlet NewsCollectionView *newsCV; 

@property (nonatomic, retain) News_Cell *news_cell;

@property (nonatomic, retain) NewsInfo *newsInfo;

@property (nonatomic, retain) NBRequestManager *requestManager;

#pragma mark -
#pragma mark 夜间模式切换按钮
- (IBAction)dayTonightSwitch:(UISwitch *)sender;
#pragma mark 前一天
-(IBAction)lastDay:(id)sender;
#pragma mark 后一天
-(IBAction)afterDay:(id)sender;
#pragma mark 横扫手势
@property (nonatomic, retain) UISwipeGestureRecognizer *check_news;

#pragma mark - 各种手势
#pragma mark 
@property (nonatomic, retain) UITapGestureRecognizer *diandikaiqi;
@property (nonatomic, retain) UITapGestureRecognizer *xiritoutiao;
@property (nonatomic, retain) UITapGestureRecognizer *tushuoshijie;
@property (nonatomic, retain) UITapGestureRecognizer *jujiao_redian;
@property (nonatomic, retain) UITapGestureRecognizer *wodeguanzhu;
@property (nonatomic, retain) UITapGestureRecognizer *xitongshezhi;

#pragma mark -
#pragma mark 新闻列表界面标题的位置状态
@property (nonatomic, assign) BOOL state_title;
#pragma mark 新闻浏览界面的天色状态
@property (nonatomic, assign) BOOL state_Tian;
#pragma mark 二次弹窗状态
@property (nonatomic, assign) BOOL state_second;
#pragma mark 关注状态
@property (nonatomic, assign) BOOL state_guanzhu;
#pragma mark 分享状态
@property (nonatomic, assign) BOOL state_share;
#pragma mark -
#pragma mark 设置弹窗视图
@property (strong, nonatomic) IBOutlet UIView *show_All;
#pragma mark 系统设置表单
@property (nonatomic, retain) UITableView *set_View;
#pragma mark tableview标签
@property (nonatomic, retain) NSString *table_name;

#pragma mark - 
#pragma mark 昔日头条时间表
@property (nonatomic, retain) IBOutlet UIView *time_list_view;
#pragma mark 昔日头条时间文本
@property (nonatomic, retain) IBOutlet UILabel *time_list_time;
#pragma mark 昔日头条热度
@property (strong, nonatomic) IBOutlet UILabel *time_redu;
#pragma mark - 关于点滴视图
@property (nonatomic, retain) UIView *about;
#pragma mark 关于点滴文本框
@property (nonatomic, retain) UITextField *about_text;
@property (nonatomic, retain) UILabel *about_info;
@property (nonatomic, retain) UIButton *about_less;
@property (nonatomic, retain) UIImageView *diandi_logo;
@property (nonatomic, retain) UIButton *share;
@property (nonatomic, retain) UIButton *guanzhu;
#pragma mark 分享页面
@property (nonatomic, retain) UIView *share_View;
#pragma mark - 关注页面
@property (nonatomic, retain) UIView *guanzhu_View;
#pragma mark 关注成功状态文本
@property (nonatomic, retain) UILabel *guanzhu_sucess;

#pragma mark 分享界面tableview
@property (nonatomic, retain) UITableView *share_list;

#pragma mark - cell 的indexpath
@property (nonatomic, retain) NSIndexPath *indexPath;

#pragma mark - collectionView
@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPull;
@property (nonatomic, strong) NSString *textRelease;
@property (nonatomic, strong) NSString *textLoading;

@property (nonatomic, strong) UICollectionView *myRefreshview;

@property (nonatomic, assign) NSInteger startRecord;



- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)setupStrings;


@end
