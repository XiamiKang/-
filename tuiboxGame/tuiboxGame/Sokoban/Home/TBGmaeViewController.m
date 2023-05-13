//
//  TBGmaeViewController.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import "TBGmaeViewController.h"
#import "BoxMap.h"
#import "AStarNode.h"
#import "BoxCell.h"
#import "TBLevelManage.h"
#import "CSAnimation.h"

#define CSLOCAL(x) (NSLocalizedString(x, nil))
#define YFSCREENWIDTH       [UIScreen mainScreen].bounds.size.width
#define YFSCREENHEIGHT      [UIScreen mainScreen].bounds.size.height

@interface TBGmaeViewController ()

@end

@implementation TBGmaeViewController


@synthesize buttonPanel;

- (id)initWithLevel:(int)alevel
{
    self = [super init];
    if (self)
    {
        map = [[BoxMap alloc] initWithLevel:alevel];
        
        mapCellArray = [[NSMutableArray alloc] init];
        boxCellArray = [[NSMutableArray alloc] init];
        actionHistory = [[NSMutableArray alloc] init];
        oneAction = nil;
        
        gameAnimation = [[CSAnimationSequence alloc] init];
        [gameAnimation setDelegate:self];
        animationIntelval = PER_MOVE_TIME_MAX;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    int stepFontSize = [[self.stepLabel font] pointSize];
    UIFont* stepFont = [UIFont fontWithName:@"CarterOne" size:stepFontSize];
    [self.stepLabel setFont:stepFont];

    
    
    mGameViewWidth = [self.gameView frame].size.width;
    mGameViewHeight = [self.gameView frame].size.height;
    mGameViewStartY = [self.gameView frame].origin.y;
    mButtonPanelHeight = [buttonPanel frame].size.height;
    [self refreshMap];

    CGRect playAnswerRect = CGRectMake(0, 0,
                                       YFSCREENWIDTH,YFSCREENHEIGHT);
    [self.playAnswerView setFrame:playAnswerRect];
    [self.view addSubview:self.playAnswerView];
    [self.playAnswerView setHidden:YES];
    
    self.levelView.frame = CGRectMake(0, 0, YFSCREENWIDTH, YFSCREENHEIGHT);
    [self.view addSubview:self.levelView];
    [self.levelView setHidden:YES];
    
    [self hideDarkView];
     
    [self updateButtonPanelPosition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [gameAnimation clear];
    [gameAnimation stop];
}


#pragma mark --- 返回关卡列表
- (IBAction)onBack:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 绘制关卡
- (void)refreshMap
{
    for (BoxMapCell* mc in mapCellArray)
    {
        [mc removeFromSuperview];
    }
    [mapCellArray removeAllObjects];
    for (BoxCell* mc in boxCellArray)
    {
        [mc removeFromSuperview];
    }
    [boxCellArray removeAllObjects];
    [actionHistory removeAllObjects];
    [personCell removeFromSuperview];
    [self updateGoBackButton];
    [gameAnimation clear];
    
    //CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    NSString* levelText = [NSString stringWithFormat:@"LEVEL %d",[map level]];
    [self.levelLabel setText:levelText];
    
    float rawHeight = mGameViewHeight / [map row];
    float rawWidth = mGameViewWidth / [map column];
    cellWidth = (rawHeight > rawWidth) ? rawWidth : rawHeight;
    if (cellWidth > PH_CELLSIZE_MAX)
    {
        cellWidth = PH_CELLSIZE_MAX;
    }
    cellStartX = (mGameViewWidth - cellWidth*[map column])/2.0;
    cellStartY = (mGameViewHeight - cellWidth*[map row] - mButtonPanelHeight)/2.0;
    
    CGRect newGameRect = CGRectMake(cellStartX, mGameViewStartY + cellStartY, cellWidth*[map column], cellWidth*[map row]);
    [self.gameView setFrame:newGameRect];
        
    int mapSize = [map cellNum];
    for (int i = 0; i < mapSize; i++)
    {
        BoxMapCell* mapCell = [BoxMapCell buttonWithType:UIButtonTypeCustom];
        [mapCell setTag:i];
        int curColumn = i % [map column];
        int curRow = i / [map column];
        CGRect btnRect = CGRectMake(curColumn*cellWidth,curRow*cellWidth, cellWidth, cellWidth);
        [mapCell setFrame:btnRect];
        [mapCell addTarget:self action:@selector(responseToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        MapCellType cellType = [map typeForCellAtIndex:i];
        [mapCell setRow:curRow];
        [mapCell setColumn:curColumn];
        [mapCell setType:cellType];
        [mapCellArray addObject:mapCell];
        [self.gameView addSubview:mapCell];
    }
        
    int boxNum = [map boxNum];
    for (int i = 0; i < boxNum; i++)
    {
        CGSize boxPos = [map positionForBox:i];
        CGRect boxRect = CGRectMake(boxPos.width *cellWidth,boxPos.height * cellWidth,
                                    cellWidth, cellWidth);
        BoxCell* boxCell = [[BoxCell alloc] initWithFrame:boxRect];
        [boxCell addTarget:self action:@selector(responseToButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];

        [boxCell setFrame:boxRect];
        [boxCell setRow:boxPos.height];
        [boxCell setColumn:boxPos.width];
        [boxCell setTag:i];
        [self updateBoxState:boxCell];
        [boxCellArray addObject:boxCell];
        [self.gameView addSubview:boxCell];
    }
    
    CGSize personPos = [map personStartPosition];
    CGRect personRect = CGRectMake(personPos.width*cellWidth,
                                   personPos.height*cellWidth,
                                   cellWidth, cellWidth);
    personCell = [[PlayerCell alloc] initWithFrame:personRect];
    [self.gameView addSubview:personCell];
    [personCell setColumn:personPos.width];
    [personCell setRow:personPos.height];
        
    steps = 0;
    [self updateStepLabel];
    
//    NSString* leastStr = [NSString stringWithFormat:@"%d",[map leastStepNum]];
//    [leastStepLabel setText:leastStr];
}

#pragma mark --- 展示蒙板
- (void)showDarkView
{
    [self.darkView setAlpha:0];
    [self.darkView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self.darkView setAlpha:0.5];
    }completion:^(BOOL isfinished)
    {
        [self.gameView setUserInteractionEnabled:NO];
    }];
}

#pragma mark --- 隐藏蒙板
- (void)hideDarkView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.darkView setAlpha:0];
    }completion:^(BOOL isfinished){
        [self.darkView setHidden:YES];
        [self.gameView setUserInteractionEnabled:YES];
    }];
}

