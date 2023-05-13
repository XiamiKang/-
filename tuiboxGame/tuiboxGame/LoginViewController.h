//
//  LoginViewController.h
//  douaiGame
//
//  Created by douaiwan on 2023/4/27.
//

#import <UIKit/UIKit.h>
//#import "DouaiGameInfo.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger){
    TBLoginPageTypeLogin,
    TBLoginPageTypeSmsLogin,
    TBLoginPageTypeRegist,
}TBLoginPageType;

@interface LoginViewController : UIViewController

@property(copy,nonatomic)void(^CloseNoticeViewBlock)(void);
@property(assign,nonatomic) TBLoginPageType pageType;

//@property(strong,nonatomic) DouaiGameInfo *appInfo;

@end

NS_ASSUME_NONNULL_END
