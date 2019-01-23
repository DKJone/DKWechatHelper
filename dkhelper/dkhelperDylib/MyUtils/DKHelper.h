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

//MARK: - quick objc finds
#define FUiUtil objc_getClass("UiUtil")
#define FMMUICommonUtil objc_getClass("MMUICommonUtil")
#define FWCTableViewCellManager objc_getClass("WCTableViewNormalCellManager")


typedef void(^BtnBlock)(UIButton *sender);

NS_ASSUME_NONNULL_BEGIN

@interface DKHelper : NSObject

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
NS_ASSUME_NONNULL_END
