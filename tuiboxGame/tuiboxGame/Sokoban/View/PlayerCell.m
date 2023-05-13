//
//  playerCell.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import "PlayerCell.h"

@implementation PlayerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        animateImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:animateImgView];
        
        //PERSON 2
        downImgDefault = [UIImage imageNamed:@"101"];
        UIImage* downImg2 = [UIImage imageNamed:@"103"];
        UIImage* downImg3 = [UIImage imageNamed:@"105"];
        UIImage* downImg4 = [UIImage imageNamed:@"107"];
        UIImage* downImg5 = [UIImage imageNamed:@"109"];
        downImgArray = [[NSMutableArray alloc] initWithObjects:downImgDefault,downImg2,downImg3,downImg4,downImg5,nil];
        [animateImgView setAnimationImages:downImgArray];
        [animateImgView setAnimationDuration:1];
        
        
        upImgDefault = [UIImage imageNamed:@"134"];
        UIImage* upImg2 = [UIImage imageNamed:@"136"];
        UIImage* upImg3 = [UIImage imageNamed:@"138"];
        UIImage* upImg4 = [UIImage imageNamed:@"140"];
        UIImage* upImg5 = [UIImage imageNamed:@"142"];
        upImgArray = [[NSMutableArray alloc] initWithObjects:upImgDefault,upImg2,upImg3,upImg4,upImg5, nil];
       
        
        leftImgDefault = [UIImage imageNamed:@"112"];
        UIImage* leftImg2 = [UIImage imageNamed:@"114"];
        UIImage* leftImg3 = [UIImage imageNamed:@"116"];
        UIImage* leftImg4 = [UIImage imageNamed:@"118"];
        UIImage* leftImg5 = [UIImage imageNamed:@"120"];
        leftImgArray = [[NSMutableArray alloc] initWithObjects:leftImgDefault,leftImg2,leftImg3,leftImg4,
                        leftImg5, nil];
      
        
        rightImgDefault = [UIImage imageNamed:@"123"];
        UIImage* rightImg2 = [UIImage imageNamed:@"125"];
        UIImage* rightImg3 = [UIImage imageNamed:@"127"];
        UIImage* rightImg4 = [UIImage imageNamed:@"129"];
        UIImage* rightImg5 = [UIImage imageNamed:@"131"];
        rightImgArray = [[NSMutableArray alloc] initWithObjects:rightImgDefault,rightImg2,rightImg3,
                         rightImg4,rightImg5, nil];
        
        [animateImgView setImage:downImgDefault];
    }
    return self;
}

- (void)startAnimation
{
    if ([animateImgView isAnimating])
    {
        [animateImgView stopAnimating];
    }
    switch (orientation)
    {
        case BoxManOrientationUp:
        {
            [animateImgView setAnimationImages:upImgArray];
            [animateImgView startAnimating];
        }
            break;
            
        case BoxManOrientationRight:
        {
            [animateImgView setAnimationImages:rightImgArray];
            [animateImgView startAnimating];
        }
            break;
            
        case BoxManOrientationLeft:
        {
            [animateImgView setAnimationImages:leftImgArray];
            [animateImgView startAnimating];
        }
            break;
        
        default:
            [animateImgView setAnimationImages:downImgArray];
            [animateImgView startAnimating];
            break;
    }
}

- (void)stopAnimation
{
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:animateImgView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
}

- (void)pauseAnimation
{
    [animateImgView stopAnimating];
    switch (orientation)
    {
        case BoxManOrientationDown:
        {
            [animateImgView setImage:downImgDefault];
        }
            break;
        
        case BoxManOrientationUp:
        {
            [animateImgView setImage:upImgDefault];
        }
            break;
            
        case BoxManOrientationLeft:
        {
            [animateImgView setImage:leftImgDefault];
        }
            break;
        
        case BoxManOrientationRight:
        {
            [animateImgView setImage:rightImgDefault];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateOrientation:(PlayerOrientation) aorientation
{
    orientation = aorientation;
    [animateImgView setAnimationRepeatCount:0];
    [self startAnimation];
}


@end
