//
//  UserInfoModel.h
//  weibo
//
//  Created by lotic on 16/6/14.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserInfoModel : JSONModel

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *uid;

- (void)saveUserInfoModel;
+ (UserInfoModel *)loadUserInfoModel;

@end
