//
//  BoxMapCell.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import "BoxMapCell.h"

@implementation BoxMapCell

@synthesize row;
@synthesize column;
@synthesize type;

@synthesize f;
@synthesize g;
@synthesize h;
@synthesize fatherCell;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setType:(MapCellType)atype
{
    type = atype;
    switch (type)
    {
        case MAPCELL_NONE:
            [self setUserInteractionEnabled:NO];
            break;
            
        case MAPCELL_FLOOR:
        {
            UIImage* floorImg = [UIImage imageNamed:@"草地.png"];
            [self setImage:floorImg forState:UIControlStateNormal];
        }
            break;
            
        case MAPCELL_TARGET:
        {
            UIImage* targetImg = [UIImage imageNamed:@"地标.png"];
            [self setImage:targetImg forState:UIControlStateNormal];
        }
            break;
            
        case MAPCELL_WALL:
        {
            UIImage* wallImg = [UIImage imageNamed:@"墙.png"];
            [self setImage:wallImg forState:UIControlStateNormal];
            [self setUserInteractionEnabled:NO];
        }
            break;
            
        case MAPCELL_BOX:
        {
            UIImage* boxBtnImg = [UIImage imageNamed:@"箱子.png"];
            [self setImage:boxBtnImg forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
    [self setNeedsDisplay];
}

@end
