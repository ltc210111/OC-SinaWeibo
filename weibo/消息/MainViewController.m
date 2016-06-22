//
//  MainViewController.m
//  OC-weibo
//
//  Created by lotic on 16/6/6.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *sb1 = [UIStoryboard storyboardWithName:@"MainView" bundle:nil];
    UIViewController *v1 = [sb1 instantiateInitialViewController];
    
    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    UIViewController *v2 = [sb2 instantiateInitialViewController];
////
    UIStoryboard *sb3 = [UIStoryboard storyboardWithName:@"NewBlog" bundle:nil];
    UIViewController *v3 = [sb3 instantiateInitialViewController];
////
    UIStoryboard *sb4 = [UIStoryboard storyboardWithName:@"Find" bundle:nil];
    UIViewController *v4 = [sb4 instantiateInitialViewController];
    
    UIStoryboard *sb5 = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UIViewController *v5 = [sb5 instantiateInitialViewController];

    self.viewControllers = @[
                             v1,
                             v2,
                             v3,
                             v4,
                             v5
                             ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
