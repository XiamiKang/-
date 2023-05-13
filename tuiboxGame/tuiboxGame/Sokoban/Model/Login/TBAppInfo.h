//
//  TBAppInfo.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBAppInfo : NSObject

@property(copy,nonatomic)NSString *app;
@property(copy,nonatomic)NSString *app_name;
@property(copy,nonatomic)NSString *create_time;
@property(copy,nonatomic)NSString *device;
@property(assign,nonatomic)NSInteger is_show;
@property(copy,nonatomic)NSString *is_show_float;
@property(copy,nonatomic)NSString *string0;
@property(copy,nonatomic)NSString *string1;
@property(copy,nonatomic)NSString *string2;
@property(copy,nonatomic)NSString *update_time;
@property(copy,nonatomic)NSString *version;

@end

NS_ASSUME_NONNULL_END
