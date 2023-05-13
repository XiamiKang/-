//
//  TBLevelManage.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/8.
//

#import "TBLevelManage.h"

static TBLevelManage *levelMgrInstance = nil;

@implementation TBLevelManage
@synthesize totalLevel;
@synthesize currentLevel;

+ (TBLevelManage*) sharedInstance
{
    if (levelMgrInstance == nil)
    {
        levelMgrInstance = [[TBLevelManage alloc] init];
    }
    return levelMgrInstance;
}

- (void)initialize
{
    
}

- (void)unlockLevel:(int)alevel
{
    TBLevelItem* item = [levelArray objectAtIndex:alevel];
    [item setIsLocked:NO];
    currentLevel = [item level];
}

- (BOOL)isUnlock:(int)alevel
{
    TBLevelItem* item = [levelArray objectAtIndex:alevel];
    return ![item isLocked];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"22222");
        levelArray = [[NSMutableArray alloc] init];
        
        NSString* filePath = [self filePath];
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (isExist)
        {
            NSDictionary* fileDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
            if (fileDict)
            {
                NSArray* levels = [fileDict objectForKey:@"levels"];
                NSNumber* totalNum = [fileDict objectForKey:@"total"];
                NSNumber* current = [fileDict objectForKey:@"current"];
                if (levels)
                {
                    for (NSDictionary* dict in levels)
                    {
                        TBLevelItem* item = [[TBLevelItem alloc] initWithDictionary:dict];
                        [levelArray addObject:item];
                    }
                }
                if (totalNum)
                {
                    totalLevel = (int)[totalNum integerValue];
                }
                if (current)
                {
                    currentLevel = (int)[current integerValue];
                }
            }
        }else
        {
            NSLog(@"11111");
            totalLevel = TOTAL_LEVEL_NUM;
            currentLevel = 1;
            for (int i = 1; i <= TOTAL_LEVEL_NUM ; i++)
            {
                TBLevelItem* item = [[TBLevelItem alloc] initWithLevel:i];
                [item setIsLocked:YES];
                [levelArray addObject:item];
            }
            TBLevelItem* item1 = [levelArray objectAtIndex:0];
            [item1 setIsLocked:NO];
            [self saveToDocument];
        }
    }
    return self;
}

- (NSString*) filePath
{
    NSArray* folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* path = [[folders objectAtIndex:0] stringByAppendingPathComponent:LEVEL_FILE_NAME];
    return path;
}

- (void) saveToDocument
{
    NSMutableArray* lArray = [[NSMutableArray alloc] init];
    for (TBLevelItem* it in levelArray)
    {
        [lArray addObject:[it dictionary]];
    }
    NSDictionary* fileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              lArray,@"levels",
                              [NSNumber numberWithInteger:TOTAL_LEVEL_NUM],@"total",
                              [NSNumber numberWithInteger:currentLevel],@"current",
                              nil];
    BOOL issuc = [fileDict writeToFile:[self filePath] atomically:YES];
    issuc ? NSLog(@"SAVE SUCCESS ") : NSLog(@"SAVE FAILED ");
}

- (TBLevelItem*) levelItemAtIndex:(int)aindex
{
    if (aindex < [levelArray count])
    {
        TBLevelItem* item = [levelArray objectAtIndex:aindex];
        return item;
    }
    return nil;
}




@end
