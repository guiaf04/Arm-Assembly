	.text
	.file	"main.c"
	.globl	main                            // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
	.cfi_startproc
// %bb.0:
	stp	x29, x30, [sp, #-32]!           // 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x28, x19, [sp, #16]             // 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 32
	.cfi_offset w19, -8
	.cfi_offset w28, -16
	.cfi_offset w30, -24
	.cfi_offset w29, -32
	sub	sp, sp, #384
	mov	x19, sp
	mov	w8, wzr
	str	w8, [x19, #12]                  // 4-byte Folded Spill
	stur	w8, [x29, #-116]
	adrp	x0, .L.str
	add	x0, x0, :lo12:.L.str
	bl	printf
	adrp	x0, .L.str.1
	add	x0, x0, :lo12:.L.str.1
	sub	x1, x29, #120
	bl	scanf
	ldr	w8, [x19, #12]                  // 4-byte Folded Reload
	adrp	x9, .L__const.main.pesos
	add	x9, x9, :lo12:.L__const.main.pesos
	ldr	q0, [x9]
	stur	q0, [x29, #-144]
	ldur	w9, [x29, #-120]
                                        // kill: def $x9 killed $w9
	mov	x10, sp
	stur	x10, [x29, #-152]
	mov	x10, sp
	sub	x10, x10, x9, uxtx #4
	mov	sp, x10
	str	x10, [x19, #16]                 // 8-byte Folded Spill
	stur	x9, [x29, #-160]
	ldur	w9, [x29, #-120]
                                        // kill: def $x9 killed $w9
	lsl	x10, x9, #2
	add	x10, x10, #15
	and	x11, x10, #0x7fffffff0
	mov	x10, sp
	subs	x10, x10, x11
	mov	sp, x10
	str	x10, [x19, #24]                 // 8-byte Folded Spill
	stur	x9, [x29, #-168]
	stur	w8, [x29, #-172]
	b	.LBB0_1
.LBB0_1:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB0_3 Depth 2
	ldur	w8, [x29, #-172]
	ldur	w9, [x29, #-120]
	subs	w8, w8, w9
	b.ge	.LBB0_8
	b	.LBB0_2
.LBB0_2:                                //   in Loop: Header=BB0_1 Depth=1
	ldur	w8, [x29, #-172]
	add	w1, w8, #1
	adrp	x0, .L.str.2
	add	x0, x0, :lo12:.L.str.2
	bl	printf
	mov	w8, wzr
	stur	w8, [x29, #-176]
	b	.LBB0_3
.LBB0_3:                                //   Parent Loop BB0_1 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldur	w8, [x29, #-176]
	subs	w8, w8, #3
	b.gt	.LBB0_6
	b	.LBB0_4
.LBB0_4:                                //   in Loop: Header=BB0_3 Depth=2
	ldr	x8, [x19, #16]                  // 8-byte Folded Reload
	ldursw	x9, [x29, #-172]
	add	x8, x8, x9, lsl #4
	ldursw	x9, [x29, #-176]
	add	x1, x8, x9, lsl #2
	adrp	x0, .L.str.3
	add	x0, x0, :lo12:.L.str.3
	bl	scanf
	b	.LBB0_5
.LBB0_5:                                //   in Loop: Header=BB0_3 Depth=2
	ldur	w8, [x29, #-176]
	add	w8, w8, #1
	stur	w8, [x29, #-176]
	b	.LBB0_3
.LBB0_6:                                //   in Loop: Header=BB0_1 Depth=1
	b	.LBB0_7
.LBB0_7:                                //   in Loop: Header=BB0_1 Depth=1
	ldur	w8, [x29, #-172]
	add	w8, w8, #1
	stur	w8, [x29, #-172]
	b	.LBB0_1
.LBB0_8:
	ldur	q0, [x29, #-144]
	str	q0, [x19, #176]
	ldr	q0, [x19, #176]
	str	q0, [x19, #160]
	ldr	q0, [x19, #160]
	str	q0, [x19, #192]
	mov	w8, wzr
	str	w8, [x19, #124]
	b	.LBB0_9
.LBB0_9:                                // =>This Inner Loop Header: Depth=1
	ldr	w8, [x19, #124]
	ldur	w9, [x29, #-120]
	subs	w8, w8, w9
	b.ge	.LBB0_12
	b	.LBB0_10
.LBB0_10:                               //   in Loop: Header=BB0_9 Depth=1
	ldr	x8, [x19, #24]                  // 8-byte Folded Reload
	ldr	x9, [x19, #16]                  // 8-byte Folded Reload
	ldrsw	x10, [x19, #124]
	ldr	q0, [x9, x10, lsl #4]
	str	q0, [x19, #96]
	ldr	q0, [x19, #96]
	str	q0, [x19, #80]
	ldr	q0, [x19, #80]
	str	q0, [x19, #144]
	ldr	q1, [x19, #192]
	ldr	q0, [x19, #144]
	stur	q1, [x29, #-80]
	stur	q0, [x29, #-96]
	ldur	q0, [x29, #-80]
	ldur	q1, [x29, #-96]
	fmul	v0.4s, v0.4s, v1.4s
	stur	q0, [x29, #-112]
	ldur	q0, [x29, #-112]
	str	q0, [x19, #128]
	ldr	q0, [x19, #128]
	stur	q0, [x29, #-16]
	ldur	q0, [x29, #-16]
	faddp	v0.4s, v0.4s, v0.4s
	fmov	x0, d0
	fmov	d0, x0
	faddp	s0, v0.2s
	stur	s0, [x29, #-20]
	ldur	s0, [x29, #-20]
	ldrsw	x9, [x19, #124]
	str	s0, [x8, x9, lsl #2]
	b	.LBB0_11
.LBB0_11:                               //   in Loop: Header=BB0_9 Depth=1
	ldr	w8, [x19, #124]
	add	w8, w8, #1
	str	w8, [x19, #124]
	b	.LBB0_9
.LBB0_12:
	mov	w8, wzr
	str	w8, [x19, #76]
	b	.LBB0_13
.LBB0_13:                               // =>This Inner Loop Header: Depth=1
	ldr	w8, [x19, #76]
	ldur	w9, [x29, #-120]
	subs	w8, w8, w9
	b.ge	.LBB0_16
	b	.LBB0_14
.LBB0_14:                               //   in Loop: Header=BB0_13 Depth=1
	ldr	x8, [x19, #24]                  // 8-byte Folded Reload
	ldrsw	x9, [x19, #76]
	mov	w10, w9
	add	w1, w10, #1
	ldr	s0, [x8, x9, lsl #2]
	fcvt	d0, s0
	adrp	x0, .L.str.4
	add	x0, x0, :lo12:.L.str.4
	bl	printf
	b	.LBB0_15
.LBB0_15:                               //   in Loop: Header=BB0_13 Depth=1
	ldr	w8, [x19, #76]
	add	w8, w8, #1
	str	w8, [x19, #76]
	b	.LBB0_13
.LBB0_16:
	mov	w8, wzr
	str	w8, [x19, #72]
	str	w8, [x19, #68]
	b	.LBB0_17
.LBB0_17:                               // =>This Inner Loop Header: Depth=1
	ldr	w8, [x19, #68]
	ldur	w9, [x29, #-120]
	subs	w8, w8, w9
	b.ge	.LBB0_20
	b	.LBB0_18
.LBB0_18:                               //   in Loop: Header=BB0_17 Depth=1
	ldr	x8, [x19, #24]                  // 8-byte Folded Reload
	ldrsw	x9, [x19, #68]
	lsl	x9, x9, #2
	ldr	q0, [x8, x9]
	str	q0, [x19, #48]
	ldr	q0, [x19, #48]
	str	q0, [x19, #32]
	ldr	q0, [x19, #32]
	str	q0, [x19, #144]
	ldr	q0, [x19, #144]
	stur	q0, [x29, #-48]
	ldur	q0, [x29, #-48]
	faddp	v0.4s, v0.4s, v0.4s
	fmov	x0, d0
	fmov	d0, x0
	faddp	s0, v0.2s
	stur	s0, [x29, #-52]
	ldur	s1, [x29, #-52]
	ldr	s0, [x19, #72]
	fadd	s0, s0, s1
	str	s0, [x19, #72]
	b	.LBB0_19
.LBB0_19:                               //   in Loop: Header=BB0_17 Depth=1
	ldr	w8, [x19, #68]
	add	w8, w8, #4
	str	w8, [x19, #68]
	b	.LBB0_17
.LBB0_20:
	ldur	s0, [x29, #-120]
	scvtf	s1, s0
	ldr	s0, [x19, #72]
	fdiv	s0, s0, s1
	str	s0, [x19, #72]
	ldr	s0, [x19, #72]
	fcvt	d0, s0
	adrp	x0, .L.str.5
	add	x0, x0, :lo12:.L.str.5
	bl	printf
	mov	w8, wzr
	stur	w8, [x29, #-116]
	ldur	x8, [x29, #-152]
	mov	sp, x8
	ldur	w0, [x29, #-116]
	mov	sp, x29
	.cfi_def_cfa wsp, 32
	ldp	x28, x19, [sp, #16]             // 16-byte Folded Reload
	ldp	x29, x30, [sp], #32             // 16-byte Folded Reload
	.cfi_def_cfa_offset 0
	.cfi_restore w19
	.cfi_restore w28
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        // -- End function
	.type	.L.str,@object                  // @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Digite o n\303\272mero de alunos: "
	.size	.L.str, 29

	.type	.L.str.1,@object                // @.str.1
.L.str.1:
	.asciz	"%d"
	.size	.L.str.1, 3

	.type	.L__const.main.pesos,@object    // @__const.main.pesos
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	2, 0x0
.L__const.main.pesos:
	.word	0x3e4ccccd                      // float 0.200000003
	.word	0x3e99999a                      // float 0.300000012
	.word	0x3e19999a                      // float 0.150000006
	.word	0x3eb33333                      // float 0.349999994
	.size	.L__const.main.pesos, 16

	.type	.L.str.2,@object                // @.str.2
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.2:
	.asciz	"Digite as notas do aluno %d: "
	.size	.L.str.2, 30

	.type	.L.str.3,@object                // @.str.3
.L.str.3:
	.asciz	"%f"
	.size	.L.str.3, 3

	.type	.L.str.4,@object                // @.str.4
.L.str.4:
	.asciz	"A m\303\251dia do aluno %d \303\251: %f\n"
	.size	.L.str.4, 29

	.type	.L.str.5,@object                // @.str.5
.L.str.5:
	.asciz	" A m\303\251dia da turma \303\251: %f\n"
	.size	.L.str.5, 27

	.ident	"Android (10552028, +pgo, +bolt, +lto, -mlgo, based on r487747d) clang version 17.0.2 (https://android.googlesource.com/toolchain/llvm-project d9f89f4d16663d5012e5c09495f3b30ece3d2362)"
	.section	".note.GNU-stack","",@progbits
