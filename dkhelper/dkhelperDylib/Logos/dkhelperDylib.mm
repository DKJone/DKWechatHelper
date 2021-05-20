#line 1 "/Users/zhudekun/mycode/github/DKWechatHelper/dkhelper/dkhelperDylib/Logos/dkhelperDylib.xm"











#import <UIKit/UIKit.h>
#import "DKHelper.h"
#import "DKHelperSettingController.h"


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class CMessageMgr; @class WCTimelineMgr; @class WCRedEnvelopesLogicMgr; @class WCDeviceStepObject; @class NewSettingViewController; @class MicroMessengerAppDelegate; @class MMTipsViewController; @class CGroupMgr; @class MMContext; @class MMServiceCenter; @class WCTableViewNormalCellManager; @class WCOperateFloatView; @class UIViewController; @class WCBizUtil; @class BaseMsgContentViewController; @class VoipCXMgr; @class CMessageWrap; @class CContactMgr;
static id _logos_meta_method$_ungrouped$MMServiceCenter$defaultCenter(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidEnterBackground$)(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *); static void _logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidEnterBackground$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *); static void (*_logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$)(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *); static void _logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *); static _Bool (*_logos_orig$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static _Bool _logos_method$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, id, id); static void (*_logos_orig$_ungrouped$NewSettingViewController$reloadTableData)(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$NewSettingViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$NewSettingViewController$setting(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$CMessageMgr$AddEmoticonMsg$MsgWrap$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, NSString *, CMessageWrap *); static void _logos_method$_ungrouped$CMessageMgr$AddEmoticonMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, NSString *, CMessageWrap *); static void (*_logos_orig$_ungrouped$CMessageMgr$onRevokeMsg$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, CMessageWrap *); static void _logos_method$_ungrouped$CMessageMgr$onRevokeMsg$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, CMessageWrap *); static void (*_logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$)(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, NSString *, CMessageWrap *); static void _logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST, SEL, NSString *, CMessageWrap *); static NSInteger (*_logos_orig$_ungrouped$WCDeviceStepObject$m7StepCount)(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST, SEL); static NSInteger _logos_method$_ungrouped$WCDeviceStepObject$m7StepCount(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST, SEL); static NSInteger (*_logos_orig$_ungrouped$WCDeviceStepObject$hkStepCount)(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST, SEL); static NSInteger _logos_method$_ungrouped$WCDeviceStepObject$hkStepCount(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$)(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST, SEL, HongBaoRes *, HongBaoReq *); static void _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST, SEL, HongBaoRes *, HongBaoReq *); static unsigned int _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$calculateDelaySeconds(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_meta_orig$_ungrouped$VoipCXMgr$isCallkitAvailable)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static BOOL _logos_meta_method$_ungrouped$VoipCXMgr$isCallkitAvailable(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_meta_orig$_ungrouped$VoipCXMgr$isDeviceCallkitAvailable)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static BOOL _logos_meta_method$_ungrouped$VoipCXMgr$isDeviceCallkitAvailable(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$UIViewController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$UIViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST, SEL, BOOL); static NSString * _logos_method$_ungrouped$MMTipsViewController$text(_LOGOS_SELF_TYPE_NORMAL MMTipsViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$WCTimelineMgr$modifyDataItem$notify$)(_LOGOS_SELF_TYPE_NORMAL WCTimelineMgr* _LOGOS_SELF_CONST, SEL, WCDataItem *, BOOL); static void _logos_method$_ungrouped$WCTimelineMgr$modifyDataItem$notify$(_LOGOS_SELF_TYPE_NORMAL WCTimelineMgr* _LOGOS_SELF_CONST, SEL, WCDataItem *, BOOL); static void (*_logos_orig$_ungrouped$CGroupMgr$addChatMemberNeedVerifyMsg$ContactList$)(_LOGOS_SELF_TYPE_NORMAL CGroupMgr* _LOGOS_SELF_CONST, SEL, id, id); static void _logos_method$_ungrouped$CGroupMgr$addChatMemberNeedVerifyMsg$ContactList$(_LOGOS_SELF_TYPE_NORMAL CGroupMgr* _LOGOS_SELF_CONST, SEL, id, id); static void (*_logos_orig$_ungrouped$CGroupMgr$addCreateMsg$ContactList$)(_LOGOS_SELF_TYPE_NORMAL CGroupMgr* _LOGOS_SELF_CONST, SEL, id, id); static void _logos_method$_ungrouped$CGroupMgr$addCreateMsg$ContactList$(_LOGOS_SELF_TYPE_NORMAL CGroupMgr* _LOGOS_SELF_CONST, SEL, id, id); static UIButton * _logos_method$_ungrouped$WCOperateFloatView$m_shareBtn(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST, SEL); static UIImageView * _logos_method$_ungrouped$WCOperateFloatView$m_lineView2(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$WCOperateFloatView$showWithItemData$tipPoint$)(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST, SEL, id, struct CGPoint); static void _logos_method$_ungrouped$WCOperateFloatView$showWithItemData$tipPoint$(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST, SEL, id, struct CGPoint); static void _logos_method$_ungrouped$WCOperateFloatView$forwordTimeLine$(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$BaseMsgContentViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BaseMsgContentViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BaseMsgContentViewController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$BaseMsgContentViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST, SEL, BOOL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MMContext(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MMContext"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CMessageWrap(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CMessageWrap"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CContactMgr(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CContactMgr"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MMServiceCenter(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MMServiceCenter"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WCTableViewNormalCellManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WCTableViewNormalCellManager"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WCBizUtil(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WCBizUtil"); } return _klass; }
#line 16 "/Users/zhudekun/mycode/github/DKWechatHelper/dkhelper/dkhelperDylib/Logos/dkhelperDylib.xm"


