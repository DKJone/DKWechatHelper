/*
 * a1a2-selectortramps-arm.s
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

	.private_extern __a1a2_selectorTrampHead
	.private_extern __a1a2_firstSelectorTramp
	.private_extern __a1a2_selectorTrampEnd

// Trampoline machinery assumes the trampolines are Thumb function pointers
#if !__thumb2__
#   error sorry
#endif

.thumb
.thumb_func __a1a2_selectorTrampHead
.thumb_func __a1a2_firstSelectorTramp
.thumb_func __a1a2_selectorTrampEnd

.align PAGE_MAX_SHIFT
__a1a2_selectorTrampHead:
	// Trampoline's data is one page before the trampoline text.
	// Also correct PC bias of 4 bytes.
    // 1. selector
	sub  r12, #PAGE_MAX_SIZE
	ldr  r1, [r12, #-4]     // selector -> _cmd
    // 2. msgSend
    mov  r12, pc
    sub  r12, #PAGE_MAX_SIZE
    ldr  pc, [r12, #-12]    // tail call msgSend
	// not reached
    nop

	// Align trampolines to 8 bytes
.align 3
	
.macro TrampolineEntry
	mov r12, pc
	b __a1a2_selectorTrampHead
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

.private_extern __a1a2_firstSelectorTramp
__a1a2_firstSelectorTramp:
	// 2048-3 trampolines to fill 16K page
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

.private_extern __a1a2_selectorTrampEnd
__a1a2_selectorTrampEnd:

#endif
