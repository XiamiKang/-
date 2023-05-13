//
//  TBMenuViewController.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/8.
//

#import <UIKit/UIKit.h>
#import "TBLevelManage.h"
#import "DDPageControl.h"
#import <StoreKit/SKStoreProductViewController.h>
#import "TBSound.h"

#define AMOUNT_PER_ROW      4
#define AMOUNT_PER_COLUMN   4
#define AMOUNT_PER_PAGE     (AMOUNT_PER_ROW * AMOUNT_PER_COLUMN)


NS_ASSUME_NONNULL_BEGIN

@interface TBMenuViewController : UIViewController<UIScrollViewDelegate,SKStoreProductViewControllerDelegate>
{
    NSMutableArray*     buttonArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *boxMapScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;


@end

NS_ASSUME_NONNULL_END