#pragma mark --- 更新下方控制面板
- (void)updateButtonPanelPosition
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect gameRect = self.gameView.frame;
    int blankStartY = gameRect.origin.y + gameRect.size.height;
    blankStartY = screenRect.size.height - blankStartY - 50;
    int blankHeight = screenRect.size.height - blankStartY;
    CGRect panelRect = buttonPanel.bounds;
    int newPanelStartY = blankStartY + (blankHeight - panelRect.size.height - 36)/2.0;
    CGRect newPanelRect = CGRectMake((screenRect.size.width - panelRect.size.width)/2.0,
                                     newPanelStartY, panelRect.size.width, panelRect.size.height);
    [buttonPanel setFrame:newPanelRect];
}

#pragma mark --- 回退上一步
- (IBAction)cancel_a_step:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    
    if ([actionHistory count] > 0)
    {
        NSArray* action = [actionHistory lastObject];
        [self playActionsFromBackward:action];
        [actionHistory removeLastObject];
        [self updateGoBackButton];
        
        int num = (int)[action count] - 1;
        steps -= num;
        if (steps < 0)
        {
            steps = 0;
        }
        [self updateStepLabel];
    }
}

#pragma mark --- 展示答案面板
- (IBAction)onShowAnswerPanel:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.playAnswerView setHidden:NO];
    [self.view bringSubviewToFront:self.playAnswerView];
    
    [self showDarkView];
    [self.answerPanel.layer addAnimation:[CSAnimation popup] forKey:@"pop up ani"];
    
    //归位
    isPlayingAnswer = NO;
    [self updatePlayButton];
    [self changeToReadyState];
    [gameAnimation clear];
}

