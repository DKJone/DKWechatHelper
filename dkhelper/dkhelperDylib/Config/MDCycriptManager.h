//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MDCycriptManager.h
//  MonkeyDev
//
//  Created by AloneMonkey on 2018/3/8.
//  Copyright © 2018年 AloneMonkey. All rights reserved.
//

#ifndef __OPTIMIZE__

#import <Foundation/Foundation.h>

#define PORT            6666

@interface MDCycriptManager : NSObject

+ (instancetype)sharedInstance;


/**
 Download script by config.plist

 @param update Force update of all scripts
 */
-(void)loadCycript:(BOOL) update;

/**
 eval javascript by cycript

 @param cycript javascript string
 @param error error happened
 @return eval result
 */
-(NSString*)evaluateCycript:(NSString*) cycript error:(NSError **) error;

@end

#endif