static id _logos_meta_method$_ungrouped$MMServiceCenter$defaultCenter(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
     return [[_logos_static_class_lookup$MMContext() currentContext] serviceCenter];
}




static void _logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidEnterBackground$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIApplication * application){
    _logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidEnterBackground$(self, _cmd, application);
    [[DKHelperConfig shared] enterBackgroundHandler];
}

static void _logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIApplication * application){
    _logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$(self, _cmd, application);
    [DKHelperConfig.shared.bgTaskTimer invalidate];
}





static void _logos_method$_ungrouped$NewSettingViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$_ungrouped$NewSettingViewController$reloadTableData(self, _cmd);
    WCTableViewManager *tableViewMgr = MSHookIvar<id>(self, "m_tableViewMgr");
    MMTableView *tableView = [tableViewMgr getTableView];
    WCTableViewNormalCellManager *newCell = [_logos_static_class_lookup$WCTableViewNormalCellManager() normalCellForSel:@selector(setting) target:self title:@"微信小助手"];
    [((WCTableViewSectionManager*)tableViewMgr.sections[0]) addCell: newCell];
    [tableView reloadData];
}


static void _logos_method$_ungrouped$NewSettingViewController$setting(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UIViewController *vc = [[DKHelperSettingController alloc] init];
    [((UIViewController *)self).navigationController PushViewController:vc animated:true];
}




static void _logos_method$_ungrouped$CMessageMgr$AddEmoticonMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * msg, CMessageWrap * msgWrap) {
    if (DKHelperConfig.gamePlugEnable) { 
        if ([msgWrap m_uiMessageType] == 47 && ([msgWrap m_uiGameType] == 2|| [msgWrap m_uiGameType] == 1)) {
            NSString *title = [msgWrap m_uiGameType] == 1 ? @"请选择石头/剪刀/布" : @"请选择点数";
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择"
                                                                           message:title
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];

            NSArray *arr = @[@"剪刀",@"石头",@"布",@"1",@"2",@"3",@"4",@"5",@"6"];
            for (int i = [msgWrap m_uiGameType] == 1 ? 0 : 3; i<([msgWrap m_uiGameType] == 1 ? 3 : 9); i++) {
                UIAlertAction* action1 = [UIAlertAction actionWithTitle:arr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [msgWrap setM_nsEmoticonMD5:[objc_getClass("GameController") getMD5ByGameContent:i+1]];
                    [msgWrap setM_uiGameContent:i+1];
                    _logos_orig$_ungrouped$CMessageMgr$AddEmoticonMsg$MsgWrap$(self, _cmd, msg, msgWrap);
                }];
                [alert addAction:action1];
            }
            UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
            [alert addAction:action2];
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:true completion:nil];

            return;
        }
    }

    _logos_orig$_ungrouped$CMessageMgr$AddEmoticonMsg$MsgWrap$(self, _cmd, msg, msgWrap);
}

