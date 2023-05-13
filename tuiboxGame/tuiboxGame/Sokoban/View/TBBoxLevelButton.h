//
//  TBBoxLevelButton.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/9.
//

#import <UIKit/UIKit.h>
#import "TBLevelItem.h"
#define BOX_MENU_BUTTON_WIDTH       YFSCREENWIDTH/5.5
#define BOX_MENU_BUTTON_HEIGHT      YFSCREENHEIGHT/10.5


#define LEVEL_LABEL_FONT_SIZE       28
#define MENU_STAR_SIZE              BOX_MENU_BUTTON_WIDTH/3

NS_ASSUME_NONNULL_BEGIN

@interface TBBoxLevelButton : UIButton
{
    UILabel*    levelLabel;
    UIImageView* starView1;
    UIImageView* starView2;
    UIImageView* starView3;
}
- (void)updateWithLevelItem:(TBLevelItem*)aitem;

@end

NS_ASSUME_NONNULL_END
