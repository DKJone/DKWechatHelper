//
//  DKHelperSettingController.m
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/10.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import "DKHelperSettingController.h"
#import <objc/objc-runtime.h>
#import "DKHelper.h"
#import "DKGroupFilterController.h"
#import "DKCleanFriendsController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <WebKit/WebKit.h>
#import <CoreGraphics/CGGeometry.h>
@interface DKHelperSettingController ()<MultiSelectGroupsViewControllerDelegate>{
    WCTableViewManager * manager;
    MMUIViewController *helper;
    MMLoadingView *m_MMLoadingView;
}

@end

@implementation DKHelperSettingController

-(instancetype)init{
    if (self = [super init]) {
        helper = [[objc_getClass("MMUIViewController") alloc] init];
    }
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(checkFriendsEnd:) name:@"checkFriendsEnd" object:nil];
    m_MMLoadingView = [[NSClassFromString(@"MMLoadingView") alloc] init];
    return self;
}
- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)checkFriendsEnd:(NSNotification *)notify{
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SS(strongSelf)
        Boolean isSuccess = [notify.userInfo[@"success"] boolValue];
        NSString *msg = [notify.userInfo[@"msg"] stringValue];
        if (isSuccess){
            [strongSelf->m_MMLoadingView stopLoadingAndShowOK:@"检测成功"];
            [strongSelf reloadTableData];
            CGPoint bottomOffset = CGPointMake(0, strongSelf->manager.tableView.contentSize.height - strongSelf->manager.tableView.bounds.size.height + strongSelf-> manager.tableView.contentInset.bottom);
            [strongSelf->manager.tableView setContentOffset:bottomOffset animated:YES];
        }else{
            [strongSelf->m_MMLoadingView setText:msg];
//            [m_MMLoadingView stopLoadingAndShowError:@"检测失败"];
        }
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小助手设置";
    CGRect tableFrame = [DKHelper viewFrame];
    manager = [DKHelper tableManageWithViewFrame];
    [manager addTableViewToSuperView:self.view];
    manager.tableView.frame = tableFrame;
    self.view.backgroundColor = [DKHelper backgroundColor];
    [m_MMLoadingView setText:@"正在检测..."];
    [self.view addSubview:m_MMLoadingView];
    [self reloadTableData];
    self.navigationItem.leftBarButtonItem = [DKHelper leftNavigationItem];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if(DKHelperConfig.hasShowTips){return;}
    [DKHelper showAlertWithTitle:@"重要提示" message:@"本软件完全免费，插件功能仅供学习，由本软件产生的任何利益纠纷须有使用者自行承担。在收到微信团队\"非法客户端提示后\"继续使用可能有封号风险，需使用者自行承担。如遇到提醒，请卸载本软件，更换官方微信客户端！\n插件开发占用了作者的大量业余时间，同时部分越狱软件源盗用插件，甚至修改插件名称，如果在使用后觉得有用还请支持！" btnTitle:@"我明白了" handler:^(UIButton *sender) {
        DKHelperConfig.hasShowTips = true;
    } btnTitle:@"有风险我不使用了" handler:^(UIButton *sender) {
        exit(0);
    }];

}

