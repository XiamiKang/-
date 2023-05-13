//
//  BoxCell.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import "BoxMapCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BoxCell : BoxMapCell
{
    UIImageView*    tickView;
}

- (void)setBoxPushIntoTarget:(BOOL)isin;
@end

NS_ASSUME_NONNULL_END
