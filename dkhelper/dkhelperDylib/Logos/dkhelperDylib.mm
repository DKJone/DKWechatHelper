#line 1 "/mycode/github/DKWechatHelper/dkhelper/dkhelperDylib/Logos/dkhelperDylib.xm"
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

@class WCTableViewNormalCellManager; @class UIViewController; @class NewSettingViewController; 
static void (*_logos_orig$_ungrouped$NewSettingViewController$reloadTableData)(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$NewSettingViewController$reloadTableData(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$NewSettingViewController$setting(_LOGOS_SELF_TYPE_NORMAL NewSettingViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$UIViewController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$UIViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST, SEL, BOOL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WCTableViewNormalCellManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WCTableViewNormalCellManager"); } return _klass; }
#line 6 "/mycode/github/DKWechatHelper/dkhelper/dkhelperDylib/Logos/dkhelperDylib.xm"

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





static void _logos_method$_ungrouped$UIViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$_ungrouped$UIViewController$viewWillAppear$(self, _cmd, animated);
    NSLog(@"\n***********************************************\n\t%@ appear\n***********************************************\n",NSStringFromClass([(NSObject*)self class]));
}



static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$NewSettingViewController = objc_getClass("NewSettingViewController"); MSHookMessageEx(_logos_class$_ungrouped$NewSettingViewController, @selector(reloadTableData), (IMP)&_logos_method$_ungrouped$NewSettingViewController$reloadTableData, (IMP*)&_logos_orig$_ungrouped$NewSettingViewController$reloadTableData);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$NewSettingViewController, @selector(setting), (IMP)&_logos_method$_ungrouped$NewSettingViewController$setting, _typeEncoding); }Class _logos_class$_ungrouped$UIViewController = objc_getClass("UIViewController"); MSHookMessageEx(_logos_class$_ungrouped$UIViewController, @selector(viewWillAppear:), (IMP)&_logos_method$_ungrouped$UIViewController$viewWillAppear$, (IMP*)&_logos_orig$_ungrouped$UIViewController$viewWillAppear$);} }
#line 33 "/mycode/github/DKWechatHelper/dkhelper/dkhelperDylib/Logos/dkhelperDylib.xm"
