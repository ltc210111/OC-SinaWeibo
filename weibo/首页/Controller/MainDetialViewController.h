//
//  MainDetialViewController.h
//  weibo
//
//  Created by lotic on 16/6/16.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewTimeLineModel.h"

@interface MainDetialViewController : UIViewController
@property(nonatomic,strong)NSString *detialId;
//所有数据
@property(nonatomic,strong)MainViewTimeLinestatusesModel* model;
//header
@property (weak, nonatomic) IBOutlet UIImageView *headPicView;
@property (weak, nonatomic) IBOutlet UIButton *headText;
@property (weak, nonatomic) IBOutlet UILabel *headerTweeted;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headCollectionHigh;
//retweed
@property (weak, nonatomic) IBOutlet UIButton *retweedName;
@property (weak, nonatomic) IBOutlet UILabel *retweedText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweedCollectionHigh;

@end