#pragma mark --- 重置关卡
- (IBAction)onReplay:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
//    TBConfirmAlertView *alertView = [[TBConfirmAlertView alloc] init];
//    alertView.delegate = self;
    [CSConfirmAlertView showConfirm:@"是否重置关卡？" withDelegate:self];
}

#pragma mark --- 开始播放答案
- (IBAction)onPlayAnswer:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    
    isPlayingAnswer = !isPlayingAnswer;
    animationIntelval = PER_MOVE_TIME_ANSWER;
    [self updatePlayButton];
    
    if (!isPlayingAnswer)
    {
        [gameAnimation stop];
        //[self showDarkView];
    }else
    {
        if ([[gameAnimation groups] count] <= 0)
        {
            [self changeToReadyState];
            
            [self.fingerView setHidden:YES];
            
            for (NSArray* actions in [map answerArray])
            {
                //add finger touch animation
                [self.fingerView setHidden:NO];
           
                
                int target_x = 0, target_y = 0;
                NSString* posStr = [actions lastObject];
                NSArray* strs = [posStr componentsSeparatedByString:@","];
                if ([strs count] >= 3)
                {
                    NSString* s1 = [strs objectAtIndex:0];
                    if ([s1 isEqualToString:@"p"])
                    {
                        NSString* sx = [strs objectAtIndex:1];
                        NSString* sy = [strs objectAtIndex:2];
                        target_x = (int)[sx integerValue];
                        target_y = (int)[sy integerValue];
                    }
                    else if([s1 isEqualToString:@"bp"])
                    {
                        NSString* spx1 = [strs objectAtIndex:4];
                        NSString* spy1 = [strs objectAtIndex:5];
                        target_x = (int)[spx1 integerValue];
                        target_y = (int)[spy1 integerValue];
                    }
                }
                
                int targetCellID = target_y * [map column] + target_x;
                BoxMapCell* cell = [mapCellArray objectAtIndex:targetCellID];
                
                CGRect fingerRect = CGRectMake(self.gameView.frame.origin.x + (target_x + 0.5) * cellWidth,
                                               self.gameView.frame.origin.y + (target_y + 0.5) * cellWidth,
                                               cellWidth, cellWidth);
                
                CSAnimationItem* posChangeAniItem = [CSAnimationItem itemWithDuration:0 delay:0
                                                                              options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                                                                  //[personCell pauseAnimation];
                                                                                  [self.fingerView setFrame:fingerRect];
                    [self.fingerView setHidden:NO];
                                                                              }];
                
                CSAnimationItem* fAnim1 =
                [CSAnimationItem itemWithDuration:0.6  delay:0
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             [cell setSelected:YES];
                                             CGRect rect1 = CGRectInset(fingerRect,
                                                                        fingerRect.size.width*0.05,
                                                                        fingerRect.size.height*0.05);
                                             [self.fingerView setFrame:rect1];
                                         }];
                CSAnimationItem* fAnim2 =
                [CSAnimationItem itemWithDuration:0.6  delay:0
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           [cell setSelected:YES];
                                           CGRect rect1 = CGRectInset(fingerRect,
                                                                      -fingerRect.size.width*0.05,
                                                                      -fingerRect.size.height*0.05);
                                           [self.fingerView setFrame:rect1];
                                       }];
                CSAnimationItem* fAnim3 =
                [CSAnimationItem itemWithDuration:0.6  delay:0
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           [cell setSelected:YES];
                                           CGRect rect1 = CGRectInset(fingerRect,
                                                                      -fingerRect.size.width*0.05,
                                                                      -fingerRect.size.height*0.05);
                                                                      [self.fingerView setFrame:rect1];
                                       }];
                CSAnimationItem* removeFingerAniItem =
                [CSAnimationItem itemWithDuration:1.5 delay:0
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           [cell setSelected:NO];
                                           [self.fingerView setHidden:YES];
                                       }];
                CSAnimationGroup* group1 = [CSAnimationGroup groupWithItems:[NSArray arrayWithObjects:posChangeAniItem,nil]];
                [gameAnimation addAnimationGroup:group1];
                
                CSAnimationGroup* group2 = [CSAnimationGroup groupWithItems:[NSArray arrayWithObjects:fAnim1, nil]];
                [gameAnimation addAnimationGroup:group2];
                
                CSAnimationGroup* group3 = [CSAnimationGroup groupWithItems:[NSArray arrayWithObjects:fAnim2, nil]];
                [gameAnimation addAnimationGroup:group3];
                
                CSAnimationGroup* group4 = [CSAnimationGroup groupWithItems:[NSArray arrayWithObjects:fAnim3, nil]];
                [gameAnimation addAnimationGroup:group4];
                
                CSAnimationGroup* group5 = [CSAnimationGroup groupWithItems:[NSArray arrayWithObjects:removeFingerAniItem, nil]];
                [gameAnimation addAnimationGroup:group5];
                
                [self playActions:actions];
            }
        }
        [gameAnimation start];
    }
}

