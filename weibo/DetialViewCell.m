//
//  DetialViewCell.m
//  weibo
//
//  Created by lotic on 16/6/21.
//  Copyright © 2016年 lotic. All rights reserved.

#import "DetialViewCell.h"
#import "UIImageView+WebCache.h"

@implementation DetialViewCell
-(void)setCellWithModel:(DetialCellsModel *)model {
    NSLog(@"%@",model.user.name);
    self.commentName.text = model.user.name;
    self.commentText.text = model.text;
    self.commentTime.text = model.created_at;
    NSLog(@"-0-0-%@",model.user.profile_image_url);
    [self.commentImg sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"header"]];
}
@end
