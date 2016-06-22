//
//  JLPhotoBrowerViewController.h
//  Jiehuo
//
//  Created by 林嘉文 on 16/3/31.
//  Copyright © 2016年 messcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLPhotoBrowerViewController : UIViewController
//SDWebImage作缓存
@property (nonatomic, strong) NSArray *pictureURLArray;

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) UIPageControl *pageControl;


@end