#pragma mark --- 暂停播放答案
- (IBAction)onStopPlayAnswer:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    isPlayingAnswer = NO;
    animationIntelval = PER_MOVE_TIME_MAX;
    [self.playAnswerView setHidden:YES];
    [self changeToReadyState];
    
    [self hideDarkView];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark --- 结束所有动画
- (void)stopAllAnimations
{
    [gameAnimation clear];
    [gameAnimation stop];
}


#pragma mark -
#pragma mark --- 游戏地板点击后的动画以及逻辑
- (void)responseToButtonAction:(id)sender
{
    BoxMapCell* cell = (BoxMapCell*)sender;
    
    int boxIndex = 0;
    for (boxIndex = 0; boxIndex < [boxCellArray count]; boxIndex++)
    {
        BoxCell* c = [boxCellArray objectAtIndex:boxIndex];
        if ([c isEqual:cell])
        {
            break;
        }
    }
    
    
    //判断人可否走到按下的位置
    NSArray* pathArray = [map pathFromOriginX:[personCell column] originY:[personCell row]
                                      toDestx:[cell column] desty:[cell row]];
    if (pathArray == nil || [pathArray count] < 2)
    {
        NSLog(@"路径出错:%d",(int)[pathArray count]);
    }else
    {
        [gameAnimation clear];
        
        //纪录操作
        if (oneAction != nil)
        {
            
            oneAction = nil;
        }
        oneAction = [[NSMutableArray alloc] init];
        [oneAction addObject:[NSString stringWithFormat:@"p,%d,%d",[personCell column],[personCell row]]];
        
        NSMutableArray* nodes = [[NSMutableArray alloc] initWithArray:pathArray];
        
        int stepnum = (int)[nodes count] - 1;
        float moveTime = 0;
        if (stepnum > 0)
        {
            moveTime = MOVE_PERIOD_MAX / stepnum;
            if (moveTime > PER_MOVE_TIME_MAX)
            {
                animationIntelval = PER_MOVE_TIME_MAX;
            }else
            {
                animationIntelval = moveTime;
            }
        }
        //NSLog(@" step num:%d aniint:%.2f",stepnum,moveTime);
        
        for (int i = (int)[nodes count] - 2; i >= 0; i--)
        {
            AStarNode* nextNode = [nodes objectAtIndex:i];//[nodes lastObject];
            
            // Destination Node
            AStarNode* destNode = [nodes objectAtIndex:0];
            int destCellIndex = [destNode row]*[map column] + [destNode column];
            //arrive destination node
            
            if ( i == 0 && [map boxExistAtIndex:destCellIndex] )
            {
                AStarNode* last2Node = [nodes objectAtIndex:1];
                
                int bx = 0, by = 0;
                if ([nextNode row] == [last2Node row])
                {
                    by = [nextNode row];
                    bx = [nextNode column] + [nextNode column] - [last2Node column];
                }else
                {
                    bx = [nextNode column];
                    by = [nextNode row] + [nextNode row] - [last2Node row];
                }
                
                int perNext = by*[map column] + bx;
                BoxMapCell* mapCellForBoxNext = [mapCellArray objectAtIndex:perNext];
                BoxMapCell* boxCellAtBoxNext = [self boxCellAtX:bx y:by];
                
                // if there's no box at next position
                if (boxCellAtBoxNext == nil)
                {
                    if ([mapCellForBoxNext type] == MAPCELL_FLOOR ||
                        [mapCellForBoxNext type] == MAPCELL_TARGET )
                    {
                        if (oneAction != nil)
                        {
                            [oneAction addObject:[NSString stringWithFormat:@"bp,%d,%d,%d,%d,%d,%d,%d",boxIndex,
                                                  bx,by,[nextNode column],[nextNode row],[last2Node column],[last2Node row]]];
                        }
                        CSAnimationItem* boxAni = [self moveBox:boxIndex toX:bx toY:by];

                        CSAnimationItem* perAni = [self movePersonToX:[nextNode column] y:[nextNode row] addStep:YES];
                        CSAnimationGroup* group = [CSAnimationGroup groupWithItems:[NSArray arrayWithObjects:boxAni,perAni, nil]];
                        [gameAnimation addAnimationGroup:group];
                    }
                }else
                {
                    NSLog(@"can not move");
                }
                
            }else
            {
                if (oneAction != nil)
                {
                    NSLog(@"add one action");
                    [oneAction addObject:[NSString stringWithFormat:@"p,%d,%d",[nextNode column],[nextNode row]]];
                }
                CSAnimationItem* perAni = [self movePersonToX:[nextNode column] y:[nextNode row] addStep:YES];
                CSAnimationGroup* group = [CSAnimationGroup groupWithItem:perAni];
                [gameAnimation addAnimationGroup:group];
            }
            if (i == 0)
            {
                if (oneAction != nil)
                {
                    [actionHistory addObject:oneAction];
                    [self updateGoBackButton];
                  
                    oneAction = nil;
                }
            }
        }
        
        [gameAnimation start];
      
    }
}

