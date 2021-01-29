//
//  DKHelperConfig.h
//  testHookDylib
//
// Created by 朱德坤 on 2019/1/22.
// Copyright © 2019 DKJone. All rights reserved.
//
//                    ██████╗ ██╗  ██╗     ██╗ ██████╗ ███╗   ██╗███████╗
//                    ██╔══██╗██║ ██╔╝     ██║██╔═══██╗████╗  ██║██╔════╝
//                    ██║  ██║█████╔╝      ██║██║   ██║██╔██╗ ██║█████╗
//                    ██║  ██║██╔═██╗ ██   ██║██║   ██║██║╚██╗██║██╔══╝
//                    ██████╔╝██║  ██╗╚█████╔╝╚██████╔╝██║ ╚████║███████╗
//                    ╚═════╝ ╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKHelperConfig : NSObject

@property (nonatomic, strong) NSTimer *bgTaskTimer; //后台任务定时器

+ (instancetype)shared;

/// 程序进入后台处理
- (void)enterBackgroundHandler;

/// 自动抢红包
+(BOOL)autoRedEnvelop;
+(void)setAutoRedEnvelop:(BOOL)value;

/// 消息防撤回
+(BOOL)preventRevoke;
+(void)setPreventRevoke:(BOOL)value;

/// 修改步数
+(BOOL)changeSteps;
+(void)setChangeSteps:(BOOL)value;

/// 运动步数
+(NSInteger)changedSteps;
+(void)setChangedSteps:(NSInteger)value;

/// 小游戏作弊
+(BOOL)gamePlugEnable;
+(void)setGamePlugEnable:(BOOL)value;

/// 后台抢红包
+(BOOL)redEnvelopBackGround;
+(void)setRedEnvelopBackGround:(BOOL)value;

/// 抢红包延迟
+(NSInteger)redEnvelopDelay;
+(void)setRedEnvelopDelay:(NSInteger)value;

/// 抢红包关键词过滤
+(NSString *)redEnvelopTextFiter;
+(void)setRedEnvelopTextFiter:(NSString*)value;

/// 抢红包群组过滤
+(NSArray *)redEnvelopGroupFiter;
+(void)setRedEnvelopGroupFiter:(NSArray *)value;

/// 抢自己的红包
+(BOOL)redEnvelopCatchMe;
+(void)setRedEnvelopCatchMe:(BOOL)value;

/// 同事抢多个红包
+(BOOL)redEnvelopMultipleCatch;
+(void)setRedEnvelopMultipleCatch:(BOOL)value;

+(BOOL)hasShowTips;
+(void)setHasShowTips:(BOOL)value;

/// 启用callkit
+(BOOL)callKitEnable;
+(void)setCallKitEnable:(BOOL)value;
/// 启用朋友圈转发
+(BOOL)timeLineForwardEnable;
+(void)setTimeLineForwardEnable:(BOOL)value;

/// 启用积攒助手
+(BOOL)likeCommentEnable;
+(void)setLikeCommentEnable:(BOOL)value;

/// 赞的数量
+(NSNumber *)likeCount;
+(void)setLikeCount:(NSNumber *)value;

/// 评论的数量
+(NSNumber *)commentCount;
+(void)setCommentCount:(NSNumber *)value;

/// 评论
+(NSString *)comments;
+(void)setComments:(NSString *)value;


/// 抢个人红包
+(BOOL)personalRedEnvelopEnable;
+(void)setPersonalRedEnvelopEnable:(BOOL)value;

/// 清理好友
+(BOOL)cleanFriendsEnable;
+(void)setCleanFriendsEnable:(BOOL)value;

/// 启用动态启动图
+(BOOL)dkLaunchEnable;
+(void)setDkLaunchEnable:(BOOL)value;

/// 启用动态聊天背景
+(BOOL)dkChatBgEnable;
+(void)setDkChatBgEnable:(BOOL)value;


/// 启动图index
+(NSNumber *)dkLaunchIndex;
+(void)setDkLaunchIndex:(NSNumber *)value;

/// 聊天背景index
+(NSNumber *)dkChatBGIndex;
+(void)setDkChatBGIndex:(NSNumber *)value;


@end



NS_ASSUME_NONNULL_END
