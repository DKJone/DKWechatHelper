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
@interface DKHelperSettingController ()<MultiSelectGroupsViewControllerDelegate>{
    WCTableViewManager * manager;
    MMUIViewController *helper;
}

@end

@implementation DKHelperSettingController

-(instancetype)init{
    if (self = [super init]) {
        helper = [[objc_getClass("MMUIViewController") alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小助手设置";
    CGRect tableFrame = [DKHelper viewFrame];
    manager = [DKHelper tableManageWithViewFrame];
    [manager addTableViewToSuperView:self.view];
    manager.tableView.frame = tableFrame;
    self.view.backgroundColor = [DKHelper backgroundColor];
    [self reloadTableData];
    self.navigationItem.leftBarButtonItem = [DKHelper leftNavigationItem];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if(DKHelperConfig.hasShowTips){return;}
    [DKHelper showAlertWithTitle:@"重要提示" message:@"本软件完全免费，插件功能仅供学习，由本软件产生的任何利益纠纷须有使用者自行承担。在收到微信团队\"非法客户端提示后\"继续使用可能有封号风险，需使用者自行承担。如遇到提醒，请卸载本软件，更换官方微信客户端" btnTitle:@"我明白了" handler:^(UIButton *sender) {
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


    //MARK: 装逼模块
    WCTableViewSectionManager *toBeNO1Section = [DKHelper sectionManage];
    toBeNO1Section.headerTitle = @"装逼必备";
    [manager addSection:toBeNO1Section];
    //消息防撤回
    WCTableViewCellManager *revokeInterceptCell = [DKHelper switchCellWithSel:@selector(revokeIntercept:) target:self title:@"消息防撤回" switchOn:[DKHelperConfig preventRevoke]];
    [toBeNO1Section addCell:revokeInterceptCell];
    //步数修改
    WCTableViewCellManager *changeStepsCell = [DKHelper switchCellWithSel:@selector(changedSteps:) target:self title:@"修改微信步数" switchOn:[DKHelperConfig changeSteps]];
    [toBeNO1Section addCell:changeStepsCell];

    if ([DKHelperConfig changeSteps]){
        NSString * steps = [NSString stringWithFormat:@"%ld",[DKHelperConfig changedSteps]];
        WCTableViewCellManager *changedStepsCell = [DKHelper cellWithSel:@selector(showChangedStepInput) target:self title:@"\t步数:" rightValue: steps accessoryType:1];
        [toBeNO1Section addCell:changedStepsCell];
    }

    //小游戏作弊
    WCTableViewCellManager *gamePlugCell = [DKHelper switchCellWithSel:@selector(gamePlugEnable:) target:self title:@"小游戏作弊" switchOn:[DKHelperConfig gamePlugEnable]];
    [toBeNO1Section addCell:gamePlugCell];



    //MARK: 支持作者
    WCTableViewSectionManager *supportAuthorSection = [DKHelper sectionManage];
    supportAuthorSection.headerTitle = @"支持作者";
    [manager addSection:supportAuthorSection];
    WCTableViewNormalCellManager * payMeCell = [DKHelper cellWithSel:@selector(payForMe) target:self title:@"请作者喝杯咖啡"];
    [supportAuthorSection addCell:payMeCell];

    WCTableViewNormalCellManager *myBlogCell = [DKHelper cellWithSel:@selector(openBlog) target:self title:@"我的博客"];
    [supportAuthorSection addCell:myBlogCell];

    WCTableViewNormalCellManager *myGitHubCell = [DKHelper cellWithSel:@selector(openGitHub) target:self title:@"本项目GitHub" rightValue:@"请给个⭐️" accessoryType:1];
    [supportAuthorSection addCell:myGitHubCell];



    //MARK: 高级功能
    WCTableViewSectionManager *advancedSection = [DKHelper sectionManage];
    advancedSection.headerTitle = @"高级功能";
    [manager addSection:advancedSection];
    //后台抢红包
    WCTableViewCellManager *redEnvelopBackGroundCell = [DKHelper switchCellWithSel:@selector(autoEnveloBackGround:) target:self title:@"锁屏及后台抢红包" switchOn:[DKHelperConfig redEnvelopBackGround]];
    [advancedSection addCell:redEnvelopBackGroundCell];
    //延迟抢红包
    NSString *delay = @"不延迟";
    if ([DKHelperConfig redEnvelopDelay] > 0){
        delay = [NSString stringWithFormat:@"%ld毫秒",[DKHelperConfig redEnvelopDelay]];
    }
    WCTableViewCellManager *redEnvelopDelayCell = [DKHelper cellWithSel:@selector(redEnvelopDelay) target:self title:@"延迟抢红包" rightValue:delay accessoryType:1];
    [advancedSection addCell:redEnvelopDelayCell];
    //关键词过滤
    NSString *textFilter = [DKHelperConfig redEnvelopTextFiter].length ? [DKHelperConfig redEnvelopTextFiter] : @"不过滤" ;
    WCTableViewCellManager *redEnvelopTextFilterCell = [DKHelper cellWithSel:@selector(redEnvelopTextFilter) target:self title:@"关键词过滤" rightValue:textFilter accessoryType:1];
    [advancedSection addCell:redEnvelopTextFilterCell];
    //群聊过滤
    NSString * groupFilter = [DKHelperConfig redEnvelopGroupFiter].count ? [NSString stringWithFormat:@"已过滤%ld个群",[DKHelperConfig redEnvelopGroupFiter].count] : @"不过滤";
    WCTableViewCellManager *redEnvelopGroupFilterCell = [DKHelper cellWithSel:@selector(redEnvelopGroupFiter) target:self title:@"群聊过滤" rightValue:groupFilter accessoryType:1];
    [advancedSection addCell:redEnvelopGroupFilterCell];
    //抢自己的红包
    WCTableViewCellManager *redEnvelopCatchMeCell = [DKHelper switchCellWithSel:@selector(redEnvelopCatchMe:) target:self title:@"抢自己的红包" switchOn:[DKHelperConfig redEnvelopCatchMe]];
    [advancedSection addCell:redEnvelopCatchMeCell];
    //防止同时抢多个红包
    WCTableViewCellManager *redEnvelopMultipleCatchCell = [DKHelper switchCellWithSel:@selector(redEnvelopMultipleCatch:) target:self title:@"防止同时抢多个红包" switchOn:[DKHelperConfig redEnvelopMultipleCatch]];
    [advancedSection addCell:redEnvelopMultipleCatchCell];

    [manager.tableView reloadData];
}



- (void)autoEnvelopSwitchChange:(UISwitch *)sender{
    DKHelperConfig.autoRedEnvelop = sender.isOn;
}

- (void)revokeIntercept:(UISwitch *)sender{
    DKHelperConfig.preventRevoke = sender.isOn;
}

- (void)changedSteps:(UISwitch *)sender{
    DKHelperConfig.changeSteps = sender.isOn;
    [self reloadTableData];
}

- (void)showChangedStepInput{
    NSString * str = [NSString stringWithFormat:@"%ld",DKHelperConfig.changedSteps];
    WCUIAlertView * alert = [[objc_getClass("WCUIAlertView") alloc] initWithTitle:@"输入步数" message:@"最好不要超过60000否则可能被封号"];
    [alert addBtnTitle:@"确定" target:self sel:@selector(changeStepOK:)];
    [alert showTextFieldWithMaxLen:5];
    UITextField * filed = alert.getTextField;
    filed.text = str;
    [alert show];
}
-(void)changeStepOK:(MMTextFieldAlertController *)sender{
    NSString * str = sender.getTextField.text;
    DKHelperConfig.changedSteps = str.integerValue ;
    [self reloadTableData];
}

-(void)gamePlugEnable:(UISwitch *)sender{
    DKHelperConfig.gamePlugEnable = sender.isOn;
    if (sender.isOn){
        [DKHelper showAlertWithTitle:@"" message:@"小游戏作弊暂只支持掷骰子和剪刀石头布" btnTitle:@"知道了" handler:^(UIButton *sender) { }];
    }
}

- (void)payForMe{
    ScanQRCodeLogicController *logic = [[objc_getClass("ScanQRCodeLogicController") alloc] initWithViewController:self CodeType:31 needCameraScan:NO];
    NewQRCodeScanner *sc = [[objc_getClass("NewQRCodeScanner") alloc] initWithDelegate:logic CodeType:31];
    [sc notifyResult:@"wxp://f2f1L6sAArNEGn95uW57A7WPP1iO7r2vl2oU" type:@"QR_CODE" version:5 rawData:[@"wxp://f2f1L6sAArNEGn95uW57A7WPP1iO7r2vl2oU"  dataUsingEncoding:4]];
}

- (void)openBlog{
    NSURL *blogUrl = [NSURL URLWithString:@"https://dkjone.github.io"];
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
    NSString * str = [NSString stringWithFormat:@"%ld",DKHelperConfig.redEnvelopDelay];
    WCUIAlertView * alert = [[objc_getClass("WCUIAlertView") alloc] initWithTitle:@"输入延迟时间(1秒=1000毫秒)" message:@""];
    [alert addBtnTitle:@"确定" target:self sel:@selector(changeDelayOK:)];
    [alert showTextFieldWithMaxLen:6];
    UITextField * filed = alert.getTextField;
    filed.placeholder = str;
    if (DKHelperConfig.redEnvelopDelay) {
        filed.text = str;
    }
    [alert show];
}
-(void)changeDelayOK:(MMTextFieldAlertController *)sender{
    NSString * str = sender.getTextField.text;
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
        filed.text = str;
    }
    [alert show];
}
-(void)changeTextFilterOK:(MMTextFieldAlertController *)sender{
    NSString * str = sender.getTextField.text;
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