- (CSAnimationItem*)movePersonToX:(int)ax y:(int)ay addStep:(BOOL)isadd
{
    CGRect newRect = CGRectMake(ax*cellWidth,
                                ay*cellWidth,
                                cellWidth, cellWidth);
    
    CGPoint cp = CGPointMake(newRect.origin.x + newRect.size.width / 2.0,
                             newRect.origin.y + newRect.size.width/2.0);
    
    CSAnimationItem* moveItem = [CSAnimationItem itemWithDuration:animationIntelval  delay:0
                                                          options:UIViewAnimationOptionCurveLinear
                                                       animations:^{
                                                           int x_dis = [self->personCell column] - ax;
                                                           int y_dis = [self->personCell row] - ay;
        PlayerOrientation ori = BoxManOrientationNone;
                                                           if (x_dis > 0)
                                                           {
                                                               ori = BoxManOrientationLeft;
                                                           }else if(x_dis < 0)
                                                           {
                                                               ori = BoxManOrientationRight;
                                                           }else
                                                           {
                                                               if (y_dis > 0)
                                                               {
                                                                   ori = BoxManOrientationUp;
                                                               }else
                                                               {
                                                                   ori = BoxManOrientationDown;
                                                               }
                                                           }
                                                              [self->personCell setCenter:cp];
                                                              [self->personCell setColumn:ax];
                                                              [self->personCell setRow:ay];
                                                              [self->personCell updateOrientation:ori];
                                                           
                                                              if (isadd)
                                                              {
                                                                  self->steps ++;
                                                                  [self updateStepLabel];
                                                              }
                                                          }];
    return moveItem;
}

