//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  LLDBTools.m
//  MonkeyDev
//
//  Created by AloneMonkey on 2018/3/8.
//  Copyright © 2018年 AloneMonkey. All rights reserved.
//

#pragma GCC diagnostic ignored "-Wundeclared-selector"

#import "LLDBTools.h"
#import <set>
#import <mach/mach_types.h>
#import <malloc/malloc.h>
#import <objc/runtime.h>
#import <mach/mach_init.h>
#import <mach/mach_error.h>

enum {
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_HAS_STRET =         (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE =     (1 << 30),
};

struct Block_literal_1 {
    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor_1 {
        unsigned long int reserved; // NULL
        unsigned long int size;         // sizeof(struct Block_literal_1)
        // optional helper functions
        void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
        void (*dispose_helper)(void *src);             // IFF (1<<25)
        // required ABI.2010.3.16
        const char *signature;                         // IFF (1<<30)
    } *descriptor;
    // imported variables
};

NSString* decode(NSString* code);
NSArray* choose_inner(const char * classname);
char * protection_bits_to_rwx (vm_prot_t p);
const char * unparse_inheritance (vm_inherit_t i);
char * behavior_to_text (vm_behavior_t  b);

NSString* decode(NSString* code){
    NSDictionary * encodeMap = @{
                                 @"c": @"char",
                                 @"i": @"int",
                                 @"s": @"short",
                                 @"l": @"long",
                                 @"q": @"long long",
                                 
                                 @"C": @"unsigned char",
                                 @"I": @"unsigned int",
                                 @"S": @"unsigned short",
                                 @"L": @"unsigned long",
                                 @"Q": @"unsigned long long",
                                 
                                 @"f": @"float",
                                 @"d": @"double",
                                 @"B": @"bool",
                                 @"v": @"void",
                                 @"*": @"char *",
                                 @"@": @"id",
                                 @"#": @"Class",
                                 @":": @"SEL"
                                 };
    
    if(encodeMap[code]){
        return encodeMap[code];
    }else if([code characterAtIndex:0] == '@'){
        if([code characterAtIndex:1] == '?'){
            return code;
        }else if([code characterAtIndex:2] == '<'){
            return [NSString stringWithFormat:@"id%@", [[code substringWithRange:NSMakeRange(2, code.length-3)] stringByReplacingOccurrencesOfString:@"><" withString:@", "]];
        }else{
            return [NSString stringWithFormat:@"%@ *", [code substringWithRange:NSMakeRange(2, code.length-3)]];
        }
    }else if([code characterAtIndex:0] == '^'){
        return [NSString stringWithFormat:@"%@ *", decode([code substringFromIndex:1])];
    }
    return code;
}

NSString* pvc(){
    return [[[UIWindow performSelector:@selector(keyWindow)] performSelector:@selector(rootViewController)] performSelector:@selector(_printHierarchy)];
}

NSString* pviews(){
    return [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(recursiveDescription)];
}

NSString* pactions(vm_address_t address){
    NSMutableString* result = [NSMutableString new];
    UIControl* control = (__bridge UIControl*)(void*)address;
    NSArray* targets = [[control allTargets] allObjects];
    for (id item in targets) {
        NSArray* actions = [control actionsForTarget:item forControlEvent:0];
        [result appendFormat:@"<%s: 0x%lx>: %@\n", object_getClassName(item), (unsigned long)item, [actions componentsJoinedByString:@","]];
    }
    return result;
}

NSString* pblock(vm_address_t address){
    struct Block_literal_1 real = *((struct Block_literal_1 *)(void*)address);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithLong:(long)real.invoke] forKey:@"invoke"];
    if (real.flags & BLOCK_HAS_SIGNATURE) {
        char *signature;
        if (real.flags & BLOCK_HAS_COPY_DISPOSE) {
            signature = (char *)(real.descriptor)->signature;
        } else {
            signature = (char *)(real.descriptor)->copy_helper;
        }
        
        NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:signature];
        NSMutableArray *types = [NSMutableArray array];
        
        [types addObject:[NSString stringWithUTF8String:(char *)[sig methodReturnType]]];
        
        for (NSUInteger i = 0; i < sig.numberOfArguments; i++) {
            char *type = (char *)[sig getArgumentTypeAtIndex:i];
            [types addObject:[NSString stringWithUTF8String:type]];
        }
        
        [dict setObject:types forKey:@"signature"];
    }
    
    NSMutableArray* sigArr = dict[@"signature"];
    
    if(!sigArr){
        return [NSString stringWithFormat:@"Imp: 0x%lx", [dict[@"invoke"] longValue]];
    }else{
        NSMutableString* sig = [NSMutableString stringWithFormat:@"%@ ^(", decode(sigArr[0])];
        for (int i = 2; i < sigArr.count; i++) {
            if(i == sigArr.count - 1){
                [sig appendFormat:@"%@", decode(sigArr[i])];
            }else{
                [sig appendFormat:@"%@ ,", decode(sigArr[i])];
            }
        }
        [sig appendString:@");"];
        return [NSString stringWithFormat:@"Imp: 0x%lx    Signature: %s", [dict[@"invoke"] longValue], [sig UTF8String]];
    }
}

