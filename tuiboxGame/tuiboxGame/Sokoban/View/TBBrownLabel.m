//
//  TBBrownLabel.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import "TBBrownLabel.h"

@implementation TBBrownLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:nil];
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    float fontSize = [self.font  pointSize];
    int pinkLineWidth = fontSize * 0.14;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, pinkLineWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //CGContextSetLineCap(ctx, kCGLineCapSquare);
    
    
    CGContextSetTextDrawingMode(ctx, kCGTextStroke);
    UIColor* brownColor = [UIColor colorWithRed:58/255.0 green:35/255.0 blue:10/255.0 alpha:1];
    [self setTextColor:brownColor];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    self.textColor = [UIColor whiteColor];
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
}

@end
