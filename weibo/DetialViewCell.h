//
//  DetialViewCell.h
//  weibo
//
//  Created by lotic on 16/6/21.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetialModel.h"

@interface DetialViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentImg;
@property (weak, nonatomic) IBOutlet UILabel *commentName;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet UILabel *commentText;

-(void)setCellWithModel:(DetialCellsModel *)model;
@end
