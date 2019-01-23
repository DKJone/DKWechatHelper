#import <UIKit/UIKit.h>
#import "DKHelper.h"
#import "DKHelperSettingController.h"


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


%hook UIViewController
- (void)viewWillAppear:(BOOL)animated{
    %orig;
    NSLog(@"\n***********************************************\n\t%@ appear\n***********************************************\n",NSStringFromClass([(NSObject*)self class]));
}

%end

