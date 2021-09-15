//  DKCleanFriendsController.m
//  dkhelperDylib
//  Created by DKJone on 2020/9/25
//  Copyright © 2020 DKJone. All rights reserved.
//
//
//                    ██████╗ ██╗  ██╗     ██╗ ██████╗ ███╗   ██╗███████╗
//                    ██╔══██╗██║ ██╔╝     ██║██╔═══██╗████╗  ██║██╔════╝
//                    ██║  ██║█████╔╝      ██║██║   ██║██╔██╗ ██║█████╗
//                    ██║  ██║██╔═██╗ ██   ██║██║   ██║██║╚██╗██║██╔══╝
//                    ██████╔╝██║  ██╗╚█████╔╝╚██████╔╝██║ ╚████║███████╗
//                    ╚═════╝ ╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝
//
//

#import "DKCleanFriendsController.h"
#import <objc/objc-runtime.h>
#import "MMUICommonUtil.h"
#import "DKHelperSettingController.h"
@interface DKCleanFriendsController()<ContactSelectViewDelegate>{
    MMUIViewController *helper;
}

@property (strong, nonatomic) ContactSelectView *selectView;
@property (nonatomic,copy)NSString * contactDesc;
@property (strong, nonatomic) NSArray<CContact *> *contactList;
@end

@implementation DKCleanFriendsController

- (instancetype)initWithContactList:(NSArray *)contactList contactDesc:(NSString *)contactDesc{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _contactList = contactList;
        _contactDesc = contactDesc;
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

    for (CContact *contact in self.contactList) {
        [self.selectView addSelect:contact];
    }
    for (CContact *contact in DKHelper.shared.validFriends) {
        [self.selectView removeSelect:contact];
    }
    [self onSelectContact: nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *alertTitle = [NSString stringWithFormat:@"已帮您自动选择(%@)的好友",self.contactDesc];
    [DKHelper showAlertWithTitle:alertTitle
                         message:@"双向好友已自动设为不可编辑，您无法取消双向好友的选中状态，删除时也不会删除双向好友！"
                        btnTitle:@"我知道了" handler:^(UIButton *sender) {}];
}

- (void)initTitleArea {
    self.navigationItem.leftBarButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithTitle:@"取消" target:self action:@selector(onCancel:) style:0];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonWithSelectCount:self.contactList.count];
    self.title = @"选择需要删除的好友";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]}];
}

- (UIBarButtonItem *)rightBarButtonWithSelectCount:(unsigned long)selectCount {

    UIBarButtonItem *barButtonItem;
    if (selectCount == 0) {
        barButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithTitle:@"确定" target:self action:@selector(onDone:) style:1];
    } else {
        NSString *title = [NSString stringWithFormat:@"删除(%lu)", selectCount];
        barButtonItem = [objc_getClass("MMUICommonUtil") getBarButtonWithTitle:title target:self action:@selector(onDone:) style:4];
    }
    return barButtonItem;
}

- (void)onCancel:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)onDone:(UIBarButtonItem *)item {
    NSArray<NSString *> *contactNameList = [[self.selectView.m_dicMultiSelect allKeys] copy];
    NSArray<CContact *> *contactList = [[DKHelper allFriends] _filter:^BOOL(CContact* obj) {
            return [contactNameList containsObject: obj.m_nsUsrName];
    }];
    NSArray<NSString*> *nikNames = [contactList _map:^id(CContact* obj) {
        return obj.m_nsRemark.length ? obj.m_nsRemark : obj.m_nsNickName;
    }];
   WS(weakSelf)
    [DKHelper showAlertWithTitle:@"删除以下好友" message:[nikNames componentsJoinedByString:@"\n"] btnTitle:@"确定" handler:^(UIButton *sender) {
        [weakSelf deleteFriends:contactList];
    } btnTitle:@"我再想想" handler:^(UIButton *sender) {}];
}


-(void)deleteFriends:(NSArray *)contactList {
    CContactMgr * contactMgr =[[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
    MMNewSessionMgr * sm =[[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("MMNewSessionMgr") class]];
        for (CContact *contact in  contactList) {
            [contactMgr deleteContact:contact listType:2];
            [contactMgr deleteContactLocal:contact listType:1];
            [contactMgr getContactList:1 contactType:0];
            unsigned int idx = [sm getSessionIndexOfUser:contact.m_nsUsrName];
            if (idx != (unsigned int)(NSNotFound)){
                [sm deleteSessionAtIndex:idx forceDelete:false];
            }
            NSLog(@"删除成功");
        }

    NSInteger notFriendCount = DKHelper.shared.notFriends.count;
    NSInteger invalidFriendCount = DKHelper.shared.invalidFriends.count;
    if (notFriendCount != contactList.count &&
        invalidFriendCount != contactList.count &&
        notFriendCount + invalidFriendCount != contactList.count){
        [self.navigationController popViewControllerAnimated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [DKHelper showAlertWithTitle:@"删除成功" message:@"有些人，\n就算分隔千里，\n就算不再联系，\n就算岁月流逝他们渐渐遗忘在我们记忆深处，\n就算不能陪我们走完人生旅途的那些人，\n他们不是过客。\n他们是\n我们最美好的曾经..." btnTitle:@"说的好！领赏去吧" handler:^(UIButton *sender) {
                UIViewController *vc = [DKHelper.navigationContrioller topViewController];
                if ([vc isKindOfClass:DKHelperSettingController.class]){
                    [(DKHelperSettingController *)vc payForMe];
                }
            } btnTitle:@"跟鬼屎一样，不存在的！" handler:^(UIButton *sender) { }];
        });
    }else{
        [DKHelper showAlertWithTitle:@"删除成功"
                             message:[NSString stringWithFormat: @"已成功删除%d名好友",(int)contactList.count]
                            btnTitle:@"确定" handler:^(UIButton *sender) { }];
    }
}

- (void)initSelectView {
    self.selectView = [[objc_getClass("ContactSelectView") alloc] initWithFrame:[DKHelper viewFrame] delegate:self];

    NSMutableArray *dic = @{}.mutableCopy;
    for (CContact *contact in DKHelper.shared.validFriends) {
        [dic setValue:contact forKey:contact.m_nsUsrName];
    }
    [self.selectView  setM_dicExistContact:dic];

    
    self.selectView.m_uiGroupScene = 14;
    self.selectView.m_bMultiSelect = YES;
    [self.selectView initData:2];
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
