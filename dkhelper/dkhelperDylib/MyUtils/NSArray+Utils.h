//  NSArray+Utils.h
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

#import <Foundation/Foundation.h>



@interface NSArray (Utils)
- (NSArray *)_map:(id(^)(id))hanlde ;

- (NSArray *)_filter:(BOOL(^)(id obj))handle ;
- (BOOL)_contains:(BOOL(^)(id obj))handle;
@end