- (CSAnimationItem*)moveBox:(int)boxID toX:(int)ax toY:(int)ay;
{
    if (boxID >= [map boxNum])
    {
        NSLog(@"moveBox:toX:toY aid参数过大");
        return nil;
    }
    
    BoxCell* boxCell = [boxCellArray objectAtIndex:boxID];
    
    CGRect boxRect = CGRectMake(ax * cellWidth,
                                ay * cellWidth,
                                cellWidth, cellWidth);
    CGPoint cp = CGPointMake(boxRect.origin.x + boxRect.size.width/2.0, boxRect.origin.y + boxRect.size.height/2.0);
    
    CSAnimationItem* moveItem = [CSAnimationItem itemWithDuration:animationIntelval delay:0
                                                          options:UIViewAnimationOptionCurveLinear
                                                       animations:
                                 ^{
                                     [self->map setBoxAtIndex:boxID toPositionX:ax Y:ay];
                                     [boxCell setCenter:cp];
                                     [boxCell setColumn:ax];
                                     [boxCell setRow:ay];
                                     [self updateBoxState:boxCell];
                                     
                                     if ([self->map isFinished])
                                     {
                                         NSArray* folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                         NSString* filename = [NSString stringWithFormat:@"action%d",[self->map level]];
                                         NSString* actionPath = [[folders objectAtIndex:0] stringByAppendingPathComponent:filename];
                                         //NSLog(@"action path:%@",actionPath);
                                         BOOL res = [self->actionHistory writeToFile:actionPath atomically:YES];
                                         if (res)
                                         {
                                             NSLog(@"fil 存储成功");
                                         }else
                                         {
                                             NSLog(@"保存失败");
                                         }
                                         
                                         if (!self->isPlayingAnswer)
                                         {
                                             [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                                                            selector:@selector(popWinTip)
                                                                            userInfo:nil repeats:NO];
                                         }
                                     }
                                 }];
    return moveItem;
}


- (void)popWinTip
{
    [self.levelView setHidden:NO];
    
    //calc level star
    int starLevel = 0;
    int leastStep = [map leastStepNum];
    if (steps <= leastStep)
    {
        starLevel = 3;
    }else if(steps <= leastStep * 1.2)
    {
        starLevel = 2;
    }else
    {
        starLevel = 1;
    }
    if (starLevel > 0)
    {
        [self.starView1 setHidden:NO];
    }
    if (starLevel > 1)
    {
        [self.starView2 setHidden:NO];
    }
    if (starLevel > 2)
    {
        [self.starView3 setHidden:NO];
    }
    
    NSString* stepStr = [NSString stringWithFormat:@"%d",steps];
    [self.stepNumLabel setText:stepStr];
    NSString* leastStepStr = [NSString stringWithFormat:@"%d",[map leastStepNum]];
    [self.leastNumLabel setText:leastStepStr];
    
    int currentLevel = [map level] - 1;
    TBLevelItem* li = [[TBLevelManage sharedInstance] levelItemAtIndex:currentLevel];
    if ([li score] < starLevel)
    {
        [li setScore:starLevel];
    }

    if (([map level] < TOTAL_LEVEL_NUM) &&
        ![[TBLevelManage sharedInstance] isUnlock:[map level]])
    {
        [[TBLevelManage sharedInstance] unlockLevel:[map level]];
    }
    [[TBLevelManage sharedInstance] saveToDocument];
}

- (void)dismissLevelView
{
    [self.levelView setHidden:YES];
    [self.starView1 setHidden:YES];
    [self.starView2 setHidden:YES];
    [self.starView3 setHidden:YES];
}

#pragma mark --- 更新关卡名字
- (void)updateStepLabel
{
    NSString* str = [NSString stringWithFormat:@"%d",steps];
    [self.stepLabel setText:str];
}

#pragma mark --- 回退的按钮显示与否
- (void)updateGoBackButton
{
    if ([actionHistory count] == 0)
    {
        [self.lastStepButton setHidden:YES];
    }else if ([actionHistory count] > 0)
    {
        [self.lastStepButton setHidden:NO];
    }
}


- (BoxMapCell*)boxCellAtX:(int)ax y:(int)ay
{
    BoxMapCell* res = nil;
    for (BoxCell* cell in boxCellArray)
    {
        if (([cell column] == ax) && ([cell row] == ay))
        {
            res = cell;
            break;
        }
    }
    return res;
}