- (void)reloadTableData{
    [manager clearAllSection];

    //MARK: 抢红包模块
    WCTableViewSectionManager *redEnvelopSection = [DKHelper sectionManage];
    redEnvelopSection.headerTitle = @"自动抢红包设置";
    [manager addSection:redEnvelopSection];

    WCTableViewCellManager *autoEnvelopCell = [DKHelper switchCellWithSel:@selector(autoEnvelopSwitchChange:) target:self title:@"自动抢红包" switchOn:[DKHelperConfig autoRedEnvelop]];
    [redEnvelopSection addCell:autoEnvelopCell];

    if (DKHelperConfig.autoRedEnvelop){
        //后台抢红包
        WCTableViewCellManager *redEnvelopBackGroundCell = [DKHelper switchCellWithSel:@selector(autoEnveloBackGround:) target:self title:@"锁屏及后台抢红包" switchOn:[DKHelperConfig redEnvelopBackGround]];
        [redEnvelopSection addCell:redEnvelopBackGroundCell];
        WCTableViewCellManager *personalRedEnvelopEnableCell = [DKHelper switchCellWithSel:@selector(personalRedEnvelopEnableChange:) target:self title:@"接收个人红包" switchOn:[DKHelperConfig personalRedEnvelopEnable]];
        [redEnvelopSection addCell:personalRedEnvelopEnableCell];
        //延迟抢红包
        NSString *delay = @"不延迟";
        if ([DKHelperConfig redEnvelopDelay] > 0){
            delay = [NSString stringWithFormat:@"%ld毫秒",(long)[DKHelperConfig redEnvelopDelay]];
        }
        WCTableViewCellManager *redEnvelopDelayCell = [DKHelper cellWithSel:@selector(redEnvelopDelay) target:self title:@"延迟抢红包" rightValue:delay accessoryType:1];
        [redEnvelopSection addCell:redEnvelopDelayCell];
        //关键词过滤
        NSString *textFilter = [DKHelperConfig redEnvelopTextFiter].length ? [DKHelperConfig redEnvelopTextFiter] : @"不过滤" ;
        WCTableViewCellManager *redEnvelopTextFilterCell = [DKHelper cellWithSel:@selector(redEnvelopTextFilter) target:self title:@"关键词过滤" rightValue:textFilter accessoryType:1];
        [redEnvelopSection addCell:redEnvelopTextFilterCell];
        //群聊过滤
        NSString * groupFilter = [DKHelperConfig redEnvelopGroupFiter].count ? [NSString stringWithFormat:@"已过滤%lu个群",(unsigned long)[DKHelperConfig redEnvelopGroupFiter].count] : @"不过滤";
        WCTableViewCellManager *redEnvelopGroupFilterCell = [DKHelper cellWithSel:@selector(redEnvelopGroupFiter) target:self title:@"群聊过滤" rightValue:groupFilter accessoryType:1];
        [redEnvelopSection addCell:redEnvelopGroupFilterCell];
        //抢自己的红包
        WCTableViewCellManager *redEnvelopCatchMeCell = [DKHelper switchCellWithSel:@selector(redEnvelopCatchMe:) target:self title:@"抢自己的红包" switchOn:[DKHelperConfig redEnvelopCatchMe]];
        [redEnvelopSection addCell:redEnvelopCatchMeCell];
        //防止同时抢多个红包
        WCTableViewCellManager *redEnvelopMultipleCatchCell = [DKHelper switchCellWithSel:@selector(redEnvelopMultipleCatch:) target:self title:@"防止同时抢多个红包" switchOn:[DKHelperConfig redEnvelopMultipleCatch]];
        [redEnvelopSection addCell:redEnvelopMultipleCatchCell];
    }

    //MARK: 装逼模块
    WCTableViewSectionManager *toBeNO1Section = [DKHelper sectionManage];
    toBeNO1Section.headerTitle = @"装逼必备";
    [manager addSection:toBeNO1Section];
    //消息防撤回
    WCTableViewCellManager *revokeInterceptCell = [DKHelper switchCellWithSel:@selector(revokeIntercept:) target:self title:@"消息防撤回" switchOn:[DKHelperConfig preventRevoke]];
    [toBeNO1Section addCell:revokeInterceptCell];
    //动态聊天背景和启动图
    WCTableViewCellManager *setLaunchCell = [DKHelper switchCellWithSel:@selector(setLaunch:) target:self title:@"动态启动图" switchOn:[DKHelperConfig dkLaunchEnable]];
    [toBeNO1Section addCell:setLaunchCell];
    WCTableViewCellManager *setChatBgCell = [DKHelper switchCellWithSel:@selector(setChatBg:) target:self title:@"动态聊天背景" switchOn:[DKHelperConfig dkChatBgEnable]];
    [toBeNO1Section addCell:setChatBgCell];
    //步数修改
    WCTableViewCellManager *changeStepsCell = [DKHelper switchCellWithSel:@selector(changedSteps:) target:self title:@"修改微信步数" switchOn:[DKHelperConfig changeSteps]];
    [toBeNO1Section addCell:changeStepsCell];

    if ([DKHelperConfig changeSteps]){
        NSString * steps = [NSString stringWithFormat:@"%ld",(long)[DKHelperConfig changedSteps]];
        WCTableViewCellManager *changedStepsCell = [DKHelper cellWithSel:@selector(showChangedStepInput) target:self title:@"\t步数:" rightValue: steps accessoryType:1];
        [toBeNO1Section addCell:changedStepsCell];
    }

    //小游戏作弊
    WCTableViewCellManager *gamePlugCell = [DKHelper switchCellWithSel:@selector(gamePlugEnable:) target:self title:@"小游戏作弊" switchOn:[DKHelperConfig gamePlugEnable]];
    [toBeNO1Section addCell:gamePlugCell];

    WCTableViewCellManager *callKitCell = [DKHelper switchCellWithSel:@selector(callKitEnable:) target:self title:@"使用CallKit" switchOn:[DKHelperConfig callKitEnable]];
    [toBeNO1Section addCell:callKitCell];

    WCTableViewCellManager *timelineForwardCell = [DKHelper switchCellWithSel:@selector(forwardTimeline:) target:self title:@"朋友圈转发" switchOn:[DKHelperConfig timeLineForwardEnable]];
    [toBeNO1Section addCell:timelineForwardCell];



    //MARK: 支持作者
    WCTableViewSectionManager *supportAuthorSection = [DKHelper sectionManage];
    supportAuthorSection.headerTitle = @"支持作者";
    [manager addSection:supportAuthorSection];
    WCTableViewNormalCellManager * payMeCell = [DKHelper cellWithSel:@selector(payForMe) target:self title:@"给作者倒一杯卡布奇诺"];
    [supportAuthorSection addCell:payMeCell];

    WCTableViewNormalCellManager *myBlogCell = [DKHelper cellWithSel:@selector(openBlog) target:self title:@"关于本软件"];
    [supportAuthorSection addCell:myBlogCell];

    WCTableViewNormalCellManager *myGitHubCell = [DKHelper cellWithSel:@selector(openGitHub) target:self title:@"本项目GitHub" rightValue:@"请给个⭐️" accessoryType:1];
    [supportAuthorSection addCell:myGitHubCell];
    WCTableViewNormalCellManager *joinGroupCell = [DKHelper cellWithSel:@selector(joinGroup) target:self title:@"加入交流群"];
    [supportAuthorSection addCell:joinGroupCell];


    //MARK: 积攒助手
    WCTableViewSectionManager *likeCommentSection = [DKHelper sectionManage];
    likeCommentSection.headerTitle = @"集赞助手";
    [manager addSection:likeCommentSection];

    WCTableViewCellManager *likeCommentCell = [DKHelper switchCellWithSel:@selector(likeCommentEnable:) target:self title:@"集赞助手" switchOn:[DKHelperConfig likeCommentEnable]];
    [likeCommentSection addCell:likeCommentCell];
    if (DKHelperConfig.likeCommentEnable){
        NSString * likeCount = [NSString stringWithFormat:@"%d",DKHelperConfig.likeCount.intValue];
        WCTableViewNormalCellManager *likeCountCell = [DKHelper cellWithSel:@selector(showLikeCommentInput:) target:self title:@"点赞数:" rightValue: likeCount accessoryType:1];
        [likeCommentSection addCell:likeCountCell];

        NSString * commentCount = [NSString stringWithFormat:@"%d",DKHelperConfig.commentCount.intValue];
        WCTableViewNormalCellManager *commentCountCell = [DKHelper cellWithSel:@selector(showLikeCommentInput:) target:self title:@"评论数:" rightValue:commentCount accessoryType:1];
        [likeCommentSection addCell:commentCountCell];

        WCTableViewNormalCellManager *commentsCell = [DKHelper cellWithSel:@selector(showLikeCommentInput:) target:self title:@"评论:" rightValue:DKHelperConfig.comments accessoryType:1];
        [likeCommentSection addCell:commentsCell];

        [likeCountCell  addUserInfoValue:@0 forKey:@"type"];
        [commentCountCell  addUserInfoValue:@1 forKey:@"type"];
        [commentsCell  addUserInfoValue:@2 forKey:@"type"];
    }

    //MARK: 好友检测
    WCTableViewSectionManager *clearFriendsSection = [DKHelper sectionManage];
    clearFriendsSection.headerTitle = @"好友关系检测";
    [manager addSection:clearFriendsSection];

    DKHelperConfig.cleanFriendsEnable = DKHelper.shared.validFriends.count + DKHelper.shared.notFriends.count > 0;
    WCTableViewCellManager *cleanFriendCell = [DKHelper switchCellWithSel:@selector(cleanFriends:) target:self title:@"检测好友关系" switchOn:[DKHelperConfig cleanFriendsEnable]];
    [clearFriendsSection addCell:cleanFriendCell];
    if (DKHelperConfig.cleanFriendsEnable){
        NSString * notFriendCount = [NSString stringWithFormat:@"共%lu人",(unsigned long)DKHelper.shared.notFriends.count];
        WCTableViewNormalCellManager *notFriendCountCell = [DKHelper cellWithSel:@selector(showSelectContactVC:) target:self title:@"已将你删除" rightValue:notFriendCount accessoryType:1];
        [notFriendCountCell addUserInfoValue:@0 forKey:@"type"];
        [clearFriendsSection addCell:notFriendCountCell];

        NSString * invalidFriendsCount = [NSString stringWithFormat:@"共%lu人",(unsigned long)DKHelper.shared.invalidFriends.count];
        WCTableViewNormalCellManager *invalidFriendsCell = [DKHelper cellWithSel:@selector(showSelectContactVC:) target:self title:@"无法识别" rightValue:invalidFriendsCount accessoryType:1];
        [invalidFriendsCell addUserInfoValue:@1 forKey:@"type"];
        [clearFriendsSection addCell:invalidFriendsCell];
    }

    [manager.tableView reloadData];

}

