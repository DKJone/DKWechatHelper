//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MDCycriptManager.m
//  MonkeyDev
//
//  Created by AloneMonkey on 2018/3/8.
//  Copyright © 2018年 AloneMonkey. All rights reserved.
//

#ifndef __OPTIMIZE__

#import "MDCycriptManager.h"
#import "MDConfigManager.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <pthread.h>
#import <JavaScriptCore/JavaScriptCore.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#define MDLog(fmt, ...) NSLog((@"[Cycript] " fmt), ##__VA_ARGS__)

extern JSGlobalContextRef CYGetJSContext(void);
extern void CydgetMemoryParse(const uint16_t **data, size_t *size);

NSString * const CYErrorLineKey = @"CYErrorLineKey";
NSString * const CYErrorNameKey = @"CYErrorNameKey";
NSString * const CYErrorMessageKey = @"CYErrorMessageKey";

@interface MDSettingObject : NSObject

@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, assign) BOOL loadAtLaunch;

-(instancetype)initWithDicationary:(NSDictionary*) dictionary;

@end

@implementation MDSettingObject

-(instancetype)initWithDicationary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.priority = [dictionary[@"priority"] integerValue];
        self.url = dictionary[@"url"];
        self.content = dictionary[@"content"];
        self.loadAtLaunch = [dictionary objectForKey:MDCONFIG_LOADATLAUNCH_KEY] && [dictionary[MDCONFIG_LOADATLAUNCH_KEY] boolValue];
    }
    return self;
}

@end

@interface MDCycriptManager()

@property (nonatomic, strong) NSDictionary* configItem;
@property (nonatomic, copy) NSString* cycriptDirectory;
@property (nonatomic, strong) NSMutableArray* downloading;
@property (nonatomic, strong) NSMutableDictionary* loadAtLaunchModules;

@end

@implementation MDCycriptManager

+ (instancetype)sharedInstance{
    static MDCycriptManager *sharedInstance = nil;
    if (!sharedInstance){
        sharedInstance = [[MDCycriptManager alloc] init];
    }
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loadAtLaunchModules = [NSMutableDictionary dictionary];
        _downloading = [NSMutableArray array];
        [self check];
        [self readConfigFile];
    }
    return self;
}

-(void)check{
    NSString* ip = [self getIPAddress];
    if(ip != nil){
        printf("\nDownload cycript(https://cydia.saurik.com/api/latest/3) then run: ./cycript -r %s:%d\n\n", [ip UTF8String], PORT);
    }else{
        printf("\nPlease connect wifi before using cycript!\n\n");
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    _cycriptDirectory = [documentsPath stringByAppendingPathComponent:@"cycript"];
    [fileManager createDirectoryAtPath:_cycriptDirectory withIntermediateDirectories:YES attributes:nil error:nil];
}

-(NSArray*)sortedArray:(NSDictionary*) dictionary{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:10];
    
    NSArray* sortedArray = [dictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull number1, NSNumber*  _Nonnull number2) {
        if ([number1 integerValue] > [number2 integerValue])
            return NSOrderedDescending;
        return NSOrderedAscending;
    }];
    
    for (NSNumber* item in sortedArray) {
        [result addObject:dictionary[item]];
    }
    
    return [result copy];
}

-(void)readConfigFile{
    MDConfigManager * configManager = [MDConfigManager sharedInstance];
    _configItem = [configManager readConfigByKey:MDCONFIG_CYCRIPT_KEY];
}