#pragma mark --- 重置关卡
- (void)changeToReadyState
{
    //两个参数都被改了，需要增加参数
    int boxNum = [map boxNum];
    for (int i = 0; i < boxNum; i++)
    {
        BoxCell* boxCell = [boxCellArray objectAtIndex:i];
        CGSize boxPos = [map originalPositionForBox:i];
        CGRect boxRect = CGRectMake(boxPos.width *cellWidth,
                                    boxPos.height * cellWidth,
                                    cellWidth, cellWidth);
        [boxCell setFrame:boxRect];
        [boxCell setRow:boxPos.height];
        [boxCell setColumn:boxPos.width];
        [map setBoxAtIndex:i toPositionX:boxPos.width Y:boxPos.height];
        [self updateBoxState:boxCell];
    }
    
    CGSize personPos = [map personStartPosition];
    CGRect personRect = CGRectMake(personPos.width*cellWidth,
                                 personPos.height*cellWidth,
                                   cellWidth, cellWidth);
    [personCell setFrame:personRect];
    [personCell setColumn:personPos.width];
    [personCell setRow:personPos.height];
    [self.view setNeedsDisplay];
    
    //step label 清零
    steps = 0;
    [self updateStepLabel];
    
    //操作纪录清零
    [actionHistory removeAllObjects];
    [self updateGoBackButton];
    [gameAnimation clear];
}

#pragma mark --- 回退上一步的逻辑操作1
- (void)playActionsFromBackward:(NSArray*)actions
{
    int last = (int)[actions count] - 1;
    [gameAnimation clear];
    for (int i = last; i >= 0; i--)
    {
        NSString* act = [actions objectAtIndex:i];
        [self playActionBackWard:act];
    }
    [gameAnimation start];
}

#pragma mark --- 回退上一步的逻辑操作2
- (void)playActionBackWard:(NSString*)act
{
    //回退情况
    NSArray* strs = [act componentsSeparatedByString:@","];
    if ([strs count] >= 3)
    {
        
        NSString* s1 = [strs objectAtIndex:0];
        if ([s1 isEqualToString:@"p"])
        {
            NSString* sx = [strs objectAtIndex:1];
            NSString* sy = [strs objectAtIndex:2];
            int px = (int)[sx integerValue];
            int py = (int)[sy integerValue];
            CSAnimationItem* perAni = [self movePersonToX:px y:py addStep:NO];
            CSAnimationGroup* group = [CSAnimationGroup groupWithItem:perAni];
            [gameAnimation addAnimationGroup:group];
        }else if([s1 isEqualToString:@"bp"])
        {
            NSString* sboxID = [strs objectAtIndex:1];
            NSString* spx1 = [strs objectAtIndex:4];
            NSString* spy1 = [strs objectAtIndex:5];
            NSString* spx2 = [strs objectAtIndex:6];
            NSString* spy2 = [strs objectAtIndex:7];
            int boxID = (int)[sboxID integerValue];
            int px1 = (int)[spx1 integerValue];
            int py1 = (int)[spy1 integerValue];
            int px2 = (int)[spx2 integerValue];
            int py2 = (int)[spy2 integerValue];
            
            CSAnimationItem* boxAni = [self moveBox:boxID toX:px1 toY:py1];
            CSAnimationItem* personAni = [self movePersonToX:px2 y:py2 addStep:NO];
            CSAnimationGroup* group = [CSAnimationGroup groupWithItems:[NSArray arrayWithObjects:personAni,boxAni, nil]];
            [gameAnimation addAnimationGroup:group];
        }
    }
}

