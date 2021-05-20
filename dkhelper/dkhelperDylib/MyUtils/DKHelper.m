//
//  DKHelper.m
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/21.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import "DKHelper.h"
@interface DKHelper(){
    BtnBlock act1;
    BtnBlock act2;
    NSArray* allFriends;
}
@end

@implementation DKHelper

+ (instancetype)shared {
    static DKHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DKHelper alloc] init];
        helper.checkFriendsEnd = true;
    });
    return helper;
}


- (void)setCheckNotify{
    self.checkFriendGroup = dispatch_group_create();
    DKHelper.shared.invalidFriends = @[];
    DKHelper.shared.validFriends = @[];
    DKHelper.shared.notFriends = @[];
    dispatch_group_enter(DKHelper.shared.checkFriendGroup);
    dispatch_group_enter(DKHelper.shared.checkFriendGroup);

    dispatch_group_notify(self.checkFriendGroup, dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [DKHelper endCheck];
        });
    });
    
}
+ (void)endCheck{
    DKHelper.shared.checkFriendsEnd = true;
    CContactMgr *contactMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
    if (DKHelper.shared.validFriends.count + DKHelper.shared.notFriends.count > 0) {
        ///检测完成了
        DKHelper.shared.notFriends = [DKHelper.shared.notFriends _filter:^BOOL(id obj) {
            return ![[[contactMgr getSelfContact] m_nsUsrName] isEqualToString:((CContact*)obj).m_nsUsrName];
        }];
       NSArray<CContact*> *invalidFriends = DKHelper.allFriends.copy;
        NSMutableArray *addSelf =  DKHelper.shared.validFriends.mutableCopy;
        [addSelf addObject:[contactMgr getSelfContact]];
        DKHelper.shared.validFriends = addSelf;
       invalidFriends = [invalidFriends _filter:^BOOL(id obj) {
            return ![DKHelper.shared.notFriends _contains:^BOOL(id obj2) {
                return  [((CContact*)obj).m_nsUsrName isEqualToString: ((CContact*)obj2).m_nsUsrName];
            }];
        }];
        invalidFriends = [invalidFriends _filter:^BOOL(id obj) {
             return ![DKHelper.shared.validFriends _contains:^BOOL(id obj2) {
                 return  [((CContact*)obj).m_nsUsrName isEqualToString: ((CContact*)obj2).m_nsUsrName];
             }];
         }];
        DKHelper.shared.invalidFriends = invalidFriends;
        [NSNotificationCenter.defaultCenter postNotificationName:@"checkFriendsEnd" object:nil userInfo:@{@"success":@YES}];
    }else{
        /// 检测超时结束
        DKHelper.shared.invalidFriends = @[];
        DKHelper.shared.validFriends = @[];
        DKHelper.shared.notFriends = @[];
        [NSNotificationCenter.defaultCenter postNotificationName:@"checkFriendsEnd" object:nil userInfo:@{@"success":@NO}];
    }
    // 删除群聊
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MMNewSessionMgr * sm =[[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("MMNewSessionMgr") class]];
        unsigned int idx = [sm getSessionIndexOfUser:DKHelper.shared.groupContact.m_nsUsrName];
        if (idx != (unsigned int)(NSNotFound)){
            [sm deleteSessionAtIndex:idx forceDelete:false];
        }
    });
}


+ (UINavigationController *)navigationContrioller{
    return ((UINavigationController *)([objc_getClass("CAppViewControllerManager") getCurrentNavigationController]));
}

+ (UIBarButtonItem *)leftNavigationItem{

    UINavigationController * navc =  [DKHelper navigationContrioller];
    for (UIViewController *vc in navc.childViewControllers) {
        UIBarButtonItem * item = vc.navigationItem.leftBarButtonItem;
        if (item) { return item; }
    }
    return nil;
}

+ (UIColor *)backgroundColor{
    return [DKHelper tableManageWithViewFrame].tableView.backgroundColor;
}

-(NSString *)groupURL{
    if (_groupURL.length) {
        return _groupURL;
    }else{
        _groupURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://gitee.com/DKJone/projects-configuration/raw/master/wxQrCode"] encoding:NSUTF8StringEncoding error:nil];
        return  _groupURL;
    }
}

+ (CGRect)viewFrame{
    CGFloat width =  [FUiUtil screenWidthCurOri];
    CGFloat y = [FUiUtil navigationBarHeightCurOri] + [FUiUtil normalStatusBarHeight];
    CGFloat height = [FUiUtil visibleHeight:[DKHelper navigationContrioller].viewControllers.firstObject] - y;
    return CGRectMake(0, y, width, height);

}

+ (NSArray<CContact*> *)allFriends{
    // 好友缓存为空时去数据库加载
    if (!DKHelper.shared->allFriends.count){
        NSMutableArray * friends = [NSMutableArray array];
        CContactMgr *contactMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
        NSArray* contacts = [contactMgr getContactList:1 contactType:0];
        for(CContact* contact in contacts){
            if (!contact.isBrandContact && contact.m_uiSex != 0 && ![contact.m_nsUsrName containsString:@"@openim"]) {
                [friends addObject:contact];
            }
        }
        DKHelper.shared->allFriends = friends;
    }
    return DKHelper.shared->allFriends;
}

