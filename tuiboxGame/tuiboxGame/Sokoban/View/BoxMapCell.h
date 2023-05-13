//
//  BoxMapCell.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import <UIKit/UIKit.h>
#import "BoxMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface BoxMapCell : UIButton

@property (nonatomic, assign) int   row;
@property (nonatomic, assign) int   column;
@property (nonatomic, assign) MapCellType type;

@property (nonatomic, assign) int    f;
@property (nonatomic, assign) int    g;
@property (nonatomic, assign) int    h;
@property (nonatomic, retain) BoxMapCell* fatherCell;

@end

NS_ASSUME_NONNULL_END