static void _logos_method$_ungrouped$CMessageMgr$onRevokeMsg$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CMessageWrap * arg1) {

    if (DKHelperConfig.preventRevoke) {
        NSString *msgContent = arg1.m_nsContent;

        NSString *(^parseParam)(NSString *, NSString *,NSString *) = ^NSString *(NSString *content, NSString *paramBegin,NSString *paramEnd) {
            NSUInteger startIndex = [content rangeOfString:paramBegin].location + paramBegin.length;
            NSUInteger endIndex = [content rangeOfString:paramEnd].location;
            NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
            return [content substringWithRange:range];
        };

        NSString *session = parseParam(msgContent, @"<session>", @"</session>");
        NSString *newmsgid = parseParam(msgContent, @"<newmsgid>", @"</newmsgid>");
        NSString *fromUsrName = parseParam(msgContent, @"<![CDATA[", @"撤回了一条消息");
        CMessageWrap *revokemsg = [self GetMsg:session n64SvrID:[newmsgid integerValue]];

        CContactMgr *contactMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
        CContact *selfContact = [contactMgr getSelfContact];
        NSString *newMsgContent = @"";


        if ([revokemsg.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName]) {
            if (revokemsg.m_uiMessageType == 1) {       
                newMsgContent = [NSString stringWithFormat:@"拦截到你撤回了一条消息：\n %@",revokemsg.m_nsContent];
            } else {
                newMsgContent = @"拦截到你撤回一条消息";
            }
        } else {
            if (revokemsg.m_uiMessageType == 1) {
                newMsgContent = [NSString stringWithFormat:@"拦截到一条 %@撤回消息：\n %@",fromUsrName, revokemsg.m_nsContent];
            } else {
                newMsgContent = [NSString stringWithFormat:@"拦截到一条 %@撤回消息",fromUsrName];
            }
        }

        CMessageWrap *newWrap = ({
            CMessageWrap *msg = [[_logos_static_class_lookup$CMessageWrap() alloc] initWithMsgType:0x2710];
            [msg setM_nsFromUsr:revokemsg.m_nsFromUsr];
            [msg setM_nsToUsr:revokemsg.m_nsToUsr];
            [msg setM_uiStatus:0x4];
            [msg setM_nsContent:newMsgContent];
            [msg setM_uiCreateTime:[arg1 m_uiCreateTime]];

            msg;
        });

        [self AddLocalMsg:session MsgWrap:newWrap fixTime:0x1 NewMsgArriveNotify:0x0];
        return;
    }
    _logos_orig$_ungrouped$CMessageMgr$onRevokeMsg$(self, _cmd, arg1);
}



