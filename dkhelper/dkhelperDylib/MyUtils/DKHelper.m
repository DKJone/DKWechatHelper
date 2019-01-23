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

    UITabBarController * tabbarVC =  (UITabBarController *)UIApplication.sharedApplication.keyWindow.rootViewController;
    NSArray<UINavigationController *> *vcs = tabbarVC.childViewControllers;
    
    return vcs[tabbarVC.selectedIndex];
}

+ (UIBarButtonItem *)leftNavigationItem{

    UINavigationController * navc =  [DKHelper navigationContrioller];
    if (navc.viewControllers.count > 1){
        return  ((UIViewController *)navc.viewControllers[1]).navigationItem.leftBarButtonItem;
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