+ (NSMutableArray<WCUserComment *>*)commentUsers{
    NSMutableArray* likeCommentUsers = [NSMutableArray array];
    [DKHelper.allFriends enumerateObjectsUsingBlock:^(CContact * curAddContact, NSUInteger idx, BOOL * _Nonnull stop) {
        WCUserComment* likeComment = [[objc_getClass("WCUserComment") alloc] init];
        likeComment.username = curAddContact.m_nsUsrName;
        likeComment.nickname = curAddContact.m_nsNickName;
        likeComment.type = 2;
        likeComment.commentID = [NSString stringWithFormat:@"%lu", (unsigned long)idx];
        likeComment.createTime = [[NSDate date] timeIntervalSince1970];
        [likeCommentUsers addObject:likeComment];
        *stop = (DKHelperConfig.likeCount.integerValue == idx);
    }];
    return likeCommentUsers;
}

+ (NSMutableArray<WCUserComment *>*)commentWith:(WCDataItem *) origItem{

    NSMutableArray* origComment = origItem.commentUsers;
    if (origComment.count >= DKHelperConfig.commentCount.intValue){ return origComment;}
    NSMutableArray* newComments = [NSMutableArray array];

    [newComments addObjectsFromArray:origComment];
    NSArray<NSString *> *defaultComments = [DKHelperConfig.comments componentsSeparatedByString:@",,"];
    if (!DKHelperConfig.comments.length){ defaultComments = @[@"赞",@"👍"];}
    int timeInterval = NSDate.date.timeIntervalSince1970 - origItem.createtime;
___addComment:
    [DKHelper.allFriends enumerateObjectsUsingBlock:^(CContact * curAddContact, NSUInteger idx, BOOL * _Nonnull stop) {
        WCUserComment* newComment = [[objc_getClass("WCUserComment") alloc] init];
        newComment.username = curAddContact.m_nsUsrName;
        newComment.nickname = curAddContact.m_nsNickName;
        newComment.type = 2;
        newComment.commentID = [NSString stringWithFormat:@"%lu", (unsigned long)idx + origComment.count];
        newComment.createTime = NSDate.date.timeIntervalSince1970 - arc4random() % timeInterval ;
        newComment.content = defaultComments[arc4random() % defaultComments.count];
        [newComments addObject:newComment];
        *stop = DKHelperConfig.commentCount.intValue <= idx + origComment.count;
    }];
    if(DKHelperConfig.commentCount.intValue > newComments.count ){
        goto ___addComment;
    }

    [newComments sortUsingComparator:^NSComparisonResult(WCUserComment*  _Nonnull obj1, WCUserComment *  _Nonnull obj2) {
        return obj1.createTime < obj2.createTime ? NSOrderedAscending : NSOrderedDescending;
    }];
    return newComments;
}

+ (WCTableViewManager *)tableManageWithViewFrame{
    CGRect tableFrame = [DKHelper viewFrame];
    WCTableViewManager* manager = [[objc_getClass("WCTableViewManager") alloc] initWithFrame:tableFrame style:1];
    manager.tableView.frame = tableFrame;
    return manager;
}

+ (WCTableViewSectionManager *) sectionManage{
    return [objc_getClass("WCTableViewSectionManager") defaultSection];
}

+ (WCTableViewNormalCellManager *)cellWithSel:(SEL)sel target:(id)target title:(NSString *)title{
    return [objc_getClass("WCTableViewNormalCellManager") normalCellForSel:sel target:target title:title];
}
+ (WCTableViewNormalCellManager *)cellWithSel:(SEL)sel target:(id)target title:(NSString *)title rightValue:(NSString *)rightValue accessoryType:(long long) acctype{

    return  [objc_getClass("WCTableViewNormalCellManager") normalCellForSel:sel target:target title:title rightValue:rightValue accessoryType:acctype];
}

+ (WCTableViewNormalCellManager *)switchCellWithSel:(SEL)sel target:(id)target title:(NSString *)title switchOn:(BOOL)switchOn{

    return  [objc_getClass("WCTableViewNormalCellManager") switchCellForSel:sel target:target title:title on:switchOn];
}

+ (WCUIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)msg btnTitle:(NSString *)btnTitle handler:(BtnBlock)handler{
    WCUIAlertView * alert = [objc_getClass("WCUIAlertView") showAlertWithTitle:title message:msg btnTitle:btnTitle target:DKHelper.shared sel:@selector(action1:)];
    DKHelper.shared->act1 = handler;
    return alert;
}

+ (WCUIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)msg btnTitle:(NSString *)btn1 handler:(BtnBlock)handler1 btnTitle:(NSString *)btn2 handler:(BtnBlock)handler2{
    WCUIAlertView * alert = [objc_getClass("WCUIAlertView") showAlertWithTitle:title message:msg btnTitle:btn1 target:DKHelper.shared sel:@selector(action1:) btnTitle:btn2 target:DKHelper.shared sel:@selector(action2:)];
    DKHelper.shared->act1 = handler1;
    DKHelper.shared->act2 = handler2;
    return alert;

}