static void _logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(_LOGOS_SELF_TYPE_NORMAL CMessageMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * msg, CMessageWrap * wrap) {
    _logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$(self, _cmd, msg, wrap);

    switch(wrap.m_uiMessageType) {
        case 49: { 
            CContactMgr *contactManager = [[_logos_static_class_lookup$MMServiceCenter() defaultCenter] getService:[_logos_static_class_lookup$CContactMgr() class]];
            CContact *selfContact = [contactManager getSelfContact];
            BOOL (^isSender)() = ^BOOL() {
                return [wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName];
            };

            if (!DKHelper.shared.checkFriendsEnd && isSender()){
                [self RevokeMsg:wrap.m_nsToUsr MsgWrap:wrap Counter:0];
                NSMutableArray *validArr = DKHelper.shared.validFriends.mutableCopy;
                [validArr addObject:[contactManager getContactByName:wrap.m_nsToUsr]];
                DKHelper.shared.validFriends = validArr.copy;
            }

            
            BOOL (^isRedEnvelopMessage)() = ^BOOL() {
                return [wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound;
            };

            if (isRedEnvelopMessage()) { 
                
                BOOL (^isGroupReceiver)() = ^BOOL() {
                    return [wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound;
                };

                
                BOOL (^isGroupSender)() = ^BOOL() {
                    return isSender() && [wrap.m_nsToUsr rangeOfString:@"chatroom"].location != NSNotFound;
                };

                
                BOOL (^isReceiveSelfRedEnvelop)() = ^BOOL() {
                    return DKHelperConfig.redEnvelopCatchMe;
                };

                
                BOOL (^isGroupInBlackList)() = ^BOOL() {
                    return [DKHelperConfig.redEnvelopGroupFiter containsObject:wrap.m_nsFromUsr];
                };
                
                BOOL (^isContaintKeyWords)() = ^BOOL() {
                    if (!DKHelperConfig.redEnvelopTextFiter.length){return false;}
                    NSString *content = wrap.m_nsContent ;
                    NSRange range1 = [content rangeOfString:@"receivertitle><![CDATA[" options:NSLiteralSearch];
                    NSRange range2 = [content rangeOfString:@"]]></receivertitle>" options:NSLiteralSearch];
                    NSRange range3 = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
                    content = [content substringWithRange:range3];
                    __block BOOL result = false;
                    [[DKHelperConfig.redEnvelopTextFiter componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([content containsString:obj]){
                            result = true;
                        }
                    }];
                    return result;
                };

                
                BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {
                    if (!DKHelperConfig.autoRedEnvelop) { return NO; }
                    if (isGroupInBlackList()) { return NO; }
                    if (isContaintKeyWords()) { return NO; }
                    return isGroupReceiver() ||
                           (isGroupSender() && isReceiveSelfRedEnvelop()) ||
                           (!isGroupReceiver() && DKHelperConfig.personalRedEnvelopEnable);
                };

                NSDictionary *(^parseNativeUrl)(NSString *nativeUrl) = ^(NSString *nativeUrl) {
                    nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                    return [_logos_static_class_lookup$WCBizUtil() dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
                };

                
                void (^queryRedEnvelopesReqeust)(NSDictionary *nativeUrlDict) = ^(NSDictionary *nativeUrlDict) {
                    NSMutableDictionary *params = [@{} mutableCopy];
                    params[@"agreeDuty"] = @"0";
                    params[@"channelId"] = [nativeUrlDict stringForKey:@"channelid"];
                    params[@"inWay"] = @"0";
                    params[@"msgType"] = [nativeUrlDict stringForKey:@"msgtype"];
                    params[@"nativeUrl"] = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                    params[@"sendId"] = [nativeUrlDict stringForKey:@"sendid"];

                    WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
                    [logicMgr ReceiverQueryRedEnvelopesRequest:params];
                };

                
                void (^enqueueParam)(NSDictionary *nativeUrlDict) = ^(NSDictionary *nativeUrlDict) {
                    WeChatRedEnvelopParam *mgrParams = [[WeChatRedEnvelopParam alloc] init];
                    mgrParams.msgType = [nativeUrlDict stringForKey:@"msgtype"];
                    mgrParams.sendId = [nativeUrlDict stringForKey:@"sendid"];
                    mgrParams.channelId = [nativeUrlDict stringForKey:@"channelid"];
                    mgrParams.nickName = [selfContact getContactDisplayName];
                    mgrParams.headImg = [selfContact m_nsHeadImgUrl];
                    mgrParams.nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                    mgrParams.sessionUserName = isGroupSender() ? wrap.m_nsToUsr : wrap.m_nsFromUsr;
                    mgrParams.sign = [nativeUrlDict stringForKey:@"sign"];

                    mgrParams.isGroupSender = isGroupSender();

                    [[WBRedEnvelopParamQueue sharedQueue] enqueue:mgrParams];
                };

                if (shouldReceiveRedEnvelop()) {
                    NSString *nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                    NSDictionary *nativeUrlDict = parseNativeUrl(nativeUrl);
                    queryRedEnvelopesReqeust(nativeUrlDict);
                    enqueueParam(nativeUrlDict);
                }
            }
            break;
        }
        default:
            break;
    }

}





static NSInteger _logos_method$_ungrouped$WCDeviceStepObject$m7StepCount(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSInteger stepCount = _logos_orig$_ungrouped$WCDeviceStepObject$m7StepCount(self, _cmd);
    NSInteger newStepCount = DKHelperConfig.changedSteps;

    return DKHelperConfig.changeSteps ? newStepCount : stepCount;
}

static NSInteger _logos_method$_ungrouped$WCDeviceStepObject$hkStepCount(_LOGOS_SELF_TYPE_NORMAL WCDeviceStepObject* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSInteger stepCount = _logos_orig$_ungrouped$WCDeviceStepObject$hkStepCount(self, _cmd);
    NSInteger newStepCount = DKHelperConfig.changedSteps;

    return DKHelperConfig.changeSteps ? newStepCount : stepCount;
}






static void _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, HongBaoRes * arg1, HongBaoReq * arg2) {

    _logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$(self, _cmd, arg1, arg2);

    
    if (arg1.cgiCmdid != 3) { return; }

    NSString *(^parseRequestSign)() = ^NSString *() {
        NSString *requestString = [[NSString alloc] initWithData:arg2.reqText.buffer encoding:NSUTF8StringEncoding];
        NSDictionary *requestDictionary = [_logos_static_class_lookup$WCBizUtil() dictionaryWithDecodedComponets:requestString separator:@"&"];
        NSString *nativeUrl = [[requestDictionary stringForKey:@"nativeUrl"] stringByRemovingPercentEncoding];
        NSDictionary *nativeUrlDict = [_logos_static_class_lookup$WCBizUtil() dictionaryWithDecodedComponets:nativeUrl separator:@"&"];

        return [nativeUrlDict stringForKey:@"sign"];
    };

    NSDictionary *responseDict = [[[NSString alloc] initWithData:arg1.retText.buffer encoding:NSUTF8StringEncoding] JSONDictionary];

    WeChatRedEnvelopParam *mgrParams = [[WBRedEnvelopParamQueue sharedQueue] dequeue];

    BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {

        
        if (!mgrParams) { return NO; }

        
        if ([responseDict[@"receiveStatus"] integerValue] == 2) { return NO; }

        
        if ([responseDict[@"hbStatus"] integerValue] == 4) { return NO; }

        
        if (!responseDict[@"timingIdentifier"]) { return NO; }

        if (mgrParams.isGroupSender) { 
            return DKHelperConfig.autoRedEnvelop;
        } else {
            return [parseRequestSign() isEqualToString:mgrParams.sign] && DKHelperConfig.autoRedEnvelop;
        }
    };

    if (shouldReceiveRedEnvelop()) {
        mgrParams.timingIdentifier = responseDict[@"timingIdentifier"];

        unsigned int delaySeconds = [self calculateDelaySeconds];
        WBReceiveRedEnvelopOperation *operation = [[WBReceiveRedEnvelopOperation alloc] initWithRedEnvelopParam:mgrParams delay:delaySeconds];

        if (DKHelperConfig.redEnvelopMultipleCatch) {
            [[WBRedEnvelopTaskManager sharedManager] addSerialTask:operation];
        } else {
            [[WBRedEnvelopTaskManager sharedManager] addNormalTask:operation];
        }
    }
}


static unsigned int _logos_method$_ungrouped$WCRedEnvelopesLogicMgr$calculateDelaySeconds(_LOGOS_SELF_TYPE_NORMAL WCRedEnvelopesLogicMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSInteger configDelaySeconds = DKHelperConfig.redEnvelopDelay ;

    if (DKHelperConfig.redEnvelopDelay) {
        unsigned int serialDelaySeconds;
        if ([WBRedEnvelopTaskManager sharedManager].serialQueueIsEmpty) {
            serialDelaySeconds = configDelaySeconds;
        } else {
            serialDelaySeconds = 15;
        }

        return serialDelaySeconds;
    } else {
        return (unsigned int)configDelaySeconds;
    }
}






static BOOL _logos_meta_method$_ungrouped$VoipCXMgr$isCallkitAvailable(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    return DKHelperConfig.callKitEnable;
}
static BOOL _logos_meta_method$_ungrouped$VoipCXMgr$isDeviceCallkitAvailable(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    return DKHelperConfig.callKitEnable;
}




static void _logos_method$_ungrouped$UIViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$_ungrouped$UIViewController$viewWillAppear$(self, _cmd, animated);
    NSLog(@"\n***********************************************\n\t%@ appear\n***********************************************\n",NSStringFromClass([(NSObject*)self class]));
}







static NSString * _logos_method$_ungrouped$MMTipsViewController$text(_LOGOS_SELF_TYPE_NORMAL MMTipsViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    return  [self valueForKeyPath:@"_tipsTextView.text"];
}





static void _logos_method$_ungrouped$WCTimelineMgr$modifyDataItem$notify$(_LOGOS_SELF_TYPE_NORMAL WCTimelineMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, WCDataItem * arg1, BOOL arg2){
    if (!DKHelperConfig.likeCommentEnable){
        _logos_orig$_ungrouped$WCTimelineMgr$modifyDataItem$notify$(self, _cmd, arg1, arg2);return;
    }
    if (arg1.likeFlag){
        arg1.commentUsers = [DKHelper commentWith:arg1];
        arg1.commentCount = (int)arg1.commentUsers.count;
        arg1.likeUsers = DKHelper.commentUsers;
        arg1.likeCount = (int)DKHelper.commentUsers.count;
    }
    _logos_orig$_ungrouped$WCTimelineMgr$modifyDataItem$notify$(self, _cmd, arg1,arg2);
}





static void _logos_method$_ungrouped$CGroupMgr$addChatMemberNeedVerifyMsg$ContactList$(_LOGOS_SELF_TYPE_NORMAL CGroupMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2){
    _logos_orig$_ungrouped$CGroupMgr$addChatMemberNeedVerifyMsg$ContactList$(self, _cmd, arg1,arg2);
    if (!DKHelper.shared.checkFriendsEnd){
        DKHelper.shared.groupContact = arg1;
        DKHelper.shared.notFriends = [arg2 allValues];
        dispatch_group_leave(DKHelper.shared.checkFriendGroup);
    }
}

static void _logos_method$_ungrouped$CGroupMgr$addCreateMsg$ContactList$(_LOGOS_SELF_TYPE_NORMAL CGroupMgr* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2){
    _logos_orig$_ungrouped$CGroupMgr$addCreateMsg$ContactList$(self, _cmd, arg1,arg2);
    if (!DKHelper.shared.checkFriendsEnd){
        DKHelper.shared.groupContact = arg1;
        NSMutableArray *validArr = DKHelper.shared.validFriends.mutableCopy;
        [validArr addObjectsFromArray:arg2];
        DKHelper.shared.validFriends = validArr.copy;
        dispatch_group_leave(DKHelper.shared.checkFriendGroup);
    }
}





static UIButton * _logos_method$_ungrouped$WCOperateFloatView$m_shareBtn(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    static char m_shareBtnKey;
    UIButton * btn = objc_getAssociatedObject(self, &m_shareBtnKey);
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@" 转发" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(forwordTimeLine:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:self.m_likeBtn.currentTitleColor forState:0];
        btn.titleLabel.font = self.m_likeBtn.titleLabel.font;
        [self.m_likeBtn.superview addSubview:btn];
        NSString *base64Str = @"iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAABf0lEQVQ4T62UvyuFYRTHP9/JJimjMpgYTBIDd5XEIIlB9x+Q5U5+xEIZLDabUoQsNtS9G5MyXImk3EHK/3B09Ly31/X+cG9Onek5z+c5z/l+n0f8c+ivPDMrAAVJG1l7mgWWgc0saCvAKnCWBm0F2A+cpEGbBkqSmfWlQXOBZjbgYgCDwIIDXZQ0aCrQzOaAZWAIuAEugaqk00jlJOgvYChaA6aAFeBY0nuaVRqhP4CxxQ9gVZJ3lhs/oAnt1ySN51JiBWa2FMYzW+/QzNwK3cCkpM+/As1sAjgAZiRVIsWKwHZ4Wo9NwFz5W2Ba0oXvi4Cu4L2kUrBEOzAMjIXsAjw7YrbpBZ6BeUlHURNu0h7gFXC/vQRlveM34AF4AipAG1AOxu4Me0qS9uM3cqB7bRS4A3y4556SvOt6hN8mAnrtoaTdxvE40H+QEcBP2pFUS5phBASu3eiS1pPqIuCWpKssMWLAPUl+k8T4fuiSfFaZEYBFSYtZhbmfQ95Bjetfmweww0YOfToAAAAASUVORK5CYII=";
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *image = [UIImage imageWithData:imageData ];
        [btn setImage:image forState:0];
        [btn setTintColor:self.m_likeBtn.tintColor];
        objc_setAssociatedObject(self, &m_shareBtnKey, btn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }
    return btn;
}


static UIImageView * _logos_method$_ungrouped$WCOperateFloatView$m_lineView2(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    static char m_lineView2Key;
    UIImageView * imageView = objc_getAssociatedObject(self, &m_lineView2Key);
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithImage:MSHookIvar<UIImageView *>(self, "m_lineView").image];
        [self.m_likeBtn.superview addSubview: imageView];
        objc_setAssociatedObject(self, &m_lineView2Key, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageView;
}

static void _logos_method$_ungrouped$WCOperateFloatView$showWithItemData$tipPoint$(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, struct CGPoint arg2){
    _logos_orig$_ungrouped$WCOperateFloatView$showWithItemData$tipPoint$(self, _cmd, arg1,arg2);
    if (DKHelperConfig.timeLineForwardEnable){
        self.frame = CGRectOffset(CGRectInset(self.frame, self.frame.size.width / -4, 0),self.frame.size.width / -4,0);
        self.m_shareBtn.frame = CGRectOffset(self.m_likeBtn.frame, self.m_likeBtn.frame.size.width * 2, 0);
        self.m_lineView2.frame = CGRectOffset(MSHookIvar<UIImageView *>(self, "m_lineView").frame, [self buttonWidth:self.m_likeBtn], 0);
    }
}


static void _logos_method$_ungrouped$WCOperateFloatView$forwordTimeLine$(_LOGOS_SELF_TYPE_NORMAL WCOperateFloatView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    WCForwardViewController *forwardVC = [[objc_getClass("WCForwardViewController") alloc] initWithDataItem:self.m_item];
    [self.navigationController pushViewController:forwardVC animated:true];
}




@interface BaseMsgContentViewController:UIViewController
- (id)getMsgTableView;
- (id)getParentTableView;
@end


static void _logos_method$_ungrouped$BaseMsgContentViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$_ungrouped$BaseMsgContentViewController$viewDidLoad(self, _cmd);
}