- (void)showSelectContactVC:(WCTableViewNormalCellManager *)sender{
    NSNumber * type = [sender getUserInfoValueForKey:@"type"];
    //1:被封账号 , 0:已将你删除
    NSArray *contactList = [type isEqual:@1] ? DKHelper.shared.invalidFriends : DKHelper.shared.notFriends;
    NSString *contactDesc = [type isEqual:@1] ? @"无法识别" :@"已将你删除";
    DKCleanFriendsController *vc = [[DKCleanFriendsController alloc] initWithContactList:contactList contactDesc:contactDesc];
    [self.navigationController pushViewController:vc animated:true ];
}

- (void)likeCommentEnable:(UISwitch *)sender{
    DKHelperConfig.likeCommentEnable = sender.on;
    if (sender.on ) {
        DKHelperConfig.comments = DKHelperConfig.comments.length ? @"赞,,👍" :DKHelperConfig.comments;
        [DKHelper showAlertWithTitle:@"集赞说明"
                             message:@"到需要集赞的朋友圈下点个赞即可自动集赞"
                            btnTitle:@"太棒了"
                             handler:^(UIButton *sender) { }];
    }
    [self reloadTableData];
    
}


- (void)autoEnvelopSwitchChange:(UISwitch *)sender{
    DKHelperConfig.autoRedEnvelop = sender.isOn;
    [self reloadTableData];
}

