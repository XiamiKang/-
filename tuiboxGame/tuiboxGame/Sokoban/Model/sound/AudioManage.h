//
//  AudioManage.h
//  douaiGame
//
//  Created by douaiwan on 2023/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioManage : NSObject
/**
 *播放音乐文件
 */
+(BOOL)playMusic:(NSString *)filename;
/**
 *暂停播放
 */
+(void)pauseMusic:(NSString *)filename;
/**
 *播放音乐文件
 */
+(void)stopMusic:(NSString *)filename;

/**
 *播放音效文件
 */
+(void)playSound:(NSString *)filename;
/**
 *销毁音效
 */
+(void)disposeSound:(NSString *)filename;
@end

NS_ASSUME_NONNULL_END
