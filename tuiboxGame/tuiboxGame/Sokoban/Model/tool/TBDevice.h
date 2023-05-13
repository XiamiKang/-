//
//  TBDevice.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    TBDevice_iPhone = 0,      //390*844
    TBDevice_iPhonePlus,      //428*926
    TBDevice_iPhonePro,       //393*852
    TBDevice_iPhoneProMax,    //430*932
    TBDevice_iPad,            //1024*1366
    TBDevice_Unknown,
}TBDeviceType;

@interface TBDevice : NSObject

+ (TBDeviceType) currentDeviceType;


@end

NS_ASSUME_NONNULL_END
