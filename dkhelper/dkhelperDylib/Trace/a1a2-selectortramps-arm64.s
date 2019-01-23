/*
 * a1a2-selectortramps-arm64.s
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

#if __arm64__

#include <mach/vm_param.h>

.text

	.private_extern __a1a2_selectorTrampHead
	.private_extern __a1a2_firstSelectorTramp
	.private_extern __a1a2_selectorTrampEnd

msgSend:
    .quad 0

.align PAGE_MAX_SHIFT
__a1a2_selectorTrampHead:
L_a1a2_selectorTrampHead:
    // 1. selector
	ldr  x1, [x17]      // selector -> _cmd
    // 2. msgSend
    adr  x17, L_a1a2_selectorTrampHead
    sub  x17, x17, #PAGE_MAX_SIZE
    ldr  x16, [x17]
    br   x16            // tail call msgSend

	// pad up to TrampolineSelectorPagePair header size
	nop
	nop
	nop
	
.macro TrampolineEntry
	// load address of trampoline data (one page before this instruction)
	adr  x17, -PAGE_MAX_SIZE
	b    L_a1a2_selectorTrampHead
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
	
.align 3
.private_extern __a1a2_firstSelectorTramp
__a1a2_firstSelectorTramp:
	// 2048-4 trampolines to fill 16K page
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

	// TrampolineEntry
	// TrampolineEntry
	// TrampolineEntry
	// TrampolineEntry
	
.private_extern __a1a2_selectorTrampEnd
__a1a2_selectorTrampEnd:

#endif
