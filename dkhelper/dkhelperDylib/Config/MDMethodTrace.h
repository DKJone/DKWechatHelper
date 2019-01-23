//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MDMethodTrace.h
//  MonkeyDev
//
//  Created by AloneMonkey on 2017/9/7.
//  Copyright © 2017年 AloneMonkey. All rights reserved.
//

#ifndef MethodTrace_h
#define MethodTrace_h

#define TRACE_README @"\n📚--------------------OCMethodTrace(Usage)-------------------📚\nhttps://github.com/omxcodec/OCMethodTrace/blob/master/README.md\n📚--------------------OCMethodTrace(Usage)-------------------📚"

#import <UIKit/UIKit.h>

@interface MDMethodTrace : NSObject

+ (instancetype)sharedInstance;

- (void)addClassTrace:(NSString *) className;

- (void)addClassTrace:(NSString *)className methodName:(NSString *)methodName;

- (void)addClassTrace:(NSString *)className methodList:(NSArray *)methodList;

@end

#endif /* MethodTrace_h */
