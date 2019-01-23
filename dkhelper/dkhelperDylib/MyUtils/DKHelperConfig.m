//
//  DKHelperConfig.m
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/22.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import "DKHelperConfig.h"
#import <AVFoundation/AVFoundation.h>

@interface DKHelperConfig()
@property (nonatomic, strong) AVAudioPlayer *blankPlayer; //无声音频播放器
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskIdentifier; //后台任务标识符
@end

@implementation DKHelperConfig
+ (instancetype)shared {
    static DKHelperConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[DKHelperConfig alloc] init];
    });
    return config;
}

NSString* cmdString(SEL sel){
    NSString * str = NSStringFromSelector(sel);
    if ([str hasPrefix:@"set"]){
        NSString *fitstChar = [str substringWithRange:NSMakeRange(3, 1)].lowercaseString;
        NSString *subStr = [str substringWithRange:NSMakeRange(4, str.length-5)];
        str = [NSString stringWithFormat:@"%@%@",fitstChar,subStr];
    }

    return str;
}


+(BOOL)autoRedEnvelop{
    return [NSUserDefaults.standardUserDefaults boolForKey:cmdString(_cmd)];
}
+(void)setAutoRedEnvelop:(BOOL)value{
    [NSUserDefaults.standardUserDefaults setBool:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+(BOOL)preventRevoke{
    return [NSUserDefaults.standardUserDefaults boolForKey:cmdString(_cmd)];
}
+(void)setPreventRevoke:(BOOL)value{
    [NSUserDefaults.standardUserDefaults setBool:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}


+(BOOL)changeSteps{
    return [NSUserDefaults.standardUserDefaults boolForKey:cmdString(_cmd)];
}
+(void)setChangeSteps:(BOOL)value{
    [NSUserDefaults.standardUserDefaults setBool:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}


+(NSInteger)changedSteps{
    return [NSUserDefaults.standardUserDefaults integerForKey:cmdString(_cmd)];
}
+(void)setChangedSteps:(NSInteger)value{
    [NSUserDefaults.standardUserDefaults setInteger:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+(BOOL)gamePlugEnable{
    return [NSUserDefaults.standardUserDefaults boolForKey:cmdString(_cmd)];
}
+(void)setGamePlugEnable:(BOOL)value{
    [NSUserDefaults.standardUserDefaults setBool:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+(BOOL)redEnvelopBackGround{
    return [NSUserDefaults.standardUserDefaults boolForKey:cmdString(_cmd)];
}
+(void)setRedEnvelopBackGround:(BOOL)value{
    [NSUserDefaults.standardUserDefaults setBool:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+(NSInteger)redEnvelopDelay{
    return [NSUserDefaults.standardUserDefaults integerForKey:cmdString(_cmd)];
}
+(void)setRedEnvelopDelay:(NSInteger)value{
    [NSUserDefaults.standardUserDefaults setInteger:value forKey:cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+(NSString *)redEnvelopTextFiter{
    return [NSUserDefaults.standardUserDefaults stringForKey:cmdString(_cmd)];
}
+(void)setRedEnvelopTextFiter:(NSString*)value{
    [NSUserDefaults.standardUserDefaults setObject:value forKey:cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+(NSArray *)redEnvelopGroupFiter{
    return [NSUserDefaults.standardUserDefaults arrayForKey:cmdString(_cmd)];
}
+(void)setRedEnvelopGroupFiter:(NSArray *)value{
    [NSUserDefaults.standardUserDefaults setObject:value forKey:cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+(BOOL)redEnvelopCatchMe{
    return [NSUserDefaults.standardUserDefaults boolForKey:cmdString(_cmd)];
}
+(void)setRedEnvelopCatchMe:(BOOL)value{
    [NSUserDefaults.standardUserDefaults setBool:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+(BOOL)redEnvelopMultipleCatch{
    return [NSUserDefaults.standardUserDefaults boolForKey:cmdString(_cmd)];
}
+(void)setRedEnvelopMultipleCatch:(BOOL)value{
    [NSUserDefaults.standardUserDefaults setBool:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
    cmdString(_cmd);
}


+(BOOL)hasShowTips{
    return [NSUserDefaults.standardUserDefaults boolForKey:cmdString(_cmd)];
}
+(void)setHasShowTips:(BOOL)value{
    [NSUserDefaults.standardUserDefaults setBool:value forKey: cmdString(_cmd)];
    [NSUserDefaults.standardUserDefaults synchronize];
    cmdString(_cmd);
}

- (void)setBgTaskTimer:(NSTimer *)bgTaskTimer{
    _bgTaskTimer = bgTaskTimer;
}

//程序进入后台处理
- (void)enterBackgroundHandler{
    if(!DKHelperConfig.redEnvelopBackGround){ return; }
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTaskIdentifier];
        self.bgTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    self.bgTaskTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(requestMoreTime) userInfo:nil repeats:YES];
    [self.bgTaskTimer fire];
}

- (void)requestMoreTime{
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 30) {
        [self playBlankAudio];
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskIdentifier];
        self.bgTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskIdentifier];
            self.bgTaskIdentifier = UIBackgroundTaskInvalid;
        }];
    }
}

//播放无声音频
- (void)playBlankAudio{
    [self playAudioForResource:@"blank" ofType:@"caf"];
}

//播放收到红包音频
- (void)playCashReceivedAudio{
    [self playAudioForResource:@"cash_received" ofType:@"caf"];
}

//开始播放音频
- (void)playAudioForResource:(NSString *)resource ofType:(NSString *)ofType{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     withOptions: AVAudioSessionCategoryOptionMixWithOthers
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    NSURL *blankSoundURL = [[NSURL alloc]initWithString:[[NSBundle mainBundle] pathForResource:resource ofType:ofType]];
    if(blankSoundURL){
        self.blankPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:blankSoundURL error:nil];
        [self.blankPlayer play];
    }
}



@end


