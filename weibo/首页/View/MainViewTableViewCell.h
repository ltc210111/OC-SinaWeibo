//
//  MainViewTableViewCell.h
//  weibo
//
//  Created by lotic on 16/6/15.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewTimeLineModel.h"

@interface MainViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *nickPic;
@property (weak, nonatomic) IBOutlet UILabel *nickText;
@property (weak, nonatomic) UINavigationController *navController;

@property (weak, nonatomic) IBOutlet UIView *retweetedView;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionV;
@property (weak, nonatomic) IBOutlet UICollectionView *RetweetedCollectionV;
@property (weak, nonatomic) IBOutlet UIButton *retweetedName;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;

@property (strong, nonatomic)NSMutableArray *tweetedPics;
@property (strong, nonatomic)NSMutableArray *retweetedPics;


@property (nonatomic, strong) NSString *CellId;
-(void)setCellWithModel:(MainViewTimeLinestatusesModel *)model;
@end