- (void)personalRedEnvelopEnableChange:(UISwitch *)sender{
    DKHelperConfig.personalRedEnvelopEnable = sender.isOn;
    [self reloadTableData];
}

- (void)cleanFriends:(UISwitch *)sender{
    if (!sender.isOn){
        DKHelperConfig.cleanFriendsEnable = false;
        return;
    }
    __block UISwitch *s = sender;
    WS(weakSelf)
    [DKHelper showAlertWithTitle:@"重要提示" message:@"好友关系检测会尝试向好友转账(并不会发生实际转账)，可以转账的好友标记为双向好友，非好友会在直接标记，其他原因不能转账的会在无法识别中显示(可能是账户违规被限制转账，或者网络原因无法获取请求结果)" btnTitle:@"开始检测" handler:^(UIButton *sender) {
        SS(strongSelf)
        DKHelperConfig.cleanFriendsEnable = true;
        [DKHelper checkFriends];
        [strongSelf->m_MMLoadingView setText:@"开始检测..."];
        [strongSelf->m_MMLoadingView startLoading];
    } btnTitle:@"取消" handler:^(UIButton *sender) {
        s.on = false;
    }];
}


- (void)revokeIntercept:(UISwitch *)sender{
    DKHelperConfig.preventRevoke = sender.isOn;
}

