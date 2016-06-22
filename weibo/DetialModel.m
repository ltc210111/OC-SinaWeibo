//
//  DetialModel.m
//  weibo
//
//  Created by lotic on 16/6/20.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "DetialModel.h"

@implementation DetialModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation MainDetialUserModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation DetialCellsModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end