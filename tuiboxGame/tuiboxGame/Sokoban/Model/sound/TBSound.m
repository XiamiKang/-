//
//  TBSound.m
//  tuiboxGame
//
//  Created by douaiwan on 2023/5/8.
//

#import "TBSound.h"

static TBSound* soundInstance = nil;

@implementation TBSound

- (id)init
{
    self = [super init];
    if (self)
    {
        NSNumber* soundDefault = [[NSUserDefaults standardUserDefaults] objectForKey:TBSOUND_ISON_KEY];
        if (soundDefault == nil)
        {
            on = TBSOUND_DEFAULT_STATE;
            [self setON:on];
        }else
        {
            on = [soundDefault boolValue];
        }
        if (on)
        {
            NSLog(@"声音已打开");
        }else
        {
            NSLog(@"声音关闭");
        }
        
        //load voice
        NSString* musicPath = [[NSBundle mainBundle] pathForResource:@"di"
                                                              ofType:@"wav"];
        if (musicPath && [musicPath length] > 0)
        {
            NSURL* musicURL = [[NSURL alloc] initFileURLWithPath:musicPath];
            voicePlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
            [musicURL release];
        }
    }
    return self;
}

+ (TBSound*) sharedInstance
{
    if (soundInstance == nil)
    {
        soundInstance = [[TBSound alloc] init];
    }
    return soundInstance;
}

- (void)  initialize
{
    
}

- (BOOL)  isOn
{
    return on;
}

- (void)  setON:(BOOL)aon
{
    on = aon;
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:TBSOUND_ISON_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)  playSound:(TBSoundType)atype
{
    if (on)
    {
        switch (atype)
        {
            case TBSoundType_KEY:
            {
                [voicePlayer1 play];
            }
                break;
                
            default:
                AudioServicesPlaySystemSound(sid1);
                break;
        }
    }
}

- (void)  playFile:(NSString*)filename type:(NSString*)filetype
{
    SystemSoundID sid = 0;
    NSString* filepath = [[NSBundle mainBundle] pathForResource:filename
                                                         ofType:filetype];
    CFURLRef turl = (CFURLRef)[NSURL fileURLWithPath:filepath];
    AudioServicesCreateSystemSoundID(turl, &sid);
    
    AudioServicesPlaySystemSound(sid);
}

- (void)  playBackgroundMusic:(NSString*)filename type:(NSString*)filetype
{
    NSString* musicPath = [[NSBundle mainBundle] pathForResource:filename
                                                          ofType:filetype];
    if (musicPath && [musicPath length] > 0)
    {
        NSURL* musicURL = [[NSURL alloc] initFileURLWithPath:musicPath];
        AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
        [player setVolume:0.8];
        [player setNumberOfLoops:-1];
        [player prepareToPlay];
        [player play];
//        [musicURL release];
    }else
    {
        NSLog(@"The music file doesn't exist");
    }
}

- (void)  playVoice:(NSString*)filename type:(NSString*)filetype
{
    if (on)
    {
        NSString* musicPath = [[NSBundle mainBundle] pathForResource:filename
                                                              ofType:filetype];
        if (musicPath && [musicPath length] > 0)
        {
            NSURL* musicURL = [[NSURL alloc] initFileURLWithPath:musicPath];
            AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
            [player prepareToPlay];
            [player play];
//            [musicURL release];
        }else
        {
            NSLog(@"The music file doesn't exist");
        }
    }
}

- (void)  playBackgroundMusicWithData:(NSData*)mdata
{
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:mdata error:nil];
    [player prepareToPlay];
    [player play];
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Background Music
//Background Music
- (BOOL) isBackgroundMusicOn
{
    return bgMusicOn;
}

- (void) setBackgroundMusicOn:(BOOL)ison
{
    bgMusicOn = ison;
    [[NSUserDefaults standardUserDefaults] setBool:bgMusicOn forKey:TBBGMUSIC_ISON_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (bgMusicOn)
    {
        if (bgMusicPlayer && ![bgMusicPlayer isPlaying])
        {
            [self continueBgMusic];
        }else
        {
            [self playBgMusic];
        }
    }else
    {
        [self pauseBgMusic];
    }
}

- (NSString*) nextBgMusicPath
{
    NSArray* musicArray = [NSArray arrayWithObjects:@"bg1.caf",@"bg2.m4a",@"bg3.mp3",@"bg4.mp3",@"bg5.caf",nil];
    NSString* music = [musicArray objectAtIndex:bgMusicIndex];
    NSArray* components = [music componentsSeparatedByString:@"."];
    NSString* name = [components objectAtIndex:0];
    NSString* type = [components objectAtIndex:1];
    NSString* path = nil;
    if (name && [name length] > 0 && type && [type length] > 0)
    {
        path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    }
    bgMusicIndex ++;
    if (bgMusicIndex >= [musicArray count])
    {
        bgMusicIndex = 0;
    }
    return path;
}

- (void) pauseBgMusic
{
    if (bgMusicPlayer && [bgMusicPlayer isPlaying])
    {
        [bgMusicPlayer pause];
    }
}

- (void) continueBgMusic
{
    if (bgMusicOn)
    {
        if (bgMusicPlayer && ![bgMusicPlayer isPlaying])
        {
            [bgMusicPlayer play];
        }
    }
}

- (void) playBgMusic
{
    if (bgMusicOn)
    {
//        NSString* musicPath = [self nextBgMusicPath];
        NSString* musicPath = [[NSBundle mainBundle] pathForResource:@"game_music" ofType:@"mp3"];
        NSURL* musicURL = [[NSURL alloc] initFileURLWithPath:musicPath];
        if (bgMusicPlayer)
        {
            [bgMusicPlayer stop];
            bgMusicPlayer = nil;
        }
        bgMusicPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil] autorelease];
        [bgMusicPlayer setDelegate:self];
        [bgMusicPlayer setNumberOfLoops:2];
        [bgMusicPlayer prepareToPlay];
        [bgMusicPlayer play];
        [musicURL release];
    }
}


#pragma mark -
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self playBgMusic];
}

@end
