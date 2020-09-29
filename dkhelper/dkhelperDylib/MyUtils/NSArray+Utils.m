//  NSArray+Utils.m
//  dkhelperDylib
//  Created by DKJone on 2020/9/27
//  Copyright © 2020 DKJone. All rights reserved.
//
//
//                    ██████╗ ██╗  ██╗     ██╗ ██████╗ ███╗   ██╗███████╗
//                    ██╔══██╗██║ ██╔╝     ██║██╔═══██╗████╗  ██║██╔════╝
//                    ██║  ██║█████╔╝      ██║██║   ██║██╔██╗ ██║█████╗
//                    ██║  ██║██╔═██╗ ██   ██║██║   ██║██║╚██╗██║██╔══╝
//                    ██████╔╝██║  ██╗╚█████╔╝╚██████╔╝██║ ╚████║███████╗
//                    ╚═════╝ ╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝
//
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)
- (NSArray *)_map:(id(^)(id))hanlde {
    if (!hanlde || !self) return self;

    NSMutableArray *arr = NSMutableArray.array;
    for (id obj in self) {
        id new = hanlde(obj);
        [arr addObject:new];
    }
    return arr.copy;
}

- (NSArray *)_filter:(BOOL(^)(id))handle {
    if (!handle || !self) return self;

    NSMutableArray *arr = NSMutableArray.array;
    for (id obj in self) {
        if (handle(obj)) {
            [arr addObject:obj];
        }
    }
    return arr.copy;
}

- (BOOL)_contains:(BOOL(^)(id))handle {
    if (!handle || !self) return self;
    for (id obj in self) {
        if (handle(obj)) {
            return true;
        }
    }
    return false;
}


@end