- (void)setLaunch:(UISwitch *)sender{
    if (![DKHelper vapFileExit] && sender.isOn){
        WS(weakSelf);
        [DKHelper showAlertWithTitle:@"资源文件下载提示" message:@"本功能需要下载18M的资源文件是否继续？" btnTitle:@"下载" handler:^(UIButton *sender) {
            [weakSelf downLoadVapfiles];
        } btnTitle:@"取消" handler:^(UIButton *sender) {

        }];
        [sender setOn:NO];
        return;
    }
    DKHelperConfig.dkLaunchEnable = sender.isOn;
    if(sender.isOn){
        DKLaunchViewController *launchVC = [[DKLaunchViewController alloc] init];
        launchVC.setType = 1;
        launchVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:launchVC animated:true completion:nil];
    }
}
- (void)setChatBg:(UISwitch *)sender{
    if (![DKHelper vapFileExit] && sender.isOn){
        WS(weakSelf);
        [DKHelper showAlertWithTitle:@"资源文件下载提示" message:@"本功能需要下载18M的资源文件是否继续？" btnTitle:@"下载" handler:^(UIButton *sender) {
            [weakSelf downLoadVapfiles];
        } btnTitle:@"取消" handler:^(UIButton *sender) {

        }];
        [sender setOn:NO];
        return;
    }
    DKHelperConfig.dkChatBgEnable = sender.isOn;
    if(sender.isOn){
        [DKHelper showAlertWithTitle:@"提示" message:@"设置动态背景时，需要确保不使用默认聊天背景才能生效。请在设置->通用->聊天背景 里修改，可修改为任意非默认聊天背景" btnTitle:@"你在教我做事?" handler:^(UIButton *sender) {
            DKLaunchViewController *launchVC = [[DKLaunchViewController alloc] init];
            launchVC.setType = 2;
            launchVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:launchVC animated:true completion:nil];
        }];
    }
}

-(void)downLoadVapfiles{
    NSString *filePath = [NSString stringWithFormat: @"%@.zip",vapPath];
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]){
        //已下载，直接解压
        [m_MMLoadingView setText:@"正在解压文件"];
        [m_MMLoadingView startLoading];
        NSError *error;
        bool unzipSuccess = [objc_getClass("MZipUtil") UnZipFile:filePath toPath:vapPath overwrite:YES password:nil error:&error];
        NSLog(@"%d:%@",unzipSuccess,error);
        [m_MMLoadingView stopLoadingAndShowOK:@"解压完成，请重新打开开关"];
        return;
    }
    m_MMLoadingView.text = @"正在下载资源文件";
    NSURL *url = [NSURL URLWithString:[@"http://srdftp.e-jt.cn/security/dangerDaily_1631608685271.zip" stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    WS(weakSelf);
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        SS(strongSelf);
        if ([NSFileManager.defaultManager fileExistsAtPath:location.path]) {
            // 下载完成,保存到本地
            NSString *filePath = [NSString stringWithFormat: @"%@.zip",vapPath];
            NSString *dirPath = [NSString stringWithFormat:@"%@%@",libPath,@"/dkjone"];
            if (![NSFileManager.defaultManager fileExistsAtPath:dirPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSError *error;
            bool saveSuccess = [NSFileManager.defaultManager moveItemAtPath:location.path toPath:filePath error:&error];
            //[data writeToFile:filePath options:NSDataWritingAtomic error:&error];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(saveSuccess){
                    [strongSelf->m_MMLoadingView setText:@"正在解压文件"];
                    bool unzipSuccess = [objc_getClass("MZipUtil") UnZipFile:filePath toPath:vapPath overwrite:YES password:nil error:nil];
                }
                [strongSelf->m_MMLoadingView stopLoadingAndShowOK:@"下载完成，请重新打开开关"];
            });

        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf->m_MMLoadingView stopLoadingAndShowError:@"下载失败"];
            });

        }
    }];
    [task resume];
    [m_MMLoadingView startLoading];
}

- (void)forwardTimeline:(UISwitch *)sender{
    DKHelperConfig.timeLineForwardEnable = sender.isOn;
}

- (void)changedSteps:(UISwitch *)sender{
    DKHelperConfig.changeSteps = sender.isOn;
    [self reloadTableData];
}

