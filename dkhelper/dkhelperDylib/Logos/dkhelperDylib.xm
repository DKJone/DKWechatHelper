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
// 更新微信版本删除dkhelper/info.plist 重新运行版本号就会更新
#import <UIKit/UIKit.h>
#import "DKHelper.h"
#import "DKHelperSettingController.h"

%hook MMServiceCenter
%new
+ (id)defaultCenter{
     return [[%c(MMContext) currentContext] serviceCenter];
}
%end

%hook MicroMessengerAppDelegate

- (void)applicationDidEnterBackground:(UIApplication *)application{
    %orig;
    [[DKHelperConfig shared] enterBackgroundHandler];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    %orig;
    [DKHelperConfig.shared.bgTaskTimer invalidate];
}

%end


%hook NewSettingViewController
- (void)reloadTableData{
    %orig;
    WCTableViewManager *tableViewMgr = MSHookIvar<id>(self, "m_tableViewMgr");
    MMTableView *tableView = [tableViewMgr getTableView];
    WCTableViewNormalCellManager *newCell = [%c(WCTableViewNormalCellManager) normalCellForSel:@selector(setting) target:self title:@"微信小助手"];
    [((WCTableViewSectionManager*)tableViewMgr.sections[0]) addCell: newCell];
    [tableView reloadData];
}

%new
- (void)setting {
    UIViewController *vc = [[DKHelperSettingController alloc] init];
    [((UIViewController *)self).navigationController PushViewController:vc animated:true];
}

%end

%hook CMessageMgr
- (void)AddEmoticonMsg:(NSString *)msg MsgWrap:(CMessageWrap *)msgWrap {
    if (DKHelperConfig.gamePlugEnable) { // 是否开启游戏作弊
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
                    %orig(msg, msgWrap);
                }];
                [alert addAction:action1];
            }
            UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
            [alert addAction:action2];
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:true completion:nil];

            return;
        }
    }

    %orig(msg, msgWrap);
}

