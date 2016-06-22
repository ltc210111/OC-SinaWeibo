//
//  MainViewTableViewController.m
//  OC-weibo
//
//  Created by lotic on 16/6/6.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "MainViewTableViewController.h"
#import "MCHttp.h"
#import "UserInfoModel.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MainViewTimeLineModel.h"
#import "View+MASAdditions.h"
#import "MainViewTableViewCell.h"
#import "MainPicCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MainDetialViewController.h"
#import "JLPhotoBrowerViewController.h"

@interface MainViewTableViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@property (assign,nonatomic) BOOL login;
//web及web获取到的数据
@property (weak, nonatomic) UIWebView *loginView;
@property (strong, nonatomic) NSString *code;
//全部数据
@property (strong, nonatomic) NSMutableArray *mainModel;
//per cell mainCollectionV pic
@property (strong, nonatomic) NSMutableArray *mainCVPics;

@property (assign, nonatomic) NSInteger cellNum;

@property (nonatomic, strong) NSString *url;
@end

@implementation MainViewTableViewController

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *a = [webView.request.URL.absoluteString substringWithRange:NSMakeRange(0, 46)];
    self.code = [webView.request.URL.absoluteString substringWithRange:NSMakeRange(47, 32)];
    if([a isEqualToString:@"https://api.weibo.com/oauth2/default.html?code"]) {
        self.loginView.frame = CGRectMake(0, 0, 0, 0);
        [self setToken];
    }
}


- (void)viewDidLoad {
    
//    UITabBarItem* item = self.navigationController.tabBarItem;
//    [item setImage:[UIImage imageNamed:@"tabbar_home"]];
//    [item setSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    self.tabBarController.tabBar.tintColor = [UIColor orangeColor];
    
    [super viewDidLoad];
    self.login = NO;
    self.hiddenView.frame = CGRectMake(self.view.frame.size.width/2 - 108, 55, 216, 300);
    self.hiddenView.backgroundColor = [UIColor clearColor];
    self.hiddenView.alpha = 0;
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self.navigationController.view addSubview:self.hiddenView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadtimeline];
    }];
    [self.tableView.mj_header beginRefreshing];
//    cell预估高度
    self.tableView.estimatedRowHeight = 380;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
    MainDetialViewController *userM = (MainDetialViewController *)[sb instantiateViewControllerWithIdentifier:@"detialSB"];
    userM.detialId = cell.CellId;
    userM.model = self.mainModel[indexPath.row];
    
    [self.navigationController pushViewController:userM animated:YES];
    NSLog(@"%@",cell.retweetedLabel.text);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    self.cellNum = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.navController = self.navigationController;
    MainViewTimeLinestatusesModel *model = self.mainModel[indexPath.row];
    [self.mainCVPics removeAllObjects];
    [self.mainCVPics addObjectsFromArray:model.pic_urls];
    NSLog(@"%ld",(long)indexPath.row);
    [cell setCellWithModel:model];
    return cell;
}

#pragma mark - Collection view data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mainCVPics.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.mainCVPics.count == 1) return CGSizeMake(180, 105);
    return CGSizeMake(105,105);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    collectionView.tag = self.cellNum;
    MainPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detialPicCell" forIndexPath:indexPath];
    if(self.mainCVPics) {
        MainViewPicUrlModel *model = self.mainCVPics[indexPath.row];
        [cell.cellPic sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"header"]];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MainViewTimeLinestatusesModel *model = self.mainModel[collectionView.tag];
    NSMutableArray *picUrlArray = [NSMutableArray new];
    for (MainViewPicUrlModel *urls in model.pic_urls) {
        [picUrlArray addObject:urls.thumbnail_pic];
    }
    
    JLPhotoBrowerViewController *photoBrower = [[JLPhotoBrowerViewController alloc] init];
    photoBrower.pictureURLArray = picUrlArray;
    photoBrower.currentIndex = indexPath.row;
    [self presentViewController:photoBrower animated:YES completion:nil];

}
#pragma mark - btnAction
- (IBAction)hiddenBtnAct:(id)sender {
    [UIView animateWithDuration:0.309f animations:^{
        self.arrowImg.transform = CGAffineTransformRotate(self.arrowImg.transform, M_PI);
        if(!self.hiddenView.alpha) self.hiddenView.alpha = 1;
        else self.hiddenView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)ssoBtn:(id)sender {
    if(!self.login) {
        UIWebView *loginV = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.loginView = loginV;
        [self.loginView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2749379653&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html"]]];
        self.loginView.delegate = self;
        [self.view addSubview:self.loginView];
        self.login = YES;
    }
    if(self.login) {
        //https://api.weibo.com/oauth2/access_token?client_id=2749379653&client_secret=c3561477d81122508b367ddd5ad10045&grant_type=authorization_code&redirect_uri=https://api.weibo.com/oauth2/default.html&code=CODE
    }
}
- (IBAction)act:(id)sender {
    for (MainViewTimeLinestatusesModel *model in self.mainModel) {
        if(model.retweeted_status) {
            MainViewTimeLineRetweetedStatusesModel *retweeted = (MainViewTimeLineRetweetedStatusesModel *)model.retweeted_status;
            NSLog(@"%@+++%@",retweeted.text,retweeted.pic_urls);
        }
    }
}

- (IBAction)btnnn:(id)sender {
    self.url = @"https://api.weibo.com/2/statuses/user_timeline.json";
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Network
-(void)setToken {
    NSString *url = @"https://api.weibo.com/oauth2/access_token";
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:kAppKey,@"client_id",kAppSecret,@"client_secret",@"authorization_code",@"client_secret",self.code,@"code",kRedirectURI,@"redirect_uri", nil];
    [MCHttp postRequestURLStr:url withDic:parameters isCache:NO success:^(NSDictionary *requestDic, NSString *msg) {
        UserInfoModel *infoModel = [[UserInfoModel alloc]initWithDictionary:requestDic error:nil];
        [infoModel saveUserInfoModel];
    } failure:^(NSString *errorInfo) {
        
    }];
}

-(void)loadtimeline {
    if(!self.url) self.url = @"https://api.weibo.com/2/statuses/public_timeline.json";
//    NSString *url = @"https://api.weibo.com/2/statuses/user_timeline.json";

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfoModel loadUserInfoModel].access_token,@"access_token", nil];
    [MCHttp getRequestURLStr:self.url parameters:parameters isCache:NO success:^(NSDictionary *requestDic, NSString *msg) {
        MainViewTimeLineModel *model = [[MainViewTimeLineModel alloc]initWithDictionary:requestDic error:nil];
        [self.mainModel removeAllObjects];
        [self.mainModel addObjectsFromArray:model.statuses];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSString *errorInfo) {
        
    }];
}

#pragma mark - lazyLoad
- (NSMutableArray *)mainModel {
    if (!_mainModel) {
        _mainModel = [NSMutableArray new];
    }
    return _mainModel;
}
-(NSMutableArray *)mainCVPics {
    if(!_mainCVPics) {
        _mainCVPics = [NSMutableArray new];
    }
    return _mainCVPics;
}
@end