-(void)loadCycript:(BOOL) update{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(_configItem && _configItem.count > 0){
        
        BOOL download = NO;
        
        for (NSString* moduleName in _configItem.allKeys) {
            MDSettingObject * item = [[MDSettingObject alloc] initWithDicationary:_configItem[moduleName]];
            NSString *fullPath = [[_cycriptDirectory stringByAppendingPathComponent:moduleName] stringByAppendingPathExtension:@"cy"];
            
            if(item.url){
                if(![fileManager fileExistsAtPath:fullPath] || update){
                    download = YES;
                    [self.downloading addObject:moduleName];
                    [self downLoadUrl:item.url saveName:moduleName];
                }
            }
            
            if(item.content){
                if(![fileManager fileExistsAtPath:fullPath] || update){
                    NSString* writeContent = [NSString stringWithFormat:@"(function(exports) { %@ })(exports);", item.content];
                    [writeContent writeToFile:fullPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }
            }
            
            if(item.loadAtLaunch){
                [_loadAtLaunchModules setObject:fullPath forKey:@(item.priority)];
            }
        }
        
        if(!download){
            [self finishDownload];
        }
    }
}

-(void)finishDownload{
    MDLog(@"Finish download all script!");
    NSArray* sortedArray = [self sortedArray:_loadAtLaunchModules];
    for (NSString* fullPath in sortedArray) {
        NSError* error;
        [self evaluateCycript:[NSString stringWithFormat:@"require('%@');",fullPath] error:&error];
        if(error.code != 0){
            MDLog(@"%@", error.localizedDescription);
        }
    }
}

-(void)downLoadUrl:(NSString*) urlString saveName:(NSString*) filename{
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            MDLog(@"Failed download script [%@]: %@", filename, error.localizedDescription);
        }else{
            NSString *fullPath = [[weakSelf.cycriptDirectory stringByAppendingPathComponent:filename] stringByAppendingPathExtension:@"cy"];
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
            
            MDLog(@"Successful download script [%@]", filename);
        }
        
        [weakSelf.downloading removeObject:filename];
        
        if(!weakSelf.downloading.count){
            [weakSelf finishDownload];
        }
    }];
    [downloadTask resume];
}

-(NSString *)evaluateCycript:(NSString *)cycript error:(NSError *__autoreleasing *)error{
    NSString *resultString = nil;
    
    static pthread_mutex_t cycript_metex = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_lock(&cycript_metex); {
        JSGlobalContextRef context = CYGetJSContext();
        
        size_t length = cycript.length;
        unichar *buffer = malloc(length * sizeof(unichar));
        [cycript getCharacters:buffer range:NSMakeRange(0, length)];
        const uint16_t *characters = buffer;
        CydgetMemoryParse(&characters, &length);
        JSStringRef expression = JSStringCreateWithCharacters(characters, length);
        
        // Evaluate the Javascript
        JSValueRef exception = NULL;
        JSValueRef result = JSEvaluateScript(context, expression, NULL, NULL, 0, &exception);
        JSStringRelease(expression);
        
        // If a result was returned, convert it into an NSString
        if (result) {
            JSStringRef string = JSValueToStringCopy(context, result, &exception);
            if (string) {
                resultString = (__bridge_transfer NSString *)JSStringCopyCFString(kCFAllocatorDefault, string);
                JSStringRelease(string);
            }
        }
        
        // If an exception was thrown, convert it into an NSError
        if (exception && error) {
            JSObjectRef exceptionObject = JSValueToObject(context, exception, NULL);
            
            NSInteger line = (NSInteger)JSValueToNumber(context, JSObjectGetProperty(context, exceptionObject, JSStringCreateWithUTF8CString("line"), NULL), NULL);
            JSStringRef string = JSValueToStringCopy(context, JSObjectGetProperty(context, exceptionObject, JSStringCreateWithUTF8CString("name"), NULL), NULL);
            NSString *name = (__bridge_transfer NSString *)JSStringCopyCFString(kCFAllocatorDefault, string);
            JSStringRelease(string);
            string = JSValueToStringCopy(context, JSObjectGetProperty(context, exceptionObject, JSStringCreateWithUTF8CString("message"), NULL), NULL);
            NSString *message = (__bridge_transfer NSString *)JSStringCopyCFString(kCFAllocatorDefault, string);
            JSStringRelease(string);
            string = JSValueToStringCopy(context, exception, NULL);
            NSString *description = (__bridge_transfer NSString *)JSStringCopyCFString(kCFAllocatorDefault, string);
            JSStringRelease(string);
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:@(line) forKey:CYErrorLineKey];
            [userInfo setValue:name forKey:CYErrorNameKey];
            [userInfo setValue:message forKey:CYErrorMessageKey];
            [userInfo setValue:description forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"CYContextDomain" code:0 userInfo:userInfo];
        }
    }pthread_mutex_unlock(&cycript_metex);
    
    return resultString;
}

- (NSString *)getIPAddress{
    
    NSDictionary *addresses = [self getIPAddresses];
    
    if([addresses.allKeys containsObject:IOS_WIFI @"/" IP_ADDR_IPv4]){
        return addresses[IOS_WIFI @"/" IP_ADDR_IPv4];
    }
    
    return nil;
}

- (NSDictionary *)getIPAddresses{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

@end

#endif
