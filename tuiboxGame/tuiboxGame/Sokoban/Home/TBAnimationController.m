//
//  TBAnimationController.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import "TBAnimationController.h"

@interface TBAnimationController ()<CAAnimationDelegate>

@end

@implementation TBAnimationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CATransition* animation = [CATransition animation];
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.8f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    [[self.view layer] addAnimation:animation forKey:nil];
}

@end
