//
//  JLPhotoBrowerViewController.m
//  Jiehuo
//
//  Created by 林嘉文 on 16/3/31.
//  Copyright © 2016年 messcat. All rights reserved.
//

#import "JLPhotoBrowerViewController.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height

@interface JLPhotoBrowerViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation JLPhotoBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScrollView];
    [self createPageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_imagesArray.count * WIDTH, HEIGHT);
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(_currentIndex * WIDTH, 0);
    _scrollView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_scrollView addGestureRecognizer:tap];
    
    int i = 0;
    if (_pictureURLArray.count > 0) {
        for (NSString *imageURL in _pictureURLArray) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, HEIGHT)];
            //            [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            //            [imageView setImage:image];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [imageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imageView];
            i++;
        }
    }else {
        for (UIImage *image in _imagesArray) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, HEIGHT)];
            [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [imageView setImage:image];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [imageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imageView];
            i++;
        }
    }
    
    
    [self.view addSubview:_scrollView];
}

- (void)createPageControl {
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, HEIGHT - 50, WIDTH, 37)];
    _pageControl.numberOfPages = _imagesArray.count;
    _pageControl.currentPage = _currentIndex;
    _pageControl.hidesForSinglePage = YES;
    [self.view addSubview:_pageControl];
}

#pragma mark - GuestureAction

- (void)tapAction {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    //    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    //    [keywindow resignKeyWindow];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = _scrollView.contentOffset.x / WIDTH;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
