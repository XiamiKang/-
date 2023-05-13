//
//  TBDevice.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/10.
//

#import "TBDevice.h"
#import <UIKit/UIKit.h>

@implementation TBDevice

+ (TBDeviceType) currentDeviceType {
    
    if (YFSCREENWIDTH == 428)
    {
        return TBDevice_iPhonePlus;
    }
    if (YFSCREENWIDTH == 393)
    {
        return TBDevice_iPhonePro;
    }
    if (YFSCREENWIDTH == 430)
    {
        return TBDevice_iPhoneProMax;
    }
    if (YFSCREENWIDTH == 1024)
    {
        return TBDevice_iPad;
    }
    return TBDevice_iPhone;
}


+ (BOOL) isPad
{
    return  ([TBDevice currentDeviceType] == TBDevice_iPad);
}

+ (BOOL) isPhone
{
    return  ([TBDevice currentDeviceType] == TBDevice_iPhone);
}



@end