- (void)onRevokeMsg:(CMessageWrap *)arg1 {

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
            if (revokemsg.m_uiMessageType == 1) {       // 判断是否为文本消息
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
            CMessageWrap *msg = [[%c(CMessageWrap) alloc] initWithMsgType:0x2710];
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
    %orig;
}



- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(CMessageWrap *)wrap {
    %orig;

    switch(wrap.m_uiMessageType) {
        case 49: { // AppNode
            CContactMgr *contactManager = [[%c(MMServiceCenter) defaultCenter] getService:[%c(CContactMgr) class]];
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

            /** 是否为红包消息 */
            BOOL (^isRedEnvelopMessage)() = ^BOOL() {
                return [wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound;
            };

            if (isRedEnvelopMessage()) { // 红包
                /** 是否别人在群聊中发消息 */
                BOOL (^isGroupReceiver)() = ^BOOL() {
                    return [wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound;
                };

                /** 是否自己在群聊中发消息 */
                BOOL (^isGroupSender)() = ^BOOL() {
                    return isSender() && [wrap.m_nsToUsr rangeOfString:@"chatroom"].location != NSNotFound;
                };

                /** 是否抢自己发的红包 */
                BOOL (^isReceiveSelfRedEnvelop)() = ^BOOL() {
                    return DKHelperConfig.redEnvelopCatchMe;
                };

                /** 是否在黑名单中 */
                BOOL (^isGroupInBlackList)() = ^BOOL() {
                    return [DKHelperConfig.redEnvelopGroupFiter containsObject:wrap.m_nsFromUsr];
                };
                /** 是否包含关键字 */
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

                /** 是否自动抢红包 */
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
                    return [%c(WCBizUtil) dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
                };

                /** 获取服务端验证参数 */
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

                /** 储存参数 */
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

%end


%hook WCDeviceStepObject
-(NSInteger)m7StepCount {
    NSInteger stepCount = %orig;
    NSInteger newStepCount = DKHelperConfig.changedSteps;

    return DKHelperConfig.changeSteps ? newStepCount : stepCount;
}

-(NSInteger)hkStepCount {
    NSInteger stepCount = %orig;
    NSInteger newStepCount = DKHelperConfig.changedSteps;

    return DKHelperConfig.changeSteps ? newStepCount : stepCount;
}

%end


%hook WCRedEnvelopesLogicMgr

- (void)OnWCToHongbaoCommonResponse:(HongBaoRes *)arg1 Request:(HongBaoReq *)arg2 {

    %orig;

    // 非参数查询请求
    if (arg1.cgiCmdid != 3) { return; }

    NSString *(^parseRequestSign)() = ^NSString *() {
        NSString *requestString = [[NSString alloc] initWithData:arg2.reqText.buffer encoding:NSUTF8StringEncoding];
        NSDictionary *requestDictionary = [%c(WCBizUtil) dictionaryWithDecodedComponets:requestString separator:@"&"];
        NSString *nativeUrl = [[requestDictionary stringForKey:@"nativeUrl"] stringByRemovingPercentEncoding];
        NSDictionary *nativeUrlDict = [%c(WCBizUtil) dictionaryWithDecodedComponets:nativeUrl separator:@"&"];

        return [nativeUrlDict stringForKey:@"sign"];
    };

    NSDictionary *responseDict = [[[NSString alloc] initWithData:arg1.retText.buffer encoding:NSUTF8StringEncoding] JSONDictionary];

    WeChatRedEnvelopParam *mgrParams = [[WBRedEnvelopParamQueue sharedQueue] dequeue];

    BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {

        // 手动抢红包
        if (!mgrParams) { return NO; }

        // 自己已经抢过
        if ([responseDict[@"receiveStatus"] integerValue] == 2) { return NO; }

        // 红包被抢完
        if ([responseDict[@"hbStatus"] integerValue] == 4) { return NO; }

        // 没有这个字段会被判定为使用外挂
        if (!responseDict[@"timingIdentifier"]) { return NO; }

        if (mgrParams.isGroupSender) { // 自己发红包的时候没有 sign 字段
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

%new
- (unsigned int)calculateDelaySeconds {
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

%end

// Enable CallKit
%hook VoipCXMgr

+ (BOOL)isCallkitAvailable{
    return DKHelperConfig.callKitEnable;
}
+ (BOOL)isDeviceCallkitAvailable{
    return DKHelperConfig.callKitEnable;
}

%end

%hook UIViewController
- (void)viewWillAppear:(BOOL)animated{
    %orig;
    NSLog(@"\n***********************************************\n\t%@ appear\n***********************************************\n",NSStringFromClass([(NSObject*)self class]));
}

%end


%hook MMTipsViewController

%new
- (NSString *)text{
    return  [self valueForKeyPath:@"_tipsTextView.text"];
}

%end

%hook WCTimelineMgr

- (void)modifyDataItem:(WCDataItem *)arg1 notify:(BOOL)arg2{
    if (!DKHelperConfig.likeCommentEnable){
        %orig;return;
    }
    if (arg1.likeFlag){
        arg1.commentUsers = [DKHelper commentWith:arg1];
        arg1.commentCount = (int)arg1.commentUsers.count;
        arg1.likeUsers = DKHelper.commentUsers;
        arg1.likeCount = (int)DKHelper.commentUsers.count;
    }
    %orig(arg1,arg2);
}
%end

%hook CGroupMgr

// 需要验证
- (void)addChatMemberNeedVerifyMsg:(id)arg1 ContactList:(id)arg2{
    %orig(arg1,arg2);
    if (!DKHelper.shared.checkFriendsEnd){
        DKHelper.shared.groupContact = arg1;
        DKHelper.shared.notFriends = [arg2 allValues];
        dispatch_group_leave(DKHelper.shared.checkFriendGroup);
    }
}

- (void)addCreateMsg:(id)arg1 ContactList:(id)arg2{
    %orig(arg1,arg2);
    if (!DKHelper.shared.checkFriendsEnd){
        DKHelper.shared.groupContact = arg1;
        NSMutableArray *validArr = DKHelper.shared.validFriends.mutableCopy;
        [validArr addObjectsFromArray:arg2];
        DKHelper.shared.validFriends = validArr.copy;
        dispatch_group_leave(DKHelper.shared.checkFriendGroup);
    }
}
%end

%hook WCOperateFloatView

%new
-(UIButton *)m_shareBtn{
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

%new
-(UIImageView *)m_lineView2{
    static char m_lineView2Key;
    UIImageView * imageView = objc_getAssociatedObject(self, &m_lineView2Key);
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithImage:MSHookIvar<UIImageView *>(self, "m_lineView").image];
        [self.m_likeBtn.superview addSubview: imageView];
        objc_setAssociatedObject(self, &m_lineView2Key, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageView;
}

- (void)showWithItemData:(id)arg1 tipPoint:(struct CGPoint)arg2{
    %orig(arg1,arg2);
    if (DKHelperConfig.timeLineForwardEnable){
        self.frame = CGRectOffset(CGRectInset(self.frame, self.frame.size.width / -4, 0),self.frame.size.width / -4,0);
        self.m_shareBtn.frame = CGRectOffset(self.m_likeBtn.frame, self.m_likeBtn.frame.size.width * 2, 0);
        self.m_lineView2.frame = CGRectOffset(MSHookIvar<UIImageView *>(self, "m_lineView").frame, [self buttonWidth:self.m_likeBtn], 0);
    }
}

%new
- (void)forwordTimeLine:(id)arg1{
    WCForwardViewController *forwardVC = [[objc_getClass("WCForwardViewController") alloc] initWithDataItem:self.m_item];
    [self.navigationController pushViewController:forwardVC animated:true];
}

%end


@interface BaseMsgContentViewController:UIViewController
- (id)getMsgTableView;
- (id)getParentTableView;
@end

%hook BaseMsgContentViewController
- (void)viewDidLoad{
    %orig;
}

- (void)viewWillAppear:(BOOL)animated{
    %orig;
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

%end

@interface MicroMessengerAppDelegate
+ (id)GlobalInstance;
@property(retain, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIWindow *launchWindow;
@end

%hook MicroMessengerAppDelegate
%property (nonatomic, retain) UIWindow *launchWindow;

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2{
    if (!DKHelperConfig.dkLaunchEnable){return %orig; }
    BOOL end = %orig;
    DKLaunchViewController * launchVC = [[DKLaunchViewController alloc] init];
    UIWindow *launchWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.launchWindow = launchWindow;
    launchWindow.windowLevel = UIWindowLevelAlert + 1;
    launchWindow.rootViewController = launchVC;
    [launchWindow makeKeyAndVisible];
    return end;
    
}
%end
