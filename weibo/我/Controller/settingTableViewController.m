//
//  settingTableViewController.m
//  OC-weibo
//
//  Created by lotic on 16/6/8.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "settingTableViewController.h"
#import "SelectTableViewController.h"
@interface settingTableViewController ()<settingDelegate>
@property (weak, nonatomic) IBOutlet UILabel *readingSetting;
@property (weak, nonatomic) IBOutlet UILabel *titleSetting;

@property (nonatomic,assign) NSString* selectedText;
@property (nonatomic,assign) NSInteger selectedLine;
@end

@implementation settingTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 跳转传参
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SelectTableViewController *userVC = segue.destinationViewController;
    userVC.delegate = self;
}

-(void)setTextAt:(NSInteger)row With:(NSString *)text {
    if(row == 0) self.readingSetting.text = text;
    else if(row == 1) self.titleSetting.text = text;
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedText = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
}

@end
