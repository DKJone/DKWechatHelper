//
//  DKHelperConfig.h
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/22.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKHelperConfig : NSObject

@property (nonatomic, strong) NSTimer *bgTaskTimer; //后台任务定时器

+ (instancetype)shared;

//程序进入后台处理
- (void)enterBackgroundHandler;


+(BOOL)autoRedEnvelop;
+(void)setAutoRedEnvelop:(BOOL)value;

+(BOOL)preventRevoke;
+(void)setPreventRevoke:(BOOL)value;

+(BOOL)changeSteps;
+(void)setChangeSteps:(BOOL)value;
+(NSInteger)changedSteps;
+(void)setChangedSteps:(NSInteger)value;

+(BOOL)gamePlugEnable;
+(void)setGamePlugEnable:(BOOL)value;

+(BOOL)redEnvelopBackGround;
+(void)setRedEnvelopBackGround:(BOOL)value;

+(NSInteger)redEnvelopDelay;
+(void)setRedEnvelopDelay:(NSInteger)value;

+(NSString *)redEnvelopTextFiter;
+(void)setRedEnvelopTextFiter:(NSString*)value;

+(NSArray *)redEnvelopGroupFiter;
+(void)setRedEnvelopGroupFiter:(NSArray *)value;

+(BOOL)redEnvelopCatchMe;
+(void)setRedEnvelopCatchMe:(BOOL)value;

+(BOOL)redEnvelopMultipleCatch;
+(void)setRedEnvelopMultipleCatch:(BOOL)value;

+(BOOL)hasShowTips;
+(void)setHasShowTips:(BOOL)value;
@end

NS_ASSUME_NONNULL_END
