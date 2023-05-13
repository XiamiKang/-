//
//  TBLevelManage.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/8.
//

#import <Foundation/Foundation.h>
#import "TBLevelItem.h"

#define LEVEL_FILE_NAME    @"LEVEL_FILE_1_0.plist"
#define TOTAL_LEVEL_NUM    60//112

NS_ASSUME_NONNULL_BEGIN

@interface TBLevelManage : NSObject
{
    //关卡
    NSMutableArray *levelArray;
}

+ (TBLevelManage*) sharedInstance;
- (NSString*) filePath;
- (void) saveToDocument;
- (TBLevelItem*) levelItemAtIndex:(int)aindex;
- (void)initialize;
- (void)unlockLevel:(int)alevel;
- (BOOL)isUnlock:(int)alevel;

@property (nonatomic, assign) int totalLevel;//总的关卡数
@property (nonatomic, assign) int currentLevel;//通关的关卡数


@end

NS_ASSUME_NONNULL_END
