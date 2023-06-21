//
//  DKHelper.h
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/21.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import <Foundation/Foundation.h>

//MARK: - wechat quick imports
#import "UiUtil.h"
#import "WechatHeaders.h"
#import <objc/objc-runtime.h>
#import "WCUIAlertView.h"
#import "DKHelperConfig.h"
#import <UIKit/UIKit.h>
#import "NSArray+Utils.h"
#import "DKLaunchHelper.h"
#import "DKLaunchViewController.h"
#import <CoreMotion/CoreMotion.h>
//MARK: - quick objc finds
#define FUiUtil objc_getClass("UiUtil")
#define FMMUICommonUtil objc_getClass("MMUICommonUtil")
#define FWCTableViewCellManager objc_getClass("WCTableViewNormalCellManager")
#define WK(object) autoreleasepool{} __weak typeof(object) weak##object = object
#define ST(object) autoreleasepool{} __strong typeof(object) object = weak##object
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf) __strong __typeof(weakSelf)strongSelf = weakSelf;
#define isDKForDeb (YES)
#define documentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define libPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
#define vapPath [libPath stringByAppendingPathComponent:@"/dkjone/vapFiles"]

typedef void(^BtnBlock)(UIButton *sender);


@interface DKHelper : NSObject

/// 好友关系是否检测完毕
@property (nonatomic,assign)BOOL checkFriendsEnd;
/// 已将你删除的好友
@property (nonatomic,strong)NSMutableArray<CContact *> *notFriends;
/// 账号被封的好友
@property (nonatomic,strong)NSMutableArray<CContact *> *invalidFriends;
/// 相互好友
@property (nonatomic,strong)NSMutableArray<CContact *> *validFriends;

@property (nonatomic,copy)NSString* groupURL;

@property (nonatomic,copy)NSDictionary *currentCheckResult;

@property (nonatomic ,strong) dispatch_semaphore_t friendCheckSem;

+(void)checkFriends;
+(BOOL)vapFileExit;
+ (instancetype)shared ;
/// 所有好友(不包含公众号)
+ (NSArray<CContact*> *)allFriends;

/// 朋友圈点赞用户集合
+ (NSMutableArray<WCUserComment *>*)commentUsers;

/// 朋友圈评论
+ (NSMutableArray<WCUserComment *>*)commentWith:(WCDataItem *) origItem;

+ (UIBarButtonItem *)leftNavigationItem;

+ (UINavigationController *)navigationContrioller;

+ (UIColor *)backgroundColor;

+ (CGRect)viewFrame;

+ (WCTableViewManager *)tableManageWithViewFrame;

+ (WCTableViewSectionManager *) sectionManage;

+ (WCTableViewNormalCellManager *)cellWithSel:(SEL)sel target:(id)target title:(NSString *)title;
+ (WCTableViewNormalCellManager *)cellWithSel:(SEL)sel target:(id)target title:(NSString *)title rightValue:(NSString *)rightValue accessoryType:(long long) acctype;
+ (WCTableViewNormalCellManager *)switchCellWithSel:(SEL)sel target:(id)target title:(NSString *)title switchOn:(BOOL)switchOn;
+ (WCUIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)msg btnTitle:(NSString *)btnTitle handler:(BtnBlock)handler;
+ (WCUIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)msg btnTitle:(NSString *)btn1 handler:(BtnBlock)handler1 btnTitle:(NSString *)btn2 handler:(BtnBlock)handler2;
+ (void)sendMsg:(NSString *)msg toContactUsrName:(NSString *)userName;
+ (void)sendMsg:(NSString *)msg toContactUsrName:(NSString *)userName uiMsgType:(int)type;
+(CMAccelerometerHandler)startAccelerometerUpdatesToQueue:(id)queue withHandler:(CMAccelerometerHandler )handle;

+ (void)Log:(NSString*)msg;
@end

@interface WeChatRedEnvelopParam : NSObject
- (NSDictionary *)toParams;
@property (strong, nonatomic) NSString *msgType;
@property (strong, nonatomic) NSString *sendId;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *headImg;
@property (strong, nonatomic) NSString *nativeUrl;
@property (strong, nonatomic) NSString *sessionUserName;
@property (strong, nonatomic) NSString *sign;
@property (strong, nonatomic) NSString *timingIdentifier;

@property (assign, nonatomic) BOOL isGroupSender;

@end


@interface WBRedEnvelopParamQueue : NSObject
+ (instancetype)sharedQueue;
- (void)enqueue:(WeChatRedEnvelopParam *)param;
- (WeChatRedEnvelopParam *)dequeue;
- (WeChatRedEnvelopParam *)peek;
- (BOOL)isEmpty;

@end

@class WeChatRedEnvelopParam;
@interface WBReceiveRedEnvelopOperation : NSOperation

- (instancetype)initWithRedEnvelopParam:(WeChatRedEnvelopParam *)param delay:(unsigned int)delaySeconds;

@end

@interface WBRedEnvelopTaskManager : NSObject

+ (instancetype)sharedManager;

- (void)addNormalTask:(WBReceiveRedEnvelopOperation *)task;
- (void)addSerialTask:(WBReceiveRedEnvelopOperation *)task;

- (BOOL)serialQueueIsEmpty;

@end


