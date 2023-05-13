//
//  TBInfoManager.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/12.
//

#import "TBUserInfo.h"

@implementation TBUserInfo
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if([dictionary isKindOfClass:[NSDictionary class]]){
        if(self == [super init]) {
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    return self;
}
- (void)setValue:(id)value forKey:(NSString *)key {
    if([value isKindOfClass:[NSNull class]]) {
        return;
    }
    [super setValue:value forKey:key];
}
//对于未定义Key的处理
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.userId = value;
        return;
    }
}

@end

@implementation TBUserManager

+ (BOOL)saveUserInfo:(NSDictionary *)dic {
    return [NSKeyedArchiver archiveRootObject:dic toFile:[self path]];
}

+ (TBUserInfo *)userInfo
{
    id  data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
    TBUserInfo *model = [[TBUserInfo alloc]initWithDictionary:data];
    return model;
    
}

+ (BOOL)clearUserInfo
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[self path]])
    {
        //删除归档文件
        return [defaultManager removeItemAtPath:[self path] error:nil];
    }
    else
    {
        return NO;
    }
}

+(NSString *)path
{
    
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *name = @"tuiboxuserinfo";
    NSString *type = @"sql";
    NSString *allName = [NSString stringWithFormat:@"%@.%@",name,type];
    return [tmpDir stringByAppendingPathComponent:allName];;
}

@end