- (void)showChangedStepInput{
    NSString * str = [NSString stringWithFormat:@"%ld",(long)DKHelperConfig.changedSteps];
    WCUIAlertView * alert = [[objc_getClass("WCUIAlertView") alloc] initWithTitle:@"输入步数" message:@"最好不要超过60000否则可能被封号"];
    [alert addBtnTitle:@"确定" target:self sel:@selector(changeStepOK:)];
    [alert showTextFieldWithMaxLen:5];
    [alert setTextFieldDefaultText:str];
    [alert show];
}
-(void)changeStepOK:(MMTipsViewController *)sender{
    NSString * str = sender.text;
    DKHelperConfig.changedSteps = str.integerValue ;
    [self reloadTableData];
}

- (void)showLikeCommentInput:(WCTableViewNormalCellManager *)sender{
    NSNumber * type = [sender getUserInfoValueForKey:@"type"];
    NSString * str = @[[NSString stringWithFormat:@"%d",DKHelperConfig.likeCount.intValue],
                       [NSString stringWithFormat:@"%d",DKHelperConfig.commentCount.intValue],
                       [NSString stringWithFormat:@"%@",DKHelperConfig.comments]][type.intValue];
    NSString * title = @[@"输入点赞数",@"输入评论数",@"输入评论"][type.intValue];
    NSString * msg = @[@"实际点赞数最大为您的好友个数",
                       @"原始评论会保留",
                       @"用英文双逗号分隔，例(赞,,👍,,...)"][type.intValue];
    WCUIAlertView * alert = [[objc_getClass("WCUIAlertView") alloc] initWithTitle:title message:msg];
    [alert addBtnTitle:@"确定" target:self sel:@selector(changelikeCountOK:)];
    [alert showTextFieldWithMaxLen:type.intValue == 2 ? 10000: 5];
    [alert setTextFieldDefaultText:str];
    [alert show];
}

-(void)changelikeCountOK:(MMTipsViewController *)sender{
    NSLog(@"%@",sender);
    NSString * title = [sender valueForKey:@"_tipsTitle"];
    if ([@"输入评论数" isEqualToString:title]){
        DKHelperConfig.commentCount = @(sender.text.intValue);
    }else if([@"输入点赞数" isEqualToString:title]){
        DKHelperConfig.likeCount = @(sender.text.intValue);
    }else{
        DKHelperConfig.comments = sender.text;
    }
    [self reloadTableData];
}


-(void)gamePlugEnable:(UISwitch *)sender{
    DKHelperConfig.gamePlugEnable = sender.isOn;
    if (sender.isOn){
        [DKHelper showAlertWithTitle:@"" message:@"小游戏作弊暂只支持掷骰子和剪刀石头布" btnTitle:@"知道了" handler:^(UIButton *sender) { }];
    }
}

-(void)callKitEnable:(UISwitch *)sender{
    DKHelperConfig.callKitEnable = sender.isOn;
    if (sender.isOn){
        [DKHelper showAlertWithTitle:@"" message:@"现在可以在锁屏状态下，接听微信电话了！" btnTitle:@"太棒了" handler:^(UIButton *sender) { }];
    }
}

- (void)payForMe{
    ScanQRCodeResultsMgr *scMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("ScanQRCodeResultsMgr") class]];
    ScanCodeHistoryItem *item = [[objc_getClass("ScanCodeHistoryItem") alloc] init];
    item.type = @"WX_CODE";
    item.codeUrl = @"m0E25xJo038.ran,NI96(j";
    [scMgr retryRequetScanResult:item viewController:self];
}
- (void)joinGroup{
    ScanQRCodeResultsMgr *scMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("ScanQRCodeResultsMgr") class]];
    ScanCodeHistoryItem *item = [[objc_getClass("ScanCodeHistoryItem") alloc] init];
    item.type = @"QR_CODE";
    item.codeUrl = DKHelper.shared.groupURL;
    [scMgr retryRequetScanResult:item viewController:self];
}

- (void)openBlog{
    NSURL *blogUrl = [NSURL URLWithString:@"https://juejin.cn/post/7009142365671817223"];
    MMWebViewController *webViewController = [[objc_getClass("MMWebViewController") alloc] initWithURL:blogUrl presentModal:NO extraInfo:nil];
    [self.navigationController PushViewController:webViewController animated:YES];
}

