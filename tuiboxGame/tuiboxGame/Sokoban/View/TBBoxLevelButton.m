//
//  TBBoxLevelButton.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import "TBBoxLevelButton.h"
#import "TBBrownLabel.h"

@implementation TBBoxLevelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        CGRect labelRect = CGRectMake(0, 0, BOX_MENU_BUTTON_WIDTH, BOX_MENU_BUTTON_HEIGHT);
        levelLabel = [[TBBrownLabel alloc] initWithFrame:labelRect];
        [levelLabel setBackgroundColor:[UIColor clearColor]];
        [levelLabel setTextAlignment:NSTextAlignmentCenter];
        UIFont* levelFont = [UIFont fontWithName:@"FZHPJW" size:LEVEL_LABEL_FONT_SIZE];
        [levelLabel setFont:levelFont];
        [self addSubview:levelLabel];
        
        
        UIImage* starImg = [UIImage imageNamed:@"星左"];
        CGRect starRect1 = CGRectMake(0, -3,
                                      MENU_STAR_SIZE, MENU_STAR_SIZE);
        starView1 = [[UIImageView alloc] initWithFrame:starRect1];
        [starView1 setImage:starImg];
        [self addSubview:starView1];
        [starView1 setHidden:YES];
        
        UIImage *starImg2 = [UIImage imageNamed:@"星"];
        CGRect starRect2 = CGRectMake(BOX_MENU_BUTTON_WIDTH/2-MENU_STAR_SIZE/2, -BOX_MENU_BUTTON_HEIGHT*0.2,
                                      MENU_STAR_SIZE, MENU_STAR_SIZE);
        starView2 = [[UIImageView alloc] initWithFrame:starRect2];
        [starView2 setImage:starImg2];
        [self addSubview:starView2];
        [starView2 setHidden:YES];
        
        UIImage *starImg3 = [UIImage imageNamed:@"星右"];
        CGRect starRect3 = CGRectMake(BOX_MENU_BUTTON_WIDTH-MENU_STAR_SIZE, -3,
                                      MENU_STAR_SIZE, MENU_STAR_SIZE);
        starView3 = [[UIImageView alloc] initWithFrame:starRect3];
        [starView3 setImage:starImg3];
        [self addSubview:starView3];
        [starView3 setHidden:YES];
    }
    return self;
}

- (void)updateWithLevelItem:(TBLevelItem*)aitem
{
    NSString* levelStr = [NSString stringWithFormat:@"%d",[aitem level]];
    [levelLabel setText:levelStr];
    
    if ([aitem score] > 0)
    {
        [starView1 setHidden:NO];
    }
    if ([aitem score] > 1)
    {
        [starView2 setHidden:NO];
    }
    if ([aitem score] > 2)
    {
        [starView3 setHidden:NO];
    }
    if ([aitem isLocked])
    {
        levelLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:104.0/255.0 blue:195.0/255.0 alpha:1.0];
        UIImage* lockImg = [UIImage imageNamed:@"关卡3.png"];
        [self setImage:lockImg forState:UIControlStateNormal];
        [self setUserInteractionEnabled:NO];
    }else {
        if ([aitem score] >0) {
            levelLabel.textColor = [UIColor colorWithRed:208.0/255.0 green:141.0/255.0 blue:46.0/255.0 alpha:1.0];
            UIImage* lockImg = [UIImage imageNamed:@"关卡1.png"];
            [self setImage:lockImg forState:UIControlStateNormal];
            [self setUserInteractionEnabled:YES];
        } else {
            levelLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:104.0/255.0 blue:195.0/255.0 alpha:1.0];
            UIImage* unlockImg = [UIImage imageNamed:@"关卡2.png"];
            [self setImage:unlockImg forState:UIControlStateNormal];
            [self setUserInteractionEnabled:YES];
        }
        
    }
}


@end