struct CYChoice {
    std::set<Class> query_;
    std::set<id> results_;
};

struct CYObjectStruct {
    Class isa_;
};

static void choose_(task_t task, void *baton, unsigned type, vm_range_t *ranges, unsigned count) {
    CYChoice *choice(reinterpret_cast<CYChoice *>(baton));
    
    for (unsigned i(0); i != count; ++i) {
        vm_range_t &range(ranges[i]);
        void *data(reinterpret_cast<void *>(range.address));
        size_t size(range.size);
        
        if (size < sizeof(CYObjectStruct))
            continue;
        
        uintptr_t *pointers(reinterpret_cast<uintptr_t *>(data));
#ifdef __arm64__
        Class isa = (__bridge Class)((void *)(pointers[0] & 0x1fffffff8));
#else
        Class isa =(__bridge Class)(void *)pointers[0];
#endif
        std::set<Class>::const_iterator result(choice->query_.find(isa));
        if (result == choice->query_.end())
            continue;
        
        size_t needed(class_getInstanceSize(*result));
        // XXX: if (size < needed)
        
        size_t boundary(496);
#ifdef __LP64__
        boundary *= 2;
#endif
        if ((needed <= boundary && (needed + 15) / 16 * 16 != size) || (needed > boundary && (needed + 511) / 512 * 512 != size))
            continue;
        choice->results_.insert((__bridge id)(data));
    }
}

static Class *CYCopyClassList(size_t &size) {
    size = objc_getClassList(NULL, 0);
    Class *data(reinterpret_cast<Class *>(malloc(sizeof(Class) * size)));
    
    for (;;) {
        size_t writ(objc_getClassList(data, (int)size));
        if (writ <= size) {
            size = writ;
            return data;
        }
        
        Class *copy(reinterpret_cast<Class *>(realloc(data, sizeof(Class) * writ)));
        if (copy == NULL) {
            free(data);
            return NULL;
        }
        
        data = copy;
        size = writ;
    }
}

static kern_return_t CYReadMemory(task_t task, vm_address_t address, vm_size_t size, void **data) {
    *data = reinterpret_cast<void *>(address);
    return KERN_SUCCESS;
}

NSArray* choose_inner(const char * classname){
    
    Class _class = NSClassFromString([NSString stringWithUTF8String:classname]);
    
    vm_address_t *zones = NULL;
    unsigned size = 0;
    //获取所有的zone信息  堆上的区域
    kern_return_t error = malloc_get_all_zones(mach_task_self(), &CYReadMemory, &zones, &size);
    assert(error == KERN_SUCCESS);
    
    size_t number;
    Class *classes(CYCopyClassList(number));
    assert(classes != NULL);
    
    CYChoice choice;
    
    //找到目标Class
    for (size_t i(0); i != number; ++i)
        for (Class current(classes[i]); current != Nil; current = class_getSuperclass(current))
            if (current == _class) {
                choice.query_.insert(classes[i]);
                break;
            }
    
    for (unsigned i(0); i != size; ++i) {
        const malloc_zone_t *zone(reinterpret_cast<const malloc_zone_t *>(zones[i]));
        if (zone == NULL || zone->introspect == NULL)
            continue;
        
        //枚举堆上的对象
        zone->introspect->enumerator(mach_task_self(), &choice, MALLOC_PTR_IN_USE_RANGE_TYPE, zones[i], &CYReadMemory, &choose_);
    }
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for (auto iter = choice.results_.begin(); iter != choice.results_.end(); iter++) {
        [result addObject:(id)*iter];
    }
    return result;
}

NSString* choose(const char* classname){
    NSMutableString* result = [NSMutableString new];
    NSArray* results = choose_inner(classname);
    [result appendFormat:@"Find %lu instance objects in memory!\n" , (unsigned long)results.count];
    for (id item in results) {
        [result appendFormat:@"<%s: 0x%llx>\n", object_getClassName(item), (long long)item];
    }
    return result;
}

NSString* methods(const char * classname){
    return [objc_getClass(classname) performSelector:@selector(_shortMethodDescription)];
}

NSString* ivars(vm_address_t address){
    id target = (__bridge id)(void*)address;
    return [target performSelector:@selector(_ivarDescription)];
}

char * protection_bits_to_rwx (vm_prot_t p){
    static char returned[4];
    
    returned[0] = (p & VM_PROT_READ    ? 'r' : '-');
    returned[1] = (p & VM_PROT_WRITE   ? 'w' : '-');
    returned[2] = (p & VM_PROT_EXECUTE ? 'x' : '-');
    returned[3] = '\0';
    
    // memory leak here. No biggy
    return (strdup(returned));
}