- (void)action1:(id)sender{
    NSArray<UIButton *> *array = [sender valueForKey:@"btnArray"];
    act1(array[0]);
}

- (void)action2:(id)sender{
    NSArray<UIButton *> *array = [sender valueForKey:@"btnArray"];
    act2(array[1]);

}
      // 发送消息
+ (void)sendMsg:(NSString *)msg toContactUsrName:(NSString *)userName {
    [DKHelper sendMsg:msg toContactUsrName:userName uiMsgType:1];
}
+ (void)sendMsg:(NSString *)msg toContactUsrName:(NSString *)userName uiMsgType:(int)type{
    CMessageWrap *wrap = [[objc_getClass("CMessageWrap") alloc] initWithMsgType:type];
    id usrName = [objc_getClass("SettingUtil") getLocalUsrName:0];
    [wrap setM_nsFromUsr:usrName];
    [wrap setM_nsContent:msg];
    [wrap setM_nsToUsr:userName];
    wrap.m_uiMesLocalID = 11;

    MMNewSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMNewSessionMgr")];
    [wrap setM_uiCreateTime:[sessionMgr GenSendMsgTime]];
    [wrap setM_uiStatus:YES];

    CMessageMgr *chatMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CMessageMgr")];
    [chatMgr AddMsg:userName MsgWrap:wrap];
}
@end



//MARK: - WeChatRedEnvelop From:https://github.com/buginux/WeChatRedEnvelop

@implementation WeChatRedEnvelopParam

- (NSDictionary *)toParams {
    return @{
             @"msgType": self.msgType,
             @"sendId": self.sendId,
             @"channelId": self.channelId,
             @"nickName": self.nickName,
             @"headImg": self.headImg,
             @"nativeUrl": self.nativeUrl,
             @"sessionUserName": self.sessionUserName,
             @"timingIdentifier": self.timingIdentifier
             };
}
@end

@interface WBRedEnvelopParamQueue ()
@property (strong, nonatomic) NSMutableArray *queue;
@end

@implementation WBRedEnvelopParamQueue
+ (instancetype)sharedQueue {
    static WBRedEnvelopParamQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[WBRedEnvelopParamQueue alloc] init];
    });
    return queue;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)enqueue:(WeChatRedEnvelopParam *)param {
    [self.queue addObject:param];
}

- (WeChatRedEnvelopParam *)dequeue {
    if (self.queue.count == 0 && !self.queue.firstObject) {
        return nil;
    }

    WeChatRedEnvelopParam *first = self.queue.firstObject;

    [self.queue removeObjectAtIndex:0];

    return first;
}

- (WeChatRedEnvelopParam *)peek {
    if (self.queue.count == 0) {
        return nil;
    }

    return self.queue.firstObject;
}

- (BOOL)isEmpty {
    return self.queue.count == 0;
}

@end

@interface WBReceiveRedEnvelopOperation ()

@property (assign, nonatomic, getter=isExecuting) BOOL executing;
@property (assign, nonatomic, getter=isFinished) BOOL finished;

@property (strong, nonatomic) WeChatRedEnvelopParam *redEnvelopParam;
@property (assign, nonatomic) unsigned int delaySeconds;

@end

@implementation WBReceiveRedEnvelopOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRedEnvelopParam:(WeChatRedEnvelopParam *)param delay:(unsigned int)delaySeconds {
    if (self = [super init]) {
        _redEnvelopParam = param;
        _delaySeconds = delaySeconds;
    }
    return self;
}

- (void)start {
    if (self.isCancelled) {
        self.finished = YES;
        self.executing = NO;
        return;
    }

    [self main];

    self.executing = YES;
    self.finished = NO;
}

- (void)main {

    [NSThread sleepForTimeInterval:self.delaySeconds/1000.0];
    WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
    [logicMgr OpenRedEnvelopesRequest:[self.redEnvelopParam toParams]];

    self.finished = YES;
    self.executing = NO;
}

- (void)cancel {
    self.finished = YES;
    self.executing = NO;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous {
    return YES;
}

@end



@interface WBRedEnvelopTaskManager ()

@property (strong, nonatomic) NSOperationQueue *normalTaskQueue;
@property (strong, nonatomic) NSOperationQueue *serialTaskQueue;

@end

@implementation WBRedEnvelopTaskManager

+ (instancetype)sharedManager {
    static WBRedEnvelopTaskManager *taskManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        taskManager = [WBRedEnvelopTaskManager new];
    });
    return taskManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _serialTaskQueue = [[NSOperationQueue alloc] init];
        _serialTaskQueue.maxConcurrentOperationCount = 1;

        _normalTaskQueue = [[NSOperationQueue alloc] init];
        _normalTaskQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (void)addNormalTask:(WBReceiveRedEnvelopOperation *)task {
    [self.normalTaskQueue addOperation:task];
}

- (void)addSerialTask:(WBReceiveRedEnvelopOperation *)task {
    [self.serialTaskQueue addOperation:task];
}

- (BOOL)serialQueueIsEmpty {
    return [self.serialTaskQueue operations].count == 0;
}

@end
