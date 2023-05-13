//
//  BoxMapView.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import <UIKit/UIKit.h>
#import "BoxMap.h"
#import "BoxMapCell.h"
#import "CSAnimationSequence.h"
#import "TBBrownLabel.h"


NS_ASSUME_NONNULL_BEGIN

@interface BoxMapView : UIView
{
    BoxMap*          map;
    
    NSMutableArray*  mapCellArray;
    NSMutableArray*  boxCellArray;
    BoxMapCell*      personCell;
    
    int              cellWidth;
    
    int              steps;
    UILabel*         stepLabel;
    
    NSMutableArray*  actionHistory;
    NSMutableArray*  oneAction;
    NSArray*         answerArray;
    
    CSAnimationSequence*  gameAnimation;
    
    BOOL             isPlayingAnswer;
    UIView*          answerView;
    UIButton*        playButton;
    
    UIButton*        goBackButton;
    TBBrownLabel*    levelLabel;
}

- (id)initWithMap:(BoxMap*)amap;


- (void)goback;
- (BOOL)canGoBack;

- (void)playAnswer;
- (void)pauseAnswer;

- (void)stopAllAnimations;

@end

NS_ASSUME_NONNULL_END
