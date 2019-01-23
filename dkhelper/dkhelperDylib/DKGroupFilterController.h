//
//  DKGroupFilterController.h
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/22.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKHelper.h"

NS_ASSUME_NONNULL_BEGIN


@protocol MultiSelectGroupsViewControllerDelegate <NSObject>
- (void)onMultiSelectGroupReturn:(NSArray *)arg1;

@optional
- (void)onMultiSelectGroupCancel;
@end

@interface DKGroupFilterController : UIViewController
- (instancetype)initWithBlackList:(NSArray *)blackList;
@property (nonatomic, assign) id<MultiSelectGroupsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
