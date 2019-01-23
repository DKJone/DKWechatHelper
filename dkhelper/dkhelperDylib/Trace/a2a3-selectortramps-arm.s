/*
 * a2a3-selectortramps-arm.s
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

#if __arm__
	
#include <arm/arch.h>
#include <mach/vm_param.h>

.syntax unified

.text

	.private_extern __a2a3_selectorTrampHead
	.private_extern __a2a3_firstSelectorTramp
	.private_extern __a2a3_selectorTrampEnd

// Trampoline machinery assumes the trampolines are Thumb function pointers
#if !__thumb2__
#   error sorry
#endif

.thumb
.thumb_func __a2a3_selectorTrampHead
.thumb_func __a2a3_firstSelectorTramp
.thumb_func __a2a3_selectorTrampEnd

.align PAGE_MAX_SHIFT
__a2a3_selectorTrampHead:
    // Trampoline's data is one page before the trampoline text.
    // Also correct PC bias of 4 bytes.
    // 1. selector
    sub  r12, #PAGE_MAX_SIZE
    ldr  r2, [r12, #-4]          // _cmd = selector
    // 2. msgSend. Can't "ldr  r12, msgSend", error: out of range pc-relative fixup value
    mov  r12, pc
    sub  r12, #PAGE_MAX_SIZE
    ldr  pc, [r12, #-12]
    // not reached
    nop

	// Align trampolines to 8 bytes
.align 3
	
.macro TrampolineEntry
	mov r12, pc
	b __a2a3_selectorTrampHead
.align 3
.endmacro

.macro TrampolineEntryX16
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
.endmacro

.macro TrampolineEntryX256
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
.endmacro

.private_extern __a2a3_firstSelectorTramp
__a2a3_firstSelectorTramp:
	// 2048-2 trampolines to fill 16K page
	TrampolineEntryX256
	TrampolineEntryX256
	TrampolineEntryX256
	TrampolineEntryX256

	TrampolineEntryX256
	TrampolineEntryX256
	TrampolineEntryX256

	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16

	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16

	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16

	TrampolineEntryX16
	TrampolineEntryX16
	TrampolineEntryX16

	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry

	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry

	TrampolineEntry
	TrampolineEntry
	TrampolineEntry
	TrampolineEntry

	TrampolineEntry
	// TrampolineEntry
	// TrampolineEntry
	// TrampolineEntry

.private_extern __a2a3_selectorTrampEnd
__a2a3_selectorTrampEnd:

#endif
