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
}
@end

@implementation DKHelper

+ (instancetype)shared {
    static DKHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DKHelper alloc] init];
    });
    return helper;
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

+ (CGRect)viewFrame{
    CGFloat width =  [FUiUtil screenWidthCurOri];
    CGFloat y = [FUiUtil navigationBarHeightCurOri] + [FUiUtil normalStatusBarHeight];
    CGFloat height = [FUiUtil visibleHeight:[DKHelper navigationContrioller].viewControllers.firstObject] - y;
    return CGRectMake(0, y, width, height);

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