const char * unparse_inheritance (vm_inherit_t i){
    switch (i){
        case VM_INHERIT_SHARE:
            return "share";
        case VM_INHERIT_COPY:
            return "copy";
        case VM_INHERIT_NONE:
            return "none";
        default:
            return "???";
    }
}

char * behavior_to_text (vm_behavior_t  b){
    switch (b){
        case VM_BEHAVIOR_DEFAULT: return((char*)"default");
        case VM_BEHAVIOR_RANDOM:  return((char*)"random");
        case VM_BEHAVIOR_SEQUENTIAL: return((char*)"fwd-seq");
        case VM_BEHAVIOR_RSEQNTL: return((char*)"rev-seq");
        case VM_BEHAVIOR_WILLNEED: return((char*)"will-need");
        case VM_BEHAVIOR_DONTNEED: return((char*)"will-need");
        case VM_BEHAVIOR_FREE: return((char*)"free-nowb");
        case VM_BEHAVIOR_ZERO_WIRED_PAGES: return((char*)"zero-wire");
        case VM_BEHAVIOR_REUSABLE: return((char*)"reusable");
        case VM_BEHAVIOR_REUSE: return((char*)"reuse");
        case VM_BEHAVIOR_CAN_REUSE: return((char*)"canreuse");
        default: return ((char*)"?");
    }
}

__BEGIN_DECLS

extern kern_return_t mach_vm_region
(
 vm_map_t target_task,
 mach_vm_address_t *address,
 mach_vm_size_t *size,
 vm_region_flavor_t flavor,
 vm_region_info_t info,
 mach_msg_type_number_t *infoCnt,
 mach_port_t *object_name
 );

__END_DECLS

NSString* vmmap(){
    vm_region_basic_info_data_t info, prev_info;
    mach_vm_address_t address = 1, prev_address;
    mach_vm_size_t size, prev_size;
    mach_msg_type_number_t count = VM_REGION_BASIC_INFO_COUNT_64;
    mach_port_t object_name;
    
    int nsubregions = 0;
    kern_return_t kr = mach_vm_region(mach_task_self(), &address, &size, VM_REGION_BASIC_INFO, (vm_region_info_t)&info, &count, &object_name);
    
    NSMutableString* result = [[NSMutableString alloc] init];
    
    if(kr != KERN_SUCCESS){
        [result appendFormat:@"mach_vm_region: Error %d - %s", kr, mach_error_string(kr)];
        return [result copy];
    }
    
    //保存之前查到的info
    memcpy (&prev_info, &info, sizeof (vm_region_basic_info_data_t));
    prev_address = address;
    prev_size = size;
    nsubregions = 1;
    
    while (true) {
        int print = 0, done = 0;
        
        address = prev_address + prev_size;
        
        if (address == 0){
            print = done = 1;
        }
        
        if (!done){
            kr = mach_vm_region (mach_task_self(), &address, &size, VM_REGION_BASIC_INFO, (vm_region_info_t)&info, &count, &object_name);
            
            if (kr != KERN_SUCCESS){
                [result appendFormat:@"mach_vm_region failed for address %llu - Error: %x\n",address, (kr)];
                print = done = 1;
            }
        }
        
        //等于才是连续的内存，不等于才打印
        if (address != prev_address + prev_size)
            print = 1;
        
        //或者权限信息改变了也打印
        if ((info.protection != prev_info.protection)
            || (info.max_protection != prev_info.max_protection)
            || (info.inheritance != prev_info.inheritance)
            || (info.shared != prev_info.reserved)
            || (info.reserved != prev_info.reserved))
            print = 1;
        
        if (print){
            char *print_size_unit = NULL;
            
            mach_vm_size_t print_size = prev_size;
            if (print_size > 1024) { print_size /= 1024; print_size_unit = (char*)"K"; }
            if (print_size > 1024) { print_size /= 1024; print_size_unit = (char*)"M"; }
            if (print_size > 1024) { print_size /= 1024; print_size_unit = (char*)"G"; }
            
            [result appendFormat:@" %p-%p [%llu%s](%s/%s; %s, %s, %s) %s",
             (void*)(prev_address),
             (void*)(prev_address + prev_size),
             print_size,
             print_size_unit,
             protection_bits_to_rwx (prev_info.protection),
             protection_bits_to_rwx (prev_info.max_protection),
             unparse_inheritance (prev_info.inheritance),
             prev_info.shared ? "shared" : "private",
             prev_info.reserved ? "reserved" : "not-reserved",
             behavior_to_text (prev_info.behavior)];
            
            if (nsubregions > 1)
                [result appendFormat:@" (%d sub-regions)", nsubregions];
            
            [result appendFormat:@"\n"];
            prev_address = address;
            prev_size = size;
            memcpy (&prev_info, &info, sizeof (vm_region_basic_info_data_t));
            nsubregions = 1;
        }else{
            prev_size += size;
            nsubregions++;
        }
        
        if (done)
            break;
    }
    return [result copy];
}


