//
//  FindTableViewController.m
//  OC-weibo
//
//  Created by lotic on 16/6/8.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "FindTableViewController.h"
#define count 3

@interface FindTableViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *picView;
@property (weak, nonatomic) IBOutlet UIPageControl *picPage;

//全局的时钟
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation FindTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picView.delegate = self;
    
    //图片的宽度
    CGFloat imgW=self.view.frame.size.width;
    //图片的高度
    CGFloat imgH=self.picView.frame.size.height;
    //图片的Y坐标
    CGFloat imgY=0;
    //图片的X坐标，这个坐标是变化的，否则就会重叠，最终只能看到一张图片
    CGFloat imgX=0;
    //循环加载图片到picView
    for (int i=0; i<count; i++) {
        UIImageView *imgView=[[UIImageView alloc] init];
        //设置需要显示的图片
        imgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"scrollPic_%02d",i+1]];
        //计算图片的X轴坐标
        imgX=i*imgW;
        
        imgView.frame=CGRectMake(imgX, imgY, imgW, imgH);
        [self.picView addSubview:imgView];
    }
    //设置滚动范围，否则不能进行滚动
    self.picView.contentSize=CGSizeMake(count*imgW, 0);
    //去除水平滚动条
    self.picView.showsHorizontalScrollIndicator=NO;
    //设置分页显示
    self.picView.pagingEnabled=YES;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
    //创建NSRunloop
    NSRunLoop *runloop=[NSRunLoop currentRunLoop];
    //将时钟添加到循环处理机制中
    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];

}

-(void)nextImg {
    //获取当前图片的偏移值
    CGFloat offsetX=self.picView.contentOffset.x;
    //根据偏移值计算当前图片所在的位置索引
    int index=offsetX/self.picView.frame.size.width;
    //判断是否是最后一张
    if(index==count-1) index=0;//重置到第一张图片
    else index++;//否则往后滚动
    //根据新的图片位置索引修改当前scrollView的contentOffset属性值
    [self.picView setContentOffset:CGPointMake(index*self.picView.frame.size.width, 0) animated:YES];
}

#pragma mark - 轮播实现 scrollow View delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width=self.picView.frame.size.width;
    CGFloat offsetX=self.picView.contentOffset.x;
    //当图片滚动范围超过一半 显示下一页
    NSInteger index=(offsetX+width*0.5)/width;
    self.picPage.currentPage=index;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer=nil;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
    NSRunLoop *runloop=[NSRunLoop currentRunLoop];
    //将时钟添加到循环处理机制中
    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
}
@end
