//
//  MainViewTableViewCell.m
//  weibo
//
//  Created by lotic on 16/6/15.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "MainViewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "View+MASAdditions.h"
#import "MainPicCollectionViewCell.h"
#import "MainViewTableViewController.h"
#import "MainDetialViewController.h"
#import "JLPhotoBrowerViewController.h"

@interface MainViewTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
//collectionV布局
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCellConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedConstraint;

@property (strong,nonatomic) MainViewTimeLinestatusesModel *myData;
//工具栏
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *feedBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHigh;

@end

@implementation MainViewTableViewCell
-(void)awakeFromNib {
    self.RetweetedCollectionV.delegate = self;
    self.RetweetedCollectionV.dataSource = self;
}

-(void)setCellWithModel:(MainViewTimeLinestatusesModel *)model {
    self.CellId = model.id;
    self.myData = model;
    self.tweetedPics = model.pic_urls;
//    工具栏
    if(![self.myData.reposts_count isEqualToString:@"0"])
        [self.shareBtn setTitle:[NSString stringWithFormat:@"　%@",self.myData.reposts_count] forState:UIControlStateNormal];
    if(![self.myData.attitudes_count isEqualToString:@"0"])
        [self.praiseBtn setTitle:[NSString stringWithFormat:@"　%@",self.myData.attitudes_count] forState:UIControlStateNormal];
    if(![self.myData.comments_count isEqualToString:@"0"])
        [self.feedBtn setTitle:[NSString stringWithFormat:@"　%@",self.myData.comments_count] forState:UIControlStateNormal];
    
    MainViewTimeLineUserModel *user = self.myData.user;
    [self.nickPic sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"header"]];
    [self.nickName setTitle:user.name forState:UIControlStateNormal];
    self.nickText.text = self.myData.text;
    
//    CGSize size = CGSizeMake(SCREENWIDTH - 32,CGFLOAT_MAX);
//    CGSize labelsize = [self.nickText.text sizeWithFont:self.nickText.font constrainedToSize:size lineBreakMode:self.nickText.lineBreakMode];
//    self.labelHigh.constant = labelsize.height;
//    设置图片高度
    //mainCollectionV
    if(self.myData.pic_urls.count == 0) {
        self.myCellConstraint.constant = 0;
    } else if (self.myData.pic_urls.count != 0 && (self.myData.pic_urls.count != 3 || self.myData.pic_urls.count != 6 || self.myData.pic_urls.count != 9)) {
        self.myCellConstraint.constant = [self.myData.pic_urls count] == 0?0:([self.myData.pic_urls count]/3+1)*113 + 8;
//        self.myCellConstraint.constant = self.myCellConstraint.constant == 460?347:self.myCellConstraint.constant;
    }
    if (self.myData.pic_urls.count == 3 || self.myData.pic_urls.count == 6 || self.myData.pic_urls.count == 9) {
        self.myCellConstraint.constant -= 113;
    }
    //RetweetedCollectionV
    MainViewTimeLineRetweetedStatusesModel *retweeted = self.myData.retweeted_status;
    self.retweetedPics = retweeted.pic_urls;
    if(retweeted.pic_urls.count == 0) {
        self.retweetedConstraint.constant = 0;
    } else if (retweeted.pic_urls.count != 0 && (retweeted.pic_urls.count != 3 || retweeted.pic_urls.count != 6 || retweeted.pic_urls.count != 9)) {
        self.retweetedConstraint.constant = [retweeted.pic_urls count] == 0?0:([retweeted.pic_urls count]/3+1)*113 + 8;
//        self.retweetedConstraint.constant = self.retweetedConstraint.constant == 460?347:self.retweetedConstraint.constant;
    }
    if (retweeted.pic_urls.count == 3 || retweeted.pic_urls.count == 6 || retweeted.pic_urls.count == 9) {
        self.retweetedConstraint.constant -= 113;
    }
//    设置转发栏
    if(!self.myData.retweeted_status) {
        [self.retweetedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        self.retweetedConstraint.constant = 0;
        self.retweetedView.hidden = YES;
    }else if(self.myData.retweeted_status) {
        self.retweetedView.hidden = NO;
        [self.retweetedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.removeExisting = YES;
        }];
        //        转发作者
        [self.retweetedName setTitle:[NSString stringWithFormat:@"@%@",self.myData.retweeted_status.user.name] forState:UIControlStateNormal];
        //        转发内容
        NSString *strTest = [NSString stringWithFormat:@"@%@:%@",self.myData.retweeted_status.user.name,self.myData.retweeted_status.text];
        self.retweetedLabel.text = strTest;
        //        转发图片 123 234 347  a*113 +8
        //        self.retweetedConstraint.constant = [self.myData.retweeted_status.pic_urls count] == 0?0:([self.myData.retweeted_status.pic_urls count]/3+1)*113 + 8;
    }
    
    [self.mainCollectionV reloadData];
    [self.RetweetedCollectionV reloadData];
}


#pragma mark - CollectionView DataSource Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myData.retweeted_status.pic_urls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"retweetedCell" forIndexPath:indexPath];
//    转发图片列表
    MainViewPicUrlModel *picPerUrl = self.myData.retweeted_status.pic_urls[indexPath.row];
    [cell.cellPic sd_setImageWithURL:[NSURL URLWithString:picPerUrl.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"header"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(105,105);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *picUrlArray = [NSMutableArray new];
    for (MainViewPicUrlModel *urls in self.myData.retweeted_status.pic_urls) {
        [picUrlArray addObject:urls.thumbnail_pic];
    }
    
    JLPhotoBrowerViewController *photoBrower = [[JLPhotoBrowerViewController alloc] init];
    photoBrower.pictureURLArray = picUrlArray;
    photoBrower.currentIndex = indexPath.row;
    [self.navController presentViewController:photoBrower animated:YES completion:nil];

}

#pragma mark -btnAction
- (IBAction)commentOn:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
    MainDetialViewController *userM = (MainDetialViewController *)[sb instantiateViewControllerWithIdentifier:@"detialSB"];
    //    CATransition* transition = [CATransition animation];
    //    transition.type = kCATransitionMoveIn;//可更改为其他方式
    //    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    //    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    //    [self.navigationController pushViewController:userM animated:YES];
    
    [self.navController pushViewController:userM animated:YES];
}

#pragma mark - 懒加载
-(NSArray *)tweetedPics {
    if(_tweetedPics == nil) {
        _tweetedPics = [NSMutableArray new];
    }
    return _tweetedPics;
}
@end
