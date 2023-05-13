//
//  TBGmaeViewController.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import <UIKit/UIKit.h>
#import "TBAnimationController.h"
#import "BoxMap.h"
#import "BoxMapCell.h"
#import "CSAnimationSequence.h"
#import "TBBrownLabel.h"
#import "PlayerCell.h"
#import "CSConfirmAlertView.h"
#import "TBSound.h"

#define PH_CELLSIZE_MAX  82
#define PAD_CELLSIZE_MAX 56

#define PER_MOVE_TIME_MAX   (0.24)
#define MOVE_PERIOD_MAX (1.5)
#define PER_MOVE_TIME_ANSWER (0.4)

NS_ASSUME_NONNULL_BEGIN

@interface TBGmaeViewController : TBAnimationController<CSAnimationSequenceDelegate, CSConfirmAlertViewDelegate>

{
    BoxMap*         map;
    
    NSMutableArray*  mapCellArray;
    NSMutableArray*  boxCellArray;
    
    PlayerCell*      personCell;
    
    int              cellWidth;
    float            cellStartX;
    int              cellStartY;
    
    int              steps;
    
    NSMutableArray*  actionHistory;
    NSMutableArray*  oneAction;
    NSArray*         answerArray;
    
    
    CSAnimationSequence*  gameAnimation;
    
    
    BOOL             isPlayingAnswer;
    UIButton*         playButton;
    float            animationIntelval;
    
    int              mGameViewWidth;
    int              mGameViewHeight;
    int              mGameViewStartY;
    int              mButtonPanelHeight;
}


- (id) initWithLevel:(int)alevel;

//返回选关列表
- (IBAction) onBack:(id)sender;
//返回上一步
- (IBAction) cancel_a_step:(id)sender;
//重置关卡
- (IBAction) onReplay:(id)sender;


- (void) stopAllAnimations;

//背景图片
@property (nonatomic, retain) IBOutlet UIImageView*  bgImageView;
//头部view
@property (nonatomic, retain) IBOutlet TBBrownLabel* levelLabel;
@property (nonatomic, retain) IBOutlet UILabel*      stepLabel;
//游戏view
@property (nonatomic, retain) IBOutlet UIView*       gameView;
//返回上一步按钮
@property (nonatomic, retain) IBOutlet UIButton*     lastStepButton;
//游戏界面蒙板
@property (nonatomic, retain) IBOutlet UIView*        darkView;

//PLAY ANSWER
@property (nonatomic, retain) IBOutlet UIView*        playAnswerView;
@property (nonatomic, retain) IBOutlet UIButton*      playAnswerButton;
@property (nonatomic, retain) IBOutlet UIImageView*   fingerView;
@property (nonatomic, retain) IBOutlet UIView*        answerPanel;
- (IBAction)onShowAnswerPanel:(id)sender;
- (IBAction)onPlayAnswer:(id)sender;
- (IBAction)onStopPlayAnswer:(id)sender;

//update button position
@property (nonatomic, retain) IBOutlet UIView*       buttonPanel;


//LEVEL CLEAR
@property (nonatomic, retain) IBOutlet UIView*       levelView;
@property (nonatomic, retain) IBOutlet UIImageView*  starView1;
@property (nonatomic, retain) IBOutlet UIImageView*  starView2;
@property (nonatomic, retain) IBOutlet UIImageView*  starView3;
@property (nonatomic, retain) IBOutlet UILabel*      stepNumLabel;
@property (nonatomic, retain) IBOutlet UILabel*      leastNumLabel;
- (IBAction)goToMenuPage:(id)sender;
- (IBAction)replayThisLevel:(id)sender;
- (IBAction)goToNextLevel:(id)sender;


@end

NS_ASSUME_NONNULL_END
