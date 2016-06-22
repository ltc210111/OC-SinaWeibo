//
//  WBBaseModel.h
//  weibo
//
//  Created by lotic on 16/6/14.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WBBaseModel : JSONModel
@property(strong,nonatomic)NSString *previous_cursor;
@property(strong,nonatomic)NSString *next_cursor;
@property(strong,nonatomic)NSString *total_number;
@property(strong,nonatomic)NSString *hasvisible;
@property(strong,nonatomic)NSString *interval;
@end
