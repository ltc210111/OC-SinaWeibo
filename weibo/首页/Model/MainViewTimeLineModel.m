//
//  MainViewTimeLineModel.m
//  weibo
//
//  Created by lotic on 16/6/14.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "MainViewTimeLineModel.h"

@implementation MainViewTimeLineModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation MainViewTimeLinestatusesModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation MainViewTimeLineRetweetedStatusesModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation MainViewTimeLineUserModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation MainViewPicUrlModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end