static void _logos_method$_ungrouped$BaseMsgContentViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL BaseMsgContentViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$_ungrouped$BaseMsgContentViewController$viewWillAppear$(self, _cmd, animated);
    UIView * annimView = [self.view viewWithTag:66666];
    if (!DKHelperConfig.dkChatBgEnable){
        [annimView removeFromSuperview];
        [annimView stopHWDMP4];
        return;
    }
    if (annimView == nil){
        annimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width *16/9)];
        annimView.tag = 66666;
        annimView.backgroundColor = UIColor.clearColor;
        [self.view insertSubview:annimView belowSubview:[self getMsgTableView]];
    }

    annimView.center = self.view.center;
    NSString *animaName = DKLaunchHelper.animaNames[DKHelperConfig.dkChatBGIndex.intValue][@"name"];
    NSString* path = [NSBundle.mainBundle pathForResource:[NSString stringWithFormat:@"%@Vap", animaName] ofType:@"mp4"];
    [annimView playHWDMP4:path repeatCount:-1 delegate:nil];
    
}



@interface MicroMessengerAppDelegate
+ (id)GlobalInstance;
@property(retain, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIWindow *launchWindow;
@end


__attribute__((used)) static UIWindow * _logos_method$_ungrouped$MicroMessengerAppDelegate$launchWindow(MicroMessengerAppDelegate * __unused self, SEL __unused _cmd) { return (UIWindow *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MicroMessengerAppDelegate$launchWindow); }; __attribute__((used)) static void _logos_method$_ungrouped$MicroMessengerAppDelegate$setLaunchWindow(MicroMessengerAppDelegate * __unused self, SEL __unused _cmd, UIWindow * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MicroMessengerAppDelegate$launchWindow, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

static _Bool _logos_method$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2){
    if (!DKHelperConfig.dkLaunchEnable){return _logos_orig$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, arg1, arg2); }
    BOOL end = _logos_orig$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$(self, _cmd, arg1, arg2);
    DKLaunchViewController * launchVC = [[DKLaunchViewController alloc] init];
    UIWindow *launchWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.launchWindow = launchWindow;
    launchWindow.windowLevel = UIWindowLevelAlert + 1;
    launchWindow.rootViewController = launchVC;
    [launchWindow makeKeyAndVisible];
    return end;
    
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$MMServiceCenter = objc_getClass("MMServiceCenter"); Class _logos_metaclass$_ungrouped$MMServiceCenter = object_getClass(_logos_class$_ungrouped$MMServiceCenter); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$MMServiceCenter, @selector(defaultCenter), (IMP)&_logos_meta_method$_ungrouped$MMServiceCenter$defaultCenter, _typeEncoding); }Class _logos_class$_ungrouped$MicroMessengerAppDelegate = objc_getClass("MicroMessengerAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$MicroMessengerAppDelegate, @selector(applicationDidEnterBackground:), (IMP)&_logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidEnterBackground$, (IMP*)&_logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidEnterBackground$);MSHookMessageEx(_logos_class$_ungrouped$MicroMessengerAppDelegate, @selector(applicationDidBecomeActive:), (IMP)&_logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$, (IMP*)&_logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$);MSHookMessageEx(_logos_class$_ungrouped$MicroMessengerAppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$, (IMP*)&_logos_orig$_ungrouped$MicroMessengerAppDelegate$application$didFinishLaunchingWithOptions$);{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIWindow *)); class_addMethod(_logos_class$_ungrouped$MicroMessengerAppDelegate, @selector(launchWindow), (IMP)&_logos_method$_ungrouped$MicroMessengerAppDelegate$launchWindow, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIWindow *)); class_addMethod(_logos_class$_ungrouped$MicroMessengerAppDelegate, @selector(setLaunchWindow:), (IMP)&_logos_method$_ungrouped$MicroMessengerAppDelegate$setLaunchWindow, _typeEncoding); } Class _logos_class$_ungrouped$NewSettingViewController = objc_getClass("NewSettingViewController"); MSHookMessageEx(_logos_class$_ungrouped$NewSettingViewController, @selector(reloadTableData), (IMP)&_logos_method$_ungrouped$NewSettingViewController$reloadTableData, (IMP*)&_logos_orig$_ungrouped$NewSettingViewController$reloadTableData);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$NewSettingViewController, @selector(setting), (IMP)&_logos_method$_ungrouped$NewSettingViewController$setting, _typeEncoding); }Class _logos_class$_ungrouped$CMessageMgr = objc_getClass("CMessageMgr"); MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(AddEmoticonMsg:MsgWrap:), (IMP)&_logos_method$_ungrouped$CMessageMgr$AddEmoticonMsg$MsgWrap$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$AddEmoticonMsg$MsgWrap$);MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(onRevokeMsg:), (IMP)&_logos_method$_ungrouped$CMessageMgr$onRevokeMsg$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$onRevokeMsg$);MSHookMessageEx(_logos_class$_ungrouped$CMessageMgr, @selector(AsyncOnAddMsg:MsgWrap:), (IMP)&_logos_method$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$, (IMP*)&_logos_orig$_ungrouped$CMessageMgr$AsyncOnAddMsg$MsgWrap$);Class _logos_class$_ungrouped$WCDeviceStepObject = objc_getClass("WCDeviceStepObject"); MSHookMessageEx(_logos_class$_ungrouped$WCDeviceStepObject, @selector(m7StepCount), (IMP)&_logos_method$_ungrouped$WCDeviceStepObject$m7StepCount, (IMP*)&_logos_orig$_ungrouped$WCDeviceStepObject$m7StepCount);MSHookMessageEx(_logos_class$_ungrouped$WCDeviceStepObject, @selector(hkStepCount), (IMP)&_logos_method$_ungrouped$WCDeviceStepObject$hkStepCount, (IMP*)&_logos_orig$_ungrouped$WCDeviceStepObject$hkStepCount);Class _logos_class$_ungrouped$WCRedEnvelopesLogicMgr = objc_getClass("WCRedEnvelopesLogicMgr"); MSHookMessageEx(_logos_class$_ungrouped$WCRedEnvelopesLogicMgr, @selector(OnWCToHongbaoCommonResponse:Request:), (IMP)&_logos_method$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$, (IMP*)&_logos_orig$_ungrouped$WCRedEnvelopesLogicMgr$OnWCToHongbaoCommonResponse$Request$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'I'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$WCRedEnvelopesLogicMgr, @selector(calculateDelaySeconds), (IMP)&_logos_method$_ungrouped$WCRedEnvelopesLogicMgr$calculateDelaySeconds, _typeEncoding); }Class _logos_class$_ungrouped$VoipCXMgr = objc_getClass("VoipCXMgr"); Class _logos_metaclass$_ungrouped$VoipCXMgr = object_getClass(_logos_class$_ungrouped$VoipCXMgr); MSHookMessageEx(_logos_metaclass$_ungrouped$VoipCXMgr, @selector(isCallkitAvailable), (IMP)&_logos_meta_method$_ungrouped$VoipCXMgr$isCallkitAvailable, (IMP*)&_logos_meta_orig$_ungrouped$VoipCXMgr$isCallkitAvailable);MSHookMessageEx(_logos_metaclass$_ungrouped$VoipCXMgr, @selector(isDeviceCallkitAvailable), (IMP)&_logos_meta_method$_ungrouped$VoipCXMgr$isDeviceCallkitAvailable, (IMP*)&_logos_meta_orig$_ungrouped$VoipCXMgr$isDeviceCallkitAvailable);Class _logos_class$_ungrouped$UIViewController = objc_getClass("UIViewController"); MSHookMessageEx(_logos_class$_ungrouped$UIViewController, @selector(viewWillAppear:), (IMP)&_logos_method$_ungrouped$UIViewController$viewWillAppear$, (IMP*)&_logos_orig$_ungrouped$UIViewController$viewWillAppear$);Class _logos_class$_ungrouped$MMTipsViewController = objc_getClass("MMTipsViewController"); { char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MMTipsViewController, @selector(text), (IMP)&_logos_method$_ungrouped$MMTipsViewController$text, _typeEncoding); }Class _logos_class$_ungrouped$WCTimelineMgr = objc_getClass("WCTimelineMgr"); MSHookMessageEx(_logos_class$_ungrouped$WCTimelineMgr, @selector(modifyDataItem:notify:), (IMP)&_logos_method$_ungrouped$WCTimelineMgr$modifyDataItem$notify$, (IMP*)&_logos_orig$_ungrouped$WCTimelineMgr$modifyDataItem$notify$);Class _logos_class$_ungrouped$CGroupMgr = objc_getClass("CGroupMgr"); MSHookMessageEx(_logos_class$_ungrouped$CGroupMgr, @selector(addChatMemberNeedVerifyMsg:ContactList:), (IMP)&_logos_method$_ungrouped$CGroupMgr$addChatMemberNeedVerifyMsg$ContactList$, (IMP*)&_logos_orig$_ungrouped$CGroupMgr$addChatMemberNeedVerifyMsg$ContactList$);MSHookMessageEx(_logos_class$_ungrouped$CGroupMgr, @selector(addCreateMsg:ContactList:), (IMP)&_logos_method$_ungrouped$CGroupMgr$addCreateMsg$ContactList$, (IMP*)&_logos_orig$_ungrouped$CGroupMgr$addCreateMsg$ContactList$);Class _logos_class$_ungrouped$WCOperateFloatView = objc_getClass("WCOperateFloatView"); { char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$WCOperateFloatView, @selector(m_shareBtn), (IMP)&_logos_method$_ungrouped$WCOperateFloatView$m_shareBtn, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIImageView *), strlen(@encode(UIImageView *))); i += strlen(@encode(UIImageView *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$WCOperateFloatView, @selector(m_lineView2), (IMP)&_logos_method$_ungrouped$WCOperateFloatView$m_lineView2, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$WCOperateFloatView, @selector(showWithItemData:tipPoint:), (IMP)&_logos_method$_ungrouped$WCOperateFloatView$showWithItemData$tipPoint$, (IMP*)&_logos_orig$_ungrouped$WCOperateFloatView$showWithItemData$tipPoint$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$WCOperateFloatView, @selector(forwordTimeLine:), (IMP)&_logos_method$_ungrouped$WCOperateFloatView$forwordTimeLine$, _typeEncoding); }Class _logos_class$_ungrouped$BaseMsgContentViewController = objc_getClass("BaseMsgContentViewController"); MSHookMessageEx(_logos_class$_ungrouped$BaseMsgContentViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$BaseMsgContentViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$BaseMsgContentViewController$viewDidLoad);MSHookMessageEx(_logos_class$_ungrouped$BaseMsgContentViewController, @selector(viewWillAppear:), (IMP)&_logos_method$_ungrouped$BaseMsgContentViewController$viewWillAppear$, (IMP*)&_logos_orig$_ungrouped$BaseMsgContentViewController$viewWillAppear$);} }
#line 539 "/Users/zhudekun/mycode/github/DKWechatHelper/dkhelper/dkhelperDylib/Logos/dkhelperDylib.xm"
