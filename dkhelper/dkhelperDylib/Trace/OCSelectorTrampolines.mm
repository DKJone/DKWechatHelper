/*
 * OCSelectorTrampolines.mm
 * OCMethodTrace
 *
 * https://github.com/omxcodec/OCMethodTrace.git
 *
 * Copyright (C) 2018 Michael Chen <omxcodec@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "OCSelectorTrampolines.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <mach/mach.h>
#import <pthread.h>

// Define SUPPORT_STRET on architectures that need separate struct-return ABI.
#if defined(__arm64__)
#   define SUPPORT_STRET 0
#else
#   define SUPPORT_STRET 1
#endif

#define _ost_fatal(fmt, ...) [NSException raise:@"OCSelectorTrampolines" format:fmt, ##__VA_ARGS__]

// symbols defined in assembly files
// Don't use the symbols directly; they're thumb-biased on some ARM archs.
#define TRAMP(tramp)                                \
    static inline __unused uintptr_t tramp(void) {  \
        extern void *_##tramp;                      \
        return ((uintptr_t)&_##tramp) & ~1UL;       \
    }
// Scalar return
TRAMP(a1a2_selectorTrampHead);   // trampoline header code
TRAMP(a1a2_firstSelectorTramp);  // first trampoline
TRAMP(a1a2_selectorTrampEnd);    // after the last trampoline

#if SUPPORT_STRET
// Struct return
TRAMP(a2a3_selectorTrampHead);
TRAMP(a2a3_firstSelectorTramp);
TRAMP(a2a3_selectorTrampEnd);
#endif

// argument mode identifier
typedef enum {
    ReturnValueInRegisterArgumentMode,
#if SUPPORT_STRET
    ReturnValueOnStackArgumentMode,
#endif
    
    ArgumentModeCount
} ArgumentMode;


// We must take care with our data layout on architectures that support 
// multiple page sizes.
// 
// The trampoline template in __TEXT is sized and aligned with PAGE_MAX_SIZE.
// On some platforms this requires additional linker flags.
// 
// When we allocate a page pair, we use PAGE_MAX_SIZE size. 
// This allows trampoline code to find its data by subtracting PAGE_MAX_SIZE.
// 
// When we allocate a page pair, we use the process's page alignment. 
// This simplifies allocation because we don't need to force greater than 
// default alignment when running with small pages, but it also means 
// the trampoline code MUST NOT look for its data by masking with PAGE_MAX_MASK.

struct TrampolineSelectorPagePair
{
    IMP msgSend; // msg send hander
    
    TrampolineSelectorPagePair *nextPagePair; // linked list of all pages
    TrampolineSelectorPagePair *nextAvailablePage; // linked list of pages with available slots
    
    uintptr_t nextAvailable; // index of next available slot, endIndex() if no more available
    
    // Payload data: selector and free list.
    // Bytes parallel with trampoline header code are the fields above or unused
    // uint8_t selectors[ PAGE_MAX_SIZE - sizeof(TrampolineSelectorPagePair) ]
    
    // Code: trampoline header followed by trampolines.
    // uint8_t trampolines[PAGE_MAX_SIZE];
    
    // Per-trampoline selector data format:
    // initial value is 0 while page data is filled sequentially 
    // when filled, value is reference to selector
    // when empty, value is index of next available slot OR 0 if never used yet
    
    union Payload {
        SEL selector;
        uintptr_t nextAvailable;  // free list
    };
    
    static uintptr_t headerSize() {
        return (uintptr_t) (a1a2_firstSelectorTramp() - a1a2_selectorTrampHead());
    }
    
    static uintptr_t slotSize() {
        return 8;
    }

    static uintptr_t startIndex() {
        // headerSize is assumed to be slot-aligned
        return headerSize() / slotSize();
    }

    static uintptr_t endIndex() {
        return (uintptr_t)PAGE_MAX_SIZE / slotSize();
    }

    static bool validIndex(uintptr_t index) {
        return (index >= startIndex() && index < endIndex());
    }

    Payload *payload(uintptr_t index) {
        assert(validIndex(index));
        return (Payload *)((char *)this + index*slotSize());
    }

    IMP trampoline(uintptr_t index) {
        assert(validIndex(index));
        char *imp = (char *)this + index*slotSize() + PAGE_MAX_SIZE;
#if __arm__
        imp++;  // trampoline is Thumb instructions
#endif
        return (IMP)imp;
    }

    uintptr_t indexForTrampoline(IMP tramp) {
        uintptr_t tramp0 = (uintptr_t)this + PAGE_MAX_SIZE;
        uintptr_t start = tramp0 + headerSize();
        uintptr_t end = tramp0 + PAGE_MAX_SIZE;
        uintptr_t address = (uintptr_t)tramp;
        if (address >= start  &&  address < end) {
            return (uintptr_t)(address - tramp0) / slotSize();
        }
        return 0;
    }

    static void check() {
        assert(TrampolineSelectorPagePair::slotSize() == 8);
        assert(TrampolineSelectorPagePair::headerSize() >= sizeof(TrampolineSelectorPagePair));
        assert(TrampolineSelectorPagePair::headerSize() % TrampolineSelectorPagePair::slotSize() == 0);
        
        // _objc_inform("%p %p %p", a1a2_selectorTrampHead(), a1a2_firstSelectorTramp(),
        // a1a2_selectorTrampEnd());
        assert(a1a2_selectorTrampHead() % PAGE_SIZE == 0);  // not PAGE_MAX_SIZE
        assert(a1a2_selectorTrampHead() + PAGE_MAX_SIZE == a1a2_selectorTrampEnd());
#if SUPPORT_STRET
        // _objc_inform("%p %p %p", a2a3_selectorTrampHead(), a2a3_firstSelectorTramp(),
        // a2a3_selectorTrampEnd());
        assert(a2a3_selectorTrampHead() % PAGE_SIZE == 0);  // not PAGE_MAX_SIZE
        assert(a2a3_selectorTrampHead() + PAGE_MAX_SIZE == a2a3_selectorTrampEnd());
#endif
        
#if __arm__
        // make sure trampolines are Thumb
        extern void *_a1a2_firstSelectorTramp;
        extern void *_a2a3_firstSelectorTramp;
        assert(((uintptr_t)&_a1a2_firstSelectorTramp) % 2 == 1);
        assert(((uintptr_t)&_a2a3_firstSelectorTramp) % 2 == 1);
#endif
    }

};

// two sets of trampoline pages; one for stack returns and one for register returns
static TrampolineSelectorPagePair *headPagePairs[ArgumentModeCount];

#pragma mark Utility Functions

static pthread_rwlock_t trampolinesLock = PTHREAD_RWLOCK_INITIALIZER;

static inline void _lock() {
    int err = pthread_rwlock_wrlock(&trampolinesLock);
    if (err) _ost_fatal(@"pthread_rwlock_wrlock failed (%d)", err);
}

static inline void _unlock() {
    int err = pthread_rwlock_unlock(&trampolinesLock);
    if (err) _ost_fatal(@"pthread_rwlock_unlock failed (%d)", err);
}

static inline void _assert_locked() {
}

#pragma mark Trampoline Management Functions
static TrampolineSelectorPagePair *_allocateTrampolinesAndData(ArgumentMode aMode)
{
    _assert_locked();

    vm_address_t dataAddress;
    
    TrampolineSelectorPagePair::check();

    TrampolineSelectorPagePair *headPagePair = headPagePairs[aMode];
    
    assert(headPagePair == nil  ||  headPagePair->nextAvailablePage == nil);
    
    kern_return_t result;
    result = vm_allocate(mach_task_self(), &dataAddress, PAGE_MAX_SIZE * 2,
                         VM_FLAGS_ANYWHERE | VM_MAKE_TAG(VM_MEMORY_FOUNDATION));
    if (result != KERN_SUCCESS) {
        _ost_fatal(@"vm_allocate trampolines failed (%d)", result);
    }

    vm_address_t codeAddress = dataAddress + PAGE_MAX_SIZE;
        
    uintptr_t codePage = NULL;
    IMP sendImp = NULL;
    switch(aMode) {
    case ReturnValueInRegisterArgumentMode:
        codePage = a1a2_selectorTrampHead();
        sendImp = objc_msgSend;
        break;
#if SUPPORT_STRET
    case ReturnValueOnStackArgumentMode:
        codePage = a2a3_selectorTrampHead();
        sendImp = objc_msgSend_stret;
        break;
#endif
    default:
        _ost_fatal(@"unknown return mode %d", (int)aMode);
        break;
    }
    
    vm_prot_t currentProtection, maxProtection;
    result = vm_remap(mach_task_self(), &codeAddress, PAGE_MAX_SIZE, 
                      0, VM_FLAGS_FIXED | VM_FLAGS_OVERWRITE,
                      mach_task_self(), codePage, TRUE, 
                      &currentProtection, &maxProtection, VM_INHERIT_SHARE);
    if (result != KERN_SUCCESS) {
        // vm_deallocate(mach_task_self(), dataAddress, PAGE_MAX_SIZE * 2);
        _ost_fatal(@"vm_remap trampolines failed (%d)", result);
    }
    
    TrampolineSelectorPagePair *pagePair = (TrampolineSelectorPagePair *) dataAddress;
    pagePair->nextAvailable = pagePair->startIndex();
    pagePair->nextPagePair = nil;
    pagePair->nextAvailablePage = nil;
    pagePair->msgSend = sendImp;
    
    if (headPagePair) {
        TrampolineSelectorPagePair *lastPagePair = headPagePair;
        while(lastPagePair->nextPagePair) {
            lastPagePair = lastPagePair->nextPagePair;
        }
        lastPagePair->nextPagePair = pagePair;
        headPagePairs[aMode]->nextAvailablePage = pagePair;
    } else {
        headPagePairs[aMode] = pagePair;
    }
    
    return pagePair;
}

static TrampolineSelectorPagePair *
_getOrAllocatePagePairWithNextAvailable(ArgumentMode aMode) 
{
    _assert_locked();
    
    TrampolineSelectorPagePair *headPagePair = headPagePairs[aMode];

    if (!headPagePair)
        return _allocateTrampolinesAndData(aMode);
    
    // make sure head page is filled first
    if (headPagePair->nextAvailable != headPagePair->endIndex())
        return headPagePair;
    
    if (headPagePair->nextAvailablePage) // check if there is a page w/a hole
        return headPagePair->nextAvailablePage;
    
    return _allocateTrampolinesAndData(aMode); // tack on a new one
}

static TrampolineSelectorPagePair *
_pageAndIndexContainingIMP(IMP anImp, uintptr_t *outIndex, 
                           TrampolineSelectorPagePair **outHeadPagePair)
{
    _assert_locked();

    for (int arg = 0; arg < ArgumentModeCount; arg++) {
        for (TrampolineSelectorPagePair *pagePair = headPagePairs[arg];
             pagePair;
             pagePair = pagePair->nextPagePair)
        {
            uintptr_t index = pagePair->indexForTrampoline(anImp);
            if (index) {
                if (outIndex) *outIndex = index;
                if (outHeadPagePair) *outHeadPagePair = headPagePairs[arg];
                return pagePair;
            }
        }
    }
    
    return nil;
}

static ArgumentMode 
_argumentModeForSignature(const char *signature)
{
    ArgumentMode aMode = ReturnValueInRegisterArgumentMode;

#if SUPPORT_STRET
    if (signature && signature[0] == '{') {
        @try {
            // In some cases that returns struct, we should use the '_stret' API:
            // http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
            // NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
            NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:signature];
            if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
                aMode = ReturnValueOnStackArgumentMode;
            }
        } @catch (__unused NSException *e) {}
    }
#endif
    
    return aMode;
}

#pragma mark Public API
IMP imp_implementationWithSelector(SEL aSel, const char *signature)
{
    IMP returnIMP;
    
    _lock();
    
    ArgumentMode aMode = _argumentModeForSignature(signature);
    
    TrampolineSelectorPagePair *pagePair =
    _getOrAllocatePagePairWithNextAvailable(aMode);
    if (!headPagePairs[aMode])
        headPagePairs[aMode] = pagePair;
    
    uintptr_t index = pagePair->nextAvailable;
    assert(index >= pagePair->startIndex()  &&  index < pagePair->endIndex());
    TrampolineSelectorPagePair::Payload *payload = pagePair->payload(index);
    
    uintptr_t nextAvailableIndex = payload->nextAvailable;
    if (nextAvailableIndex == 0) {
        // First time through (unused slots are zero). Fill sequentially.
        // If the page is now full this will now be endIndex(), handled below.
        nextAvailableIndex = index + 1;
    }
    pagePair->nextAvailable = nextAvailableIndex;
    if (nextAvailableIndex == pagePair->endIndex()) {
        // PagePair is now full (free list or wilderness exhausted)
        // Remove from available page linked list
        TrampolineSelectorPagePair *iterator = headPagePairs[aMode];
        while(iterator && (iterator->nextAvailablePage != pagePair)) {
            iterator = iterator->nextAvailablePage;
        }
        if (iterator) {
            iterator->nextAvailablePage = pagePair->nextAvailablePage;
            pagePair->nextAvailablePage = nil;
        }
    }
    
    payload->selector = aSel;
    returnIMP = pagePair->trampoline(index);
    
    _unlock();
    
    return returnIMP;
}

SEL imp_getSelector(IMP anImp) {
    uintptr_t index;
    TrampolineSelectorPagePair *pagePair;
    
    if (!anImp) return nil;
    
    _lock();
    
    pagePair = _pageAndIndexContainingIMP(anImp, &index, nil);
    
    if (!pagePair) {
        _unlock();
        return nil;
    }

    TrampolineSelectorPagePair::Payload *payload = pagePair->payload(index);
    
    if (payload->nextAvailable <= TrampolineSelectorPagePair::endIndex()) {
        // unallocated
        _unlock();
        return nil;
    }
    
    _unlock();
    
    return payload->selector;
}

BOOL imp_removeSelector(IMP anImp) {
    TrampolineSelectorPagePair *pagePair;
    TrampolineSelectorPagePair *headPagePair;
    uintptr_t index;
    
    if (!anImp) return NO;
    
    _lock();
    pagePair = _pageAndIndexContainingIMP(anImp, &index, &headPagePair);
    
    if (!pagePair) {
        _unlock();
        return NO;
    }

    TrampolineSelectorPagePair::Payload *payload = pagePair->payload(index);
    
    payload->nextAvailable = pagePair->nextAvailable;
    pagePair->nextAvailable = index;
    
    // make sure this page is on available linked list
    TrampolineSelectorPagePair *pagePairIterator = headPagePair;
    
    // see if page is the next available page for any existing pages
    while (pagePairIterator->nextAvailablePage && 
           pagePairIterator->nextAvailablePage != pagePair)
    {
        pagePairIterator = pagePairIterator->nextAvailablePage;
    }
    
    if (! pagePairIterator->nextAvailablePage) {
        // if iteration stopped because nextAvail was nil
        // add to end of list.
        pagePairIterator->nextAvailablePage = pagePair;
        pagePair->nextAvailablePage = nil;
    }
    
    _unlock();
    
    return YES;
}
