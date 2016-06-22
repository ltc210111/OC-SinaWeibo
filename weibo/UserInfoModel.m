//
//  UserInfoModel.m
//  weibo
//
//  Created by lotic on 16/6/14.
//  Copyright © 2016年 lotic. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
    }
    return self;
}

- (void)saveUserInfoModel {
    NSData *encodeModel = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodeModel forKey:@"key_userdefault"];
    [userDefaults synchronize];
}

+ (UserInfoModel *)loadUserInfoModel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodeModel = [userDefaults objectForKey:@"key_userdefault"];
    UserInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:encodeModel];
    return model;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
