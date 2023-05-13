//
//  TBInfoManager.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBUserInfo : NSObject

@property(copy,nonatomic)NSString *login_time;
@property(copy,nonatomic)NSString *login_num;
@property(copy,nonatomic)NSString *accountname;
@property(copy,nonatomic)NSString *userId;
@property(copy,nonatomic)NSString *nickname;
@property(copy,nonatomic)NSString *headimg;
@property(copy,nonatomic)NSString *unionid;
@property(copy,nonatomic)NSString *pid;
@property(copy,nonatomic)NSString *token;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface TBUserManager : NSObject
/**
  存储用户信息
 
 @param dic 服务器获取来的用户信息字典
 @return return value description
 
*/
 
+ (BOOL)saveUserInfo:(NSDictionary *)dic;
/**
 取用户信息
 
 @return 返回用户信息模型
 */

+ (TBUserInfo *)userInfo;
/**
 清空用户信息
 
 @return Bool
 */

+ (BOOL)clearUserInfo;


@end

NS_ASSUME_NONNULL_END
