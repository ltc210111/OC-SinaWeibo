//
//  SelectTableViewController.m
//  OC-weibo
//
//  Created by lotic on 16/6/8.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "SelectTableViewController.h"

@interface SelectTableViewController () {
    NSInteger currentIndex;
}
@property(nonatomic,assign)NSInteger settingType;
@property(nonatomic,strong)NSString *settingDetial;
@end

@implementation SelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    _settingType = 0;
    [self.delegate setTextAt:_settingType With:_settingDetial];
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@",self.selectedText);
}

#pragma mark - Table view data source

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==currentIndex && indexPath.section == 0){
//        self.settingDetial = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row==currentIndex){
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex
                                                   inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.tintColor = [UIColor greenColor];
        NSLog(@"%@",newCell.textLabel.text);
        self.settingDetial = newCell.textLabel.text;
    }
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    currentIndex=indexPath.row;
}
@end
