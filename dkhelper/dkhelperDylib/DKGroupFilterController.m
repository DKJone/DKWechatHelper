//
//  DKGroupFilterController.m
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/22.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import "DKGroupFilterController.h"
#import <objc/objc-runtime.h>
#import "MMUICommonUtil.h"

@interface DKGroupFilterController ()<ContactSelectViewDelegate>{
    MMUIViewController *helper;
}
@property (strong, nonatomic) ContactSelectView *selectView;
@property (strong, nonatomic) NSArray *blackList;
@end

@implementation DKGroupFilterController

- (instancetype)initWithBlackList:(NSArray *)blackList {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _blackList = blackList;
        helper = [[objc_getClass("MMUIViewController") alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [DKHelper backgroundColor];
    [self initTitleArea];
    [self initSelectView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MMServiceCenter *serviceCenter = [objc_getClass("MMServiceCenter") defaultCenter];
    CContactMgr *contactMgr = [serviceCenter getService:objc_getClass("CContactMgr")];

    for (NSString *contactName in self.blackList) {
        CContact *contact = [contactMgr getContactByName:contactName];
        [self.selectView addSelect:contact];
    }
}

- (void)initTitleArea {
    self.navigationItem.leftBarButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithTitle:@"取消" target:self action:@selector(onCancel:) style:0];

    self.navigationItem.rightBarButtonItem = [self rightBarButtonWithSelectCount:self.blackList.count];

    self.title = @"黑名单";

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]}];
}

- (UIBarButtonItem *)rightBarButtonWithSelectCount:(unsigned long)selectCount {

    UIBarButtonItem *barButtonItem;
    if (selectCount == 0) {
        barButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithTitle:@"确定" target:self action:@selector(onDone:) style:2];
    } else {
        NSString *title = [NSString stringWithFormat:@"确定(%lu)", selectCount];
        barButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithTitle:title target:self action:@selector(onDone:) style:4];
    }
    return barButtonItem;
}

- (void)onCancel:(UIBarButtonItem *)item {
    if ([self.delegate respondsToSelector:@selector(onMultiSelectGroupCancel)]) {
        [self.delegate onMultiSelectGroupCancel];
    }
}

- (void)onDone:(UIBarButtonItem *)item {
    if ([self.delegate respondsToSelector:@selector(onMultiSelectGroupReturn:)]) {
        NSArray *blacklist = [[self.selectView.m_dicMultiSelect allKeys] copy];
        [self.delegate onMultiSelectGroupReturn:blacklist];
    }

}

- (void)initSelectView {
    self.selectView = [[objc_getClass("ContactSelectView") alloc] initWithFrame:[DKHelper viewFrame] delegate:self];

    self.selectView.m_uiGroupScene = 5;
    self.selectView.m_bMultiSelect = YES;
    [self.selectView initData:5];
    self.selectView.m_bShowHistoryGroup = false;
    self.selectView.m_bShowRadarCreateRoom = false;
    
    [self.selectView initView];

    [self.view addSubview:self.selectView];
}

#pragma mark - ContactSelectViewDelegate
- (void)onSelectContact:(CContact *)arg1 {
    self.navigationItem.rightBarButtonItem = [self rightBarButtonWithSelectCount:[self getTotalSelectCount]];
}

- (unsigned long)getTotalSelectCount {
    return (unsigned long)[self.selectView.m_dicMultiSelect count];

}

- (UIViewController *)getViewController{
    return self;
}

// 没法设置父类，设置消息转发已调用相关类方法
- (MMUIViewController *) forwardingTargetForSelector:(SEL)aSelector {
    if ([helper respondsToSelector:aSelector]) {
        return helper;
    }
    return nil;
}
@end
