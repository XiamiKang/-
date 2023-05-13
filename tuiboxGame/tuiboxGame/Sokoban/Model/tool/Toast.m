//
//  Toast.m
//  douaiGame
//
//  Created by douaiwan on 2023/5/4.
//

#import "Toast.h"
#import <UIKit/UIKit.h>
//Toast默认停留时间
#define ToastDispalyDuration 1.2f
//Toast到顶端/底端默认距离
#define ToastSpace 100.0f
//Toast背景颜色
#define ToastBackgroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:.8]

@interface Toast (){
    UIButton *_contentView;
    CGFloat  _duration;
}

@end

@implementation Toast

/**
 移除观察者
 */
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

/**
 初始化提示文本

 @param text 文本
 @return 提示框对象
 */
- (instancetype)initWithText:(NSString *)text {
    if (self = [super init]) {
        
        UIFont *font = [UIFont systemFontOfSize:12.0f];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width + 20, rect.size.height+ 10)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        _contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        _contentView.layer.cornerRadius = 4.0f;
        _contentView.backgroundColor = ToastBackgroundColor;
        [_contentView addSubview:textLabel];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_contentView addTarget:self action:@selector(toastTaped:) forControlEvents:UIControlEventTouchDown];
        _contentView.alpha = 0.0f;
        _duration = ToastDispalyDuration;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    
    return self;
}

/**
 设备改变通知

 @param notify 通知
 */
- (void)deviceOrientationDidChanged:(NSNotification *)notify {
    [self hideAnimation];
}

/**
 移除提示框
 */
-(void)dismissToast{
    [_contentView removeFromSuperview];
}

/**
 点击提示框出发事件

 @param sender 出发控件
 */
-(void)toastTaped:(UIButton *)sender {
    [self hideAnimation];
}

/**
 设置提示框显示时间

 @param duration 时间
 */
- (void)setDuration:(CGFloat)duration {
    _duration = duration;
}

/**
 提示框显示动画
 */
-(void)showAnimation {
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    _contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

/**
 提示框隐藏动画
 */
-(void)hideAnimation {
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.2];
    _contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

/**
 显示提示框
 */
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    _contentView.center = window.center;
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

/**
 设置距离顶部显示提示框

 @param top 距离顶部
 */
- (void)showFromTopOffset:(CGFloat)top {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    _contentView.center = CGPointMake(window.center.x, top + _contentView.frame.size.height/2);
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

/**
 设置距离底部显示提示框

 @param bottom 底部距离
 */
- (void)showFromBottomOffset:(CGFloat)bottom {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    _contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottom + _contentView.frame.size.height/2));
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

#pragma mark - 中间显示
/**
 设置子屏幕中间显示提示框

 @param text 提示文本
 */
+ (void)ShowCenterWithText:(NSString *)text {
    [Toast ShowCenterWithText:text duration:ToastDispalyDuration];
}

/**
 *  中间显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)ShowCenterWithText:(NSString *)text duration:(CGFloat)duration {
    Toast *toast = [[Toast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast show];
}

#pragma mark - 上方显示
/**
 *  上方显示
 *
 *  @param text 内容
 */
+ (void)ShowTopWithText:(NSString *)text {
    [Toast ShowTopWithText:text topOffset:ToastSpace duration:ToastDispalyDuration];
}

/**
 *  上方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)ShowTopWithText:(NSString *)text duration:(CGFloat)duration {
    [Toast ShowTopWithText:text topOffset:ToastSpace duration:duration];
}

/**
 *  上方显示+自定义距顶端距离
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 */
+ (void)ShowTopWithText:(NSString *)text topOffset:(CGFloat)topOffset {
    [Toast ShowTopWithText:text topOffset:topOffset duration:ToastDispalyDuration];
}

/**
 *  上方显示+自定义距顶端距离+自定义停留时间
 *
 *  @param text      内容
 *  @param topOffset 到顶端距离
 *  @param duration  停留时间
 */
+ (void)ShowTopWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration {
    Toast *toast = [[Toast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showFromTopOffset:topOffset];
}

#pragma mark - 下方显示
/**
 *  下方显示
 *
 *  @param text 内容
 */
+ (void)ShowBottomWithText:(NSString *)text {
    [Toast ShowBottomWithText:text bottomOffset:ToastSpace duration:ToastDispalyDuration];
}

/**
 *  下方显示+自定义停留时间
 *
 *  @param text     内容
 *  @param duration 停留时间
 */
+ (void)ShowBottomWithText:(NSString *)text duration:(CGFloat)duration {
    [Toast ShowBottomWithText:text bottomOffset:ToastSpace duration:duration];
}

/**
 *  下方显示+自定义距底端距离
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 */
+ (void)ShowBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset {
    [Toast ShowBottomWithText:text bottomOffset:bottomOffset duration:ToastDispalyDuration];
}

/**
 *  下方显示+自定义距底端距离+自定义停留时间
 *
 *  @param text         内容
 *  @param bottomOffset 距底端距离
 *  @param duration     停留时间
 */
+ (void)ShowBottomWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration {
    Toast *toast = [[Toast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

@end
