//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MDConfigManager.h
//  MonkeyDev
//
//  Created by AloneMonkey on 2018/4/24.
//  Copyright © 2018年 AloneMonkey. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MDCONFIG_CYCRIPT_KEY                @"Cycript"
#define MDCONFIG_LOADATLAUNCH_KEY           @"LoadAtLaunch"

#define MDCONFIG_TRACE_KEY                  @"MethodTrace"
#define MDCONFIG_LOG_LEVEL_KEY              @"LogLevel"
#define MDCONFIG_LOG_WHEN_KEY               @"LogWhen"
#define MDCONFIG_LOG_REGEX_STRING_KEY       @"LogRegexString"   // 仅LogWhen=MDTraceLogWhenRegexString有效
#define MDCONFIG_TRACE_FLAG_KEY             @"TraceFlag"
#define MDCONFIG_TRACE_OBJECT_KEY           @"TraceObject"
#define MDCONFIG_CLASS_REGEX_STRING_KEY     @"ClassRegexString" // 仅TraceObject=MDTraceObjectRegexClass有效
#define MDCONFIG_CORE_CLASS_LIST            @"CORE_CLASS_LIST"
#define MDCONFIG_USER_CLASS_LIST            @"USER_CLASS_LIST"
#define MDCONFIG_TRACE_MODE_KEY             @"TraceMode"
#define MDCONFIG_METHOD_WHITE_LIST_KEY      @"MethodWhiteList"
#define MDCONFIG_METHOD_BLACK_LIST_KEY      @"MethodBlackList"

// Trace日志级别
typedef NS_ENUM(NSUInteger, MDTraceLogLevel) {
    MDTraceLogLeveError         = 0,    // 错误
    MDTraceLogLeveDebug         = 1,    // 调试
    MDTraceLogLeveMax
};

// Trace日志输出时机
typedef NS_ENUM(NSUInteger, MDTraceLogWhen) {
    MDTraceLogWhenStartup       = 0,    // 启动即输出日志
    MDTraceLogWhenVolume        = 1,    // 根据音量键控制输出日志(增加音量:输出日志;降低音量:关闭日志;默认时关闭日志)
    MDTraceLogWhenRegexString   = 2,    // 日志包含指定正则字符串才输出日志
    MDTraceLogWhenMax
};

// Trace控制位(尽量在该处扩展)
typedef NS_OPTIONS(NSUInteger, MDTraceFlag) {
    MDTraceFlagDoesNotUseDescription    = 1 << 0,   // 跳过调用对象description方法，避免不正规的description实现导致递归
    MDTraceFlagDumpClassListInfo        = 1 << 1,   // 打印类列表信息，便于调试
    MDTraceFlagDumpClassMethod          = 1 << 2,   // 打印某个类的方法(不包括父类方法)，便于调试
    MDTraceFlagDumpSuperClassMethod     = 1 << 3,   // 打印某个类的父类方法(包括递归父类的方法)，便于调试
    MDTraceFlagMask                     = 0xF,
    
    MDTraceFlagDefault                  = 0,
};

// Trace对象
typedef NS_ENUM(NSUInteger, MDTraceObject) {
    // 屏蔽trace所有类
    MDTraceObjectNone           = 0,
    // trace引擎指定类的方法(仅测试验证使用)，仅需要考虑CORE_CLASS_LIST
    MDTraceObjectCoreClass      = 1,
    // trace用户指定类的方法，需要考虑USER_CLASS_LIST + "USER_CLASS_LIST和CORE_CLASS_LIST交集"
    MDTraceObjectUserClass      = 2,
    // trace用户指定类 + 正则匹配类的方法，需要考虑USER_CLASS_LIST + "USER_CLASS_LIST和CORE_CLASS_LIST交集" +
    // "匹配ClassRegexString的CLASS_LIST和CORE_CLASS_LIST交集"
    MDTraceObjectRegexClass     = 3,
    
    MDTraceObjectMax
};

// Trace模式
typedef NS_ENUM(NSUInteger, MDTraceMode) {
    MDTraceModeOff              = 0,    // 屏蔽trace方法
    MDTraceModeAll              = 1,    // trace所有方法
    MDTraceModeIncludeWhiteList = 2,    // trace包含"白名单方法列表"的方法
    MDTraceModeExcludeBlackList = 3,    // trace排除"黑名单方法列表"的方法
    MDTraceModeMax
};

@interface MDConfigManager : NSObject

+ (instancetype)sharedInstance;

- (NSDictionary*)readConfigByKey:(NSString*) key;

@end
