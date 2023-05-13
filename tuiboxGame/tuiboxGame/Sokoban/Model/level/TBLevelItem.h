//
//  TBLevelItem.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBLevelItem : NSObject

@property (nonatomic, assign) int   level;
@property (nonatomic, assign) int   score;
@property (nonatomic, assign) BOOL  isLocked;

- (id)initWithLevel:(int)alevel;
- (id)initWithDictionary:(NSDictionary*)adict;
- (NSDictionary*)dictionary;

@end

NS_ASSUME_NONNULL_END
