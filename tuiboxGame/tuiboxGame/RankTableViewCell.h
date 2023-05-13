//
//  RankTableViewCell.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankBgImage;
@property (weak, nonatomic) IBOutlet UILabel *rankNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankSorceLabel;

@end

NS_ASSUME_NONNULL_END
