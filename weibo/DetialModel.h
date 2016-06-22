//
//  DetialModel.h
//  weibo
//
//  Created by lotic on 16/6/20.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol DetialCellsModel;
@protocol MainDetialUserModel;

@interface MainDetialUserModel : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profile_image_url;
@end

@interface DetialCellsModel : JSONModel
@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)NSString *created_at;
@property (nonatomic, strong)MainDetialUserModel *user;
@end

@interface DetialModel : JSONModel
@property (nonatomic, strong)NSArray<DetialCellsModel, ConvertOnDemand>*comments;
@end
