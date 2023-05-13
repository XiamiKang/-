//
//  TBSound.h
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/8.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define TBSOUND_ISON_KEY  @"TBSOUND_ISON_KEY"
#define TBSOUND_DEFAULT_STATE YES

#define TBBGMUSIC_ISON_KEY @"TBBGMUSIC_ISON_KEY"
#define TBBGMUSIC_DEFAULT_STATE YES

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    TBSoundType_KEY = 0,
    TBSoundType_WIN,
    TBSoundType_ERROR,
    TBSoundType_RIGHT,
}TBSoundType;

@interface TBSound : NSObject<AVAudioPlayerDelegate>
{
    BOOL    on;
   
    SystemSoundID  sid1;
    
    //Background Music
    AVAudioPlayer*  bgMusicPlayer;
    int              bgMusicIndex;
    BOOL             bgMusicOn;
    
    AVAudioPlayer*   voicePlayer1;
}

+ (TBSound*) sharedInstance;
- (void)  initialize;
- (BOOL)  isOn;
- (void)  setON:(BOOL)aon;
- (void)  playSound:(TBSoundType)atype;
- (void)  playFile:(NSString*)filename type:(NSString*)filetype;
- (void)  playBackgroundMusic:(NSString*)filename type:(NSString*)filetype;
- (void)  playBackgroundMusicWithData:(NSData*)mdata;
- (void)  playVoice:(NSString*)filename type:(NSString*)filetype;

//Background Music
- (BOOL) isBackgroundMusicOn;
- (void) setBackgroundMusicOn:(BOOL)ison;
- (NSString*) nextBgMusicPath;
- (void) pauseBgMusic;
- (void) continueBgMusic;
- (void) playBgMusic;


@end

NS_ASSUME_NONNULL_END
