//
//  SelectTableViewController.h
//  OC-weibo
//
//  Created by lotic on 16/6/8.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol settingDelegate <NSObject>
-(void)setTextAt:(NSInteger)row With:(NSString*)text;
@end

@interface SelectTableViewController : UITableViewController
@property (nonatomic,strong) NSString *selectedText;
@property (nonatomic,weak)id<settingDelegate> delegate;

@end