#pragma mark --- 小人的操作逻辑
- (void)playActions:(NSArray*)actions
{
    int i = 0;
    for (NSString* act in actions)
    {
        NSArray* strs = [act componentsSeparatedByString:@","];
        if ([strs count] >= 3)
        {
            NSString* s1 = [strs objectAtIndex:0];
            if ([s1 isEqualToString:@"p"])
            {
                NSString* sx = [strs objectAtIndex:1];
                NSString* sy = [strs objectAtIndex:2];
                int px = (int)[sx integerValue];
                int py = (int)[sy integerValue];
                BOOL isadd = YES;
                if (i == 0)
                {
                    isadd = NO;
                }
                CSAnimationItem* perAni = [self movePersonToX:px y:py addStep:isadd];
                CSAnimationGroup* group = [CSAnimationGroup groupWithItem:perAni];
                [gameAnimation addAnimationGroup:group];
            }
            else if([s1 isEqualToString:@"bp"])
            {
                NSString* sboxID = [strs objectAtIndex:1];
                NSString* sbx2 = [strs objectAtIndex:2];
                NSString* sby2 = [strs objectAtIndex:3];
                NSString* spx1 = [strs objectAtIndex:4];
                NSString* spy1 = [strs objectAtIndex:5];
                int boxID = (int)[sboxID integerValue];
                int bx2 = (int)[sbx2 integerValue];
                int by2 = (int)[sby2 integerValue];
                int px1 = (int)[spx1 integerValue];
                int py1 = (int)[spy1 integerValue];
                
                BOOL isadd = YES;
                if (i == 0)
                {
                    isadd = NO;
                }
                CSAnimationItem* bAni = [self moveBox:boxID toX:bx2 toY:by2];
                CSAnimationItem* pAni = [self movePersonToX:px1 y:py1 addStep:isadd];
                CSAnimationGroup* group = [CSAnimationGroup groupWithItems:[NSArray arrayWithObjects:pAni,bAni, nil]];
                [gameAnimation addAnimationGroup:group];
            }
            
        }
        i++;
    }
}


#pragma mark --- 播放按钮状态
- (void)updatePlayButton
{
    if (!isPlayingAnswer)
    {
        UIImage* playImg = [UIImage imageNamed:@"播放按钮.png"];
        [self.playAnswerButton setImage:playImg forState:UIControlStateNormal];
        [self.playAnswerButton.layer addAnimation:[CSAnimation pulse] forKey:@"pulse"];
    }else
    {
        UIImage* pauseImg = [UIImage imageNamed:@"暂停按钮.png"];
        [self.playAnswerButton setImage:pauseImg forState:UIControlStateNormal];
        [self.playAnswerButton.layer removeAllAnimations];
    }
}

#pragma mark --- 箱子的状态（是否退到正确位置）
- (void)updateBoxState:(BoxCell*)acell
{
    int bx = [acell column];
    int by = [acell row];
    int bcIndex = by * [map column] + bx;
    MapCellType bcType = [map typeForCellAtIndex:bcIndex];
    if (bcType == MAPCELL_TARGET)
    {
        [acell setBoxPushIntoTarget:YES];
    }else
    {
        [acell setBoxPushIntoTarget:NO];
    }
}


#pragma mark -
#pragma mark CSAnimationSequenceDelegate
- (void)animationSequenceFinished
{
    isPlayingAnswer = NO;
    [self updatePlayButton];
    [gameAnimation clear];
    
    [personCell stopAnimation];
}

#pragma mark --- 关卡通关后的操作
#pragma mark LEVEL CLEAR
- (IBAction)goToMenuPage:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)replayThisLevel:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    [self dismissLevelView];
    [self changeToReadyState];
}

- (IBAction)goToNextLevel:(id)sender
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    int currentLevel = [map level];
    //此处应该判断是否有下一个LEVEL
    if (currentLevel + 1 <= TOTAL_LEVEL_NUM)
    {
        [map updateLevelData:currentLevel+1];
        [self refreshMap];
    }else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恭喜您" message:@"您已经" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    [self dismissLevelView];
}


#pragma mark -
#pragma mark TBConfirmAlertViewDelegate
- (void) confirmAlertViewYesPressed:(CSConfirmAlertView *)alertview
{
    NSLog(@"弹框代理yes");
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
    [self changeToReadyState];
}

- (void) confirmAlertViewCancelPressed:(CSConfirmAlertView *)alertview
{
    [[TBSound sharedInstance] playSound:TBSoundType_KEY];
}



@end
