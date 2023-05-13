//
//  playerCell.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import "BoxMapCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum
{
    BoxManOrientationUp = 0,
    BoxManOrientationDown,
    BoxManOrientationLeft,
    BoxManOrientationRight,
    BoxManOrientationNone,
}PlayerOrientation;

@interface PlayerCell : BoxMapCell
{
    UIImageView*        animateImgView;
    NSMutableArray*     downImgArray;
    NSMutableArray*     upImgArray;
    NSMutableArray*     leftImgArray;
    NSMutableArray*     rightImgArray;
    
    PlayerOrientation   orientation;
    UIImage*            downImgDefault;
    UIImage*            upImgDefault;
    UIImage*            leftImgDefault;
    UIImage*            rightImgDefault;
}

- (void)startAnimation;
- (void)stopAnimation;
- (void)pauseAnimation;
- (void)updateOrientation:(PlayerOrientation) aorientation;

@end

NS_ASSUME_NONNULL_END
