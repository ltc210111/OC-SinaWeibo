
//
//  MainDetialViewController.m
//  weibo
//
//  Created by lotic on 16/6/16.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "MainDetialViewController.h"
#import "MJRefresh.h"
#import "View+MASAdditions.h"
#import "MCHttp.h"
#import "UserInfoModel.h"
#import "DetialModel.h"
#import "MainPicCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "DetialViewCell.h"

@interface MainDetialViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *headerCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *detialCollection;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreItem;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollowView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *newsView;
@property (weak, nonatomic) IBOutlet UIView *changeView;
@property (weak, nonatomic) IBOutlet UIView *detialView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundHeight;

@property (weak, nonatomic) IBOutlet UIView *btnActLine;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweeted;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *position;


@property (strong, nonatomic) IBOutlet UIView *ButtomToolsView;

@property (strong, nonatomic)NSMutableArray *headerModel;
@end

@implementation MainDetialViewController
-(void)viewDidLoad {
    self.commentTableView.estimatedRowHeight = 100;
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.headerCollection.delegate = self;
    self.headerCollection.dataSource = self;
    self.detialCollection.delegate = self;
    self.detialCollection.dataSource = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    
    self.moreItem.tintColor = [UIColor grayColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollowView.showsHorizontalScrollIndicator = NO;
    self.scrollowView.showsVerticalScrollIndicator = NO;
    self.scrollowView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadShowBatch];
    }];
    [self loadShowBatch];
    
// 46 ＋ 57 ＝ 113
    self.scrollowView.contentInset = UIEdgeInsetsMake(0, 0, self.view.frame.size.height - self.detialView.frame.size.height - 113, 0);
    
    [self.navigationController.view addSubview:self.ButtomToolsView];
    [self.ButtomToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREENWIDTH));
        make.bottom.equalTo(@(0));
        make.height.equalTo(@30);
    }];
    
//    设置个人信息
    MainViewTimeLineUserModel *profile = self.model.user;
    [self.headPicView sd_setImageWithURL:[NSURL URLWithString:profile.profile_image_url] placeholderImage:[UIImage imageNamed:@"header"]];
    [self.headText setTitle:profile.name forState:UIControlStateNormal];
//    设置微博内容
    MainViewTimeLineRetweetedStatusesModel *text = self.model.retweeted_status;
    self.headerTweeted.text = self.model.text;
    [self.retweedName setTitle:text.user.name forState:UIControlStateNormal];
    self.retweedText.text = [NSString stringWithFormat:@"%@%@",text.user.name,text.text];
    
    if(!text.user.name) {
        [self.changeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        self.retweedName.hidden = YES;
        self.retweedText.hidden = YES;
        self.retweedCollectionHigh.constant = 0;
        self.changeView.hidden = YES;
    }
    
    if(self.model.pic_urls.count == 0) {
        self.headCollectionHigh.constant = 0;
    } else if (self.model.pic_urls.count != 0) {
        self.headCollectionHigh.constant = [self.model.pic_urls count] == 0?0:([self.model.pic_urls count]/3+1)*113 + 8;
        self.headCollectionHigh.constant = self.headCollectionHigh.constant == 460?347:self.headCollectionHigh.constant;
    }
    
    if(self.model.retweeted_status.pic_urls.count == 0) {
        self.retweedCollectionHigh.constant = 0;
    } else if (self.model.retweeted_status.pic_urls.count != 0) {
        self.retweedCollectionHigh.constant = [self.model.retweeted_status.pic_urls count] == 0?0:([self.model.retweeted_status.pic_urls count]/3+1)*113 + 8;
        self.retweedCollectionHigh.constant = self.retweedCollectionHigh.constant == 460?347:self.retweedCollectionHigh.constant;
    }
}
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}
-(void)updateViewConstraints {
    [super updateViewConstraints];
    self.backgroundHeight.constant = self.headerView.frame.size.height + self.newsView.frame.size.height + self.changeView.frame.size.height + self.detialView.frame.size.height;
}
#pragma mark - collectionView DataSource Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView.tag == 10000) return self.model.pic_urls.count;
    else return self.model.retweeted_status.pic_urls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",collectionView.tag);
//    NSLog(@"%ld",self.headerCollection.tag);
//    NSLog(@"%ld",self.detialCollection.tag);
    
    MainPicCollectionViewCell *cell = [self.headerCollection dequeueReusableCellWithReuseIdentifier:@"headerPicCell" forIndexPath:indexPath];
//    if(collectionView.tag == 200) {
//        [cell.cellPic sd_setImageWithURL:self.model.pic_urls[indexPath.row] placeholderImage:[UIImage imageNamed:@"header"]];
//    }
//    else if(collectionView.tag == 15000) {
//        cell = [self.detialCollection dequeueReusableCellWithReuseIdentifier:@"retweetedPicCell" forIndexPath:indexPath];
//        [cell.cellPic sd_setImageWithURL:self.model.retweeted_status.pic_urls[indexPath.row] placeholderImage:[UIImage imageNamed:@"header"]];
//    }
    return cell;
}
#pragma mark - tableView dataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headerModel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetialViewCell *cell = [self.commentTableView dequeueReusableCellWithIdentifier:@"DetialtableCell" forIndexPath:indexPath];
    [cell setCellWithModel:self.headerModel[indexPath.row]];
    return cell;
}

#pragma mark - netWork
- (void)loadShowBatch {
//    根据微博ID返回某条微博的评论列表
    NSString *url = @"https://api.weibo.com/2/comments/show.json";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfoModel loadUserInfoModel].access_token,@"access_token", self.detialId, @"id", nil];
    [MCHttp getRequestURLStr:url parameters:parameters isCache:NO success:^(NSDictionary *requestDic, NSString *msg) {
        
        DetialModel *model = [[DetialModel alloc]initWithDictionary:requestDic error:nil];
        [self.headerModel removeAllObjects];
        [self.headerModel addObjectsFromArray:model.comments];
        [self.commentTableView reloadData];
    } failure:^(NSString *errorInfo) {
        
    }];
}

- (IBAction)moreBtn:(id)sender {
    
}
#pragma mark - BtnAct
- (IBAction)retweed:(id)sender {
    self.commentTableView.hidden = YES;
    [UIView animateWithDuration:0.623f animations:^{
        self.btnActLine.frame = CGRectMake(self.retweeted.frame.origin.x, self.btnActLine.frame.origin.y, self.retweeted.frame.size.width, self.btnActLine.frame.size.height);
    }];
    self.signLabel.text = @"快来转发精彩内容吧";
}
- (IBAction)comment:(id)sender {
    self.commentTableView.hidden = NO;
    [UIView animateWithDuration:0.623f animations:^{
        self.btnActLine.frame = CGRectMake(self.comment.frame.origin.x, self.btnActLine.frame.origin.y, self.comment.frame.size.width, self.btnActLine.frame.size.height);
    }];
    self.signLabel.text = @"快来发表你的评论吧";
}
- (IBAction)position:(id)sender {
    self.commentTableView.hidden = YES;
    [UIView animateWithDuration:0.623f animations:^{
        self.btnActLine.frame = CGRectMake(self.position.frame.origin.x, self.btnActLine.frame.origin.y, self.position.frame.size.width, self.btnActLine.frame.size.height);
    }];
    self.signLabel.text = @"快来点个赞";
}


#pragma mark - lazyLoad
- (NSMutableArray *)headerModel {
    if (!_headerModel) {
        _headerModel = [NSMutableArray new];
    }
    return _headerModel;
}
@end