- (void)openGitHub{
    NSURL *blogUrl = [NSURL URLWithString:@"https://github.com/DKWechatHelper/DKWechatHelper"];
    MMWebViewController *webViewController = [[objc_getClass("MMWebViewController") alloc] initWithURL:blogUrl presentModal:NO extraInfo:nil];
    [self.navigationController PushViewController:webViewController animated:YES];

}

-(void)autoEnveloBackGround:(UISwitch *)sender{
    if (!sender.isOn){
        DKHelperConfig.redEnvelopBackGround = false;
        return;
    }
    __block UISwitch * s = sender;
    [DKHelper showAlertWithTitle:@"重要提示" message:@"开启后台抢红包会使微信一直保持后台运行，消耗电池电量。您是否继续开启？" btnTitle:@"开启" handler:^(UIButton *sender) {
        DKHelperConfig.redEnvelopBackGround = true;
    } btnTitle:@"取消" handler:^(UIButton *sender) {
        s.on = false;
    }];
}

- (void)redEnvelopDelay{
    NSString * str = [NSString stringWithFormat:@"%ld",(long)DKHelperConfig.redEnvelopDelay];
    WCUIAlertView * alert = [[objc_getClass("WCUIAlertView") alloc] initWithTitle:@"输入延迟时间(1秒=1000毫秒)" message:@""];
    [alert addBtnTitle:@"确定" target:self sel:@selector(changeDelayOK:)];
    [alert showTextFieldWithMaxLen:6];
    UITextField * filed = alert.getTextField;
    filed.placeholder = str;
    if (DKHelperConfig.redEnvelopDelay) {
        [alert setTextFieldDefaultText:str];
    }
    [alert show];
}
-(void)changeDelayOK:(MMTipsViewController *)sender{
    NSString * str = sender.text;
    DKHelperConfig.redEnvelopDelay = str.integerValue ;
    [self reloadTableData];
}

- (void)redEnvelopTextFilter{
    NSString *str = [DKHelperConfig redEnvelopTextFiter].length ? [DKHelperConfig redEnvelopTextFiter] : @"不过滤" ;
    WCUIAlertView * alert = [[objc_getClass("WCUIAlertView") alloc] initWithTitle:@"输入关键词以英文逗号分隔(例：抢一罚五,罚款)" message:@""];
    [alert addBtnTitle:@"确定" target:self sel:@selector(changeTextFilterOK:)];
    [alert addBtnTitle:@"取消" target:self sel:nil];
    [alert showTextFieldWithMaxLen:200];
    UITextField * filed = alert.getTextField;
    filed.placeholder = str;
    if([DKHelperConfig redEnvelopTextFiter].length ){
        [alert setTextFieldDefaultText:str];
    }
    [alert show];
}
-(void)changeTextFilterOK:(MMTipsViewController *)sender{
    NSString * str = sender.text;
    DKHelperConfig.redEnvelopTextFiter = str ;
    [self reloadTableData];
}

-(void)redEnvelopGroupFiter{
    DKGroupFilterController *contactsViewController = [[DKGroupFilterController alloc] initWithBlackList:DKHelperConfig.redEnvelopGroupFiter];
    contactsViewController.delegate = self;

    MMUINavigationController *navigationController = [[objc_getClass("MMUINavigationController") alloc] initWithRootViewController:contactsViewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)redEnvelopCatchMe:(UISwitch *)sender{
    DKHelperConfig.redEnvelopCatchMe = sender.isOn;
}

-(void)redEnvelopMultipleCatch:(UISwitch *)sender{
    DKHelperConfig.redEnvelopMultipleCatch = sender.isOn;
}



#pragma mark - MultiSelectGroupsViewControllerDelegate
- (void)onMultiSelectGroupCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)onMultiSelectGroupReturn:(NSArray *)arg1 {
    DKHelperConfig.redEnvelopGroupFiter  = arg1;
    [self reloadTableData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 没法设置父类，设置消息转发以调用相关类方法
- (MMUIViewController *) forwardingTargetForSelector:(SEL)aSelector {
    if ([helper respondsToSelector:aSelector]) {
        return helper;
    }
    return nil;
}

@end
