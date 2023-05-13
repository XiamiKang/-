//
//  Toast.h
//  douaiGame
//
//  Created by douaiwan on 2023/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Toast : NSObject

#pragma mark - 中间显示
/**
 *  中间显示
 *
 *  @param text 内容
 */
+ (void)ShowCenterWithText:(NSString *)text;
/**
 *  中间显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)ShowCenterWithText:(NSString *)text duration:(CGFloat)duration;

#pragma mark - 上方显示
/**
 *  上方显示
 *
 *  @param text 内容
 */
+ (void)ShowTopWithText:(NSString *)text;
/**
 *  上方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)ShowTopWithText:(NSString *)text duration:(CGFloat)duration;
/**
 *  上方显示+自定义距顶端距离
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 */
+ (void)ShowTopWithText:(NSString *)text topOffset:(CGFloat)topOffset;
/**
 *  上方显示+自定义距顶端距离+自定义停留时间
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 *  @param duration  停留时间
 */
+ (void)ShowTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration;

#pragma mark - 下方显示
/**
 *  下方显示
 *
 *  @param text 内容
 */
+ (void)ShowBottomWithText:(NSString *)text;
/**
 *  下方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)ShowBottomWithText:(NSString *)text duration:(CGFloat)duration;
/**
 *  下方显示+自定义距底端距离
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 */
+ (void)ShowBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset;
/**
 *  下方显示+自定义距底端距离+自定义停留时间
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 *  @param duration     停留时间
 */
+ (void)ShowBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
