#import <UIKit/UIKit.h>
#import "DKHelper.h"
#import "DKHelperSettingController.h"


%hook MicroMessengerAppDelegate

- (void)applicationDidEnterBackground:(UIApplication *)application{
    %orig;
    [[DKHelperConfig shared] enterBackgroundHandler];
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

%new        // 发送消息
- (void)sendMsg:(NSString *)msg toContactUsrName:(NSString *)userName {
    CMessageWrap *wrap = [[%c(CMessageWrap) alloc] initWithMsgType:1];
    id usrName = [%c(SettingUtil) getLocalUsrName:0];
    [wrap setM_nsFromUsr:usrName];
    [wrap setM_nsContent:msg];
    [wrap setM_nsToUsr:userName];
    MMNewSessionMgr *sessionMgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(MMNewSessionMgr)];
    [wrap setM_uiCreateTime:[sessionMgr GenSendMsgTime]];
    [wrap setM_uiStatus:YES];

    CMessageMgr *chatMgr = [[%c(MMServiceCenter) defaultCenter] getService:%c(CMessageMgr)];
    [chatMgr AddMsg:userName MsgWrap:wrap];
}

- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(CMessageWrap *)wrap {
    %orig;

    switch(wrap.m_uiMessageType) {
        case 49: { // AppNode

            /** 是否为红包消息 */
            BOOL (^isRedEnvelopMessage)() = ^BOOL() {
                return [wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound;
            };

            if (isRedEnvelopMessage()) { // 红包
                CContactMgr *contactManager = [[%c(MMServiceCenter) defaultCenter] getService:[%c(CContactMgr) class]];
                CContact *selfContact = [contactManager getSelfContact];

                BOOL (^isSender)() = ^BOOL() {
                    return [wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName];
                };

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

                    return isGroupReceiver() || (isGroupSender() && isReceiveSelfRedEnvelop());
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

%hook UIViewController
- (void)viewWillAppear:(BOOL)animated{
    %orig;
    NSLog(@"\n***********************************************\n\t%@ appear\n***********************************************\n",NSStringFromClass([(NSObject*)self class]));
}

%end

