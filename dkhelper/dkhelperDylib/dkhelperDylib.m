//
//  dkhelperDylib.m
//  dkhelperDylib
//
//  Created by 朱德坤 on 2019/1/23.
//  Copyright (c) 2019 DKJone. All rights reserved.
//

#import "dkhelperDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>


//MARK: - 请求数据伪装

CHDeclareClass(ASIdentifierManager)

//广告标识符伪装
CHMethod0(NSUUID *, ASIdentifierManager, advertisingIdentifier)
{
    NSUUID *advertisingIdentifier;
    NSString *key = @"idfa";

    NSString *idfa = [[NSUserDefaults standardUserDefaults] stringForKey:key];

    if (idfa && idfa.length)
    {
        advertisingIdentifier = [[NSUUID alloc] initWithUUIDString:idfa];
    }
    else
    {
        advertisingIdentifier = [NSUUID UUID];

        [[NSUserDefaults standardUserDefaults] setObject:advertisingIdentifier.UUIDString forKey:key];
    }

    return advertisingIdentifier;
}

@class BaseAuthReqInfo, BaseRequest, ManualAuthAesReqData;

CHDeclareClass(ManualAuthAesReqData);


//bundleId 伪装(待完善)
CHMethod1(void, ManualAuthAesReqData, setBundleId, NSString *, bundleId)
{
    NSLog(@"======-获取请求时验证数据-========");
    if ([bundleId isEqualToString:[NSBundle mainBundle].bundleIdentifier])
    {
        bundleId = @"com.tencent.xin";
    }

    CHSuper1(ManualAuthAesReqData, setBundleId, bundleId);
}

//clientSeqId 伪装
CHMethod1(void, ManualAuthAesReqData, setClientSeqId, NSString *, clientSeqId)
{
    NSString *key = @"clientSeqId";
    NSString *clientSeqId_fist = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (!clientSeqId_fist || clientSeqId_fist.length == 0)
    {
        clientSeqId_fist = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:clientSeqId_fist forKey:key];
    }

    NSString *newClientSeqId;

    if ([clientSeqId containsString:@"-"])
    {
        NSRange range = [clientSeqId rangeOfString:@"-"];
        NSString *clientSeqId_last = [clientSeqId substringFromIndex:range.location];

        newClientSeqId = [NSString stringWithFormat:@"%@%@", clientSeqId_fist, clientSeqId_last];
    }
    else
    {
        newClientSeqId = clientSeqId_fist;
    }

    CHSuper1(ManualAuthAesReqData, setClientSeqId, newClientSeqId);
}

//deviceName 伪装
CHMethod1(void, ManualAuthAesReqData, setDeviceName, NSString *, deviceName)
{
    //设置为默认名称
    deviceName = @"iPhone";

    CHSuper1(ManualAuthAesReqData, setDeviceName, deviceName);
}

//过日志记录
@class MMCrashReportExtLogMgr;

CHDeclareClass(MMCrashReportExtLogMgr);

CHMethod2(void, MMCrashReportExtLogMgr, addLogInfo, int *, arg1, withMessage, const char *, arg2)
{
    return;
}

//过越狱检测
@class JailBreakHelper;

CHDeclareClass(JailBreakHelper);

CHMethod0(BOOL, JailBreakHelper, HasInstallJailbreakPluginInvalidIAPPurchase)
{
    return NO;
}

CHMethod1(BOOL, JailBreakHelper, HasInstallJailbreakPlugin, id, arg1)
{
    return NO;
}

CHMethod0(BOOL, JailBreakHelper, IsJailBreak)
{
    return NO;
}

//所有被hook的类和函数放在这里的构造函数中
CHConstructor
{
    @autoreleasepool
    {
        CHLoadLateClass(ASIdentifierManager);
        CHHook0(ASIdentifierManager, advertisingIdentifier);

        CHLoadLateClass(ManualAuthAesReqData);
        CHHook1(ManualAuthAesReqData, setBundleId);
        CHHook1(ManualAuthAesReqData, setClientSeqId);
        CHHook1(ManualAuthAesReqData, setDeviceName);

        CHLoadLateClass(MMCrashReportExtLogMgr);
        CHHook2(MMCrashReportExtLogMgr, addLogInfo, withMessage);

        CHLoadLateClass(JailBreakHelper);
        CHHook0(JailBreakHelper, HasInstallJailbreakPluginInvalidIAPPurchase);
        CHHook1(JailBreakHelper, HasInstallJailbreakPlugin);
        CHHook0(JailBreakHelper, IsJailBreak);




    }
}
