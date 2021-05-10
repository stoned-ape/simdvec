.global _vadd
.global _vsub
.global _vmul
.global _vdiv
.global _vmax
.global _vmin
.global _vdot
.global _vlength
.global _vnorm

// Written by Mark.
// x86_64 macOS X
// ATT Syntax
// System V calling convention
// regs rax,rbx,rcx,rdx,rsi,rdi,rsp,rbp,r8,r9,r10,...,r15
// float regs xmm0,...,xmm15
// args 1:rdi,2:rsi,3:rdx,4:rcx,5:r8,6:r9,7:16(%rbp),8:24(%rbp),...
// float args 1:xmm0,...,8:xmm7
// callee saved regs rbx,rbp,r12,...,r15
// return rax
// float return xmm0

_vadd:
    movaps (%rdi),%xmm0
    addps (%rsi),%xmm0   //SIMD: add four floating point numbers in parallel
    movaps %xmm0,(%rdx)
    ret

_vsub:
    movaps (%rdi),%xmm0
    subps (%rsi),%xmm0   //SIMD
    movaps %xmm0,(%rdx)
    ret

_vmul:
    movaps (%rdi),%xmm0
    mulps (%rsi),%xmm0   //SIMD
    movaps %xmm0,(%rdx)
    ret

_vdiv:
    movaps (%rdi),%xmm0
    divps (%rsi),%xmm0   //SIMD
    movaps %xmm0,(%rdx)
    ret

_vmax:
    movaps (%rdi),%xmm0
    maxps (%rsi),%xmm0   //SIMD
    movaps %xmm0,(%rdx)
    ret

_vmin:  
    movaps (%rdi),%xmm0
    minps (%rsi),%xmm0   //SIMD
    movaps %xmm0,(%rdx)
    ret

_vdot:
    movaps (%rdi),%xmm0
    mulps (%rsi),%xmm0          //element wise multiplication
    movhlps %xmm0,%xmm1         //load floats 2 and 3 of xmm0 into floats 0 and 1 of xmm1
    addps %xmm1,%xmm0           //element wise addition
    movaps %xmm0,%xmm1
    shufps  $0b1, %xmm0, %xmm1  //load float 1 of xmm0 into float 0 of xmm1
    addss %xmm1,%xmm0           //add float 0 of xmm1 to float 0 of xmm0
    ret

_vlength:
    movaps (%rdi),%xmm0
    mulps %xmm0,%xmm0    //compute the square of each element
    movhlps %xmm0,%xmm1
    addps %xmm1,%xmm0
    movaps %xmm0,%xmm1
    shufps  $0b1, %xmm0, %xmm1
    addss %xmm1,%xmm0    //sum of squares complete
    sqrtss %xmm0,%xmm0   //take the square root of the sum
    ret

_vnorm:
    movaps (%rdi),%xmm0
    movaps %xmm0,%xmm2
    mulps %xmm0,%xmm0    //compute the square of each element
    movhlps %xmm0,%xmm1
    addps %xmm1,%xmm0
    movaps %xmm0,%xmm1
    shufps  $0b1, %xmm0, %xmm1
    addss %xmm1,%xmm0   //sum of squares complete
    rsqrtss %xmm0,%xmm1 //take the inverse square root of the sum
    shufps  $0b0, %xmm1, %xmm1  //copy the inverse root into all four vector elements
    mulps %xmm1,%xmm2   //multiply each element by the inverse root
    movaps %xmm2,(%rsi)
    ret
