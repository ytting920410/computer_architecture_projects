.data

$LC2:
        .ascii  "input x: \000"
$LC3:
        .ascii  "input y: \000"
$LC4:
        .ascii  "input z: \000"
$LC5:
        .ascii  "result = \000"

.text

main:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        add     $fp,$sp,$0
        la $a0, $LC2	# print "input x: "
        li $v0, 4
        syscall
        li $v0, 5	# get input
        syscall
        sw $v0, 28($fp) # x
        nop

        la $a0, $LC3	# print "input y: "
        li $v0, 4
        syscall
        li $v0, 5	# get input
        syscall
        sw $v0, 32($fp) # Y
        nop

        la $a0, $LC4	# print "input Z: "
        li $v0, 4
        syscall
        li $v0, 5	# get input
        syscall
        sw $v0, 36($fp) # z

        lw      $2,28($fp)
        lw      $3,32($fp)
        nop
        add     $5,$3,$0
        add     $4,$2,$0
        jal     compare # do compare
        nop

        add     $4,$2,$0
        lw      $2,36($fp)
        add	 $5,$2,$0
        nop
        jal     smod # do smod
        nop
        sw      $2,24($fp)

	la $a0, $LC5	   # "result = "
	li $v0, 4
	syscall
        lw      $a0,24($fp) # print the result
  	li $v0, 1        # service 1 (print integer)
  	syscall
        nop

        move    $2,$0
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        j       Exit
        nop

compare:
        addiu   $sp,$sp,-8
        sw      $fp,4($sp)
        add     $fp,$sp,$0
        sw      $4,8($fp)
        sw      $5,12($fp)
        lw      $3,8($fp) # p
        lw      $2,12($fp) # q
        nop
        slt     $2,$2,$3 # if p > q, go to $L3
        beq     $2,$0,$L2 # if p <= q, go to $L2
        nop

        lw      $3,8($fp)
        lw      $2,12($fp)
        nop
        addu    $2,$3,$2 # return p + q
        b       $L3
        nop

$L2:
        lw      $2,8($fp) # return p
        add     $sp,$fp,$0
        lw      $fp,4($sp)
        addiu   $sp,$sp,8
        jr      $ra 
        nop
$L3:
        add     $sp,$fp,$0
        lw      $fp,4($sp)
        addiu   $sp,$sp,8
        jr      $ra
        nop

smod:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        add     $fp,$sp,$0
        sw      $4,40($fp)
        sw      $5,44($fp)
        lw      $3,40($fp) # p
        lw      $2,44($fp) # q
        nop
        slt     $2,$2,$3 # if p > q, go to $L6
        beq     $2,$0,$L5 # if p <= q, go to $L5
        nop

        lw      $3,40($fp)
        li      $2,-2147483648                  # 0xffffffff80000000
        ori     $2,$2,0x3
        and     $2,$3,$2 # get q % 4
        bgez    $2,$L6
        nop

$L6: # div = 2 + pow(2, p%4)
        add     $5,$2,$0 
        li      $4,2                        # 0x2
        beq 	 $5,$0,$L13	# $5 == 0
        addi	 $5,$5,-1
        beq	 $5,$0,$L14	# $5 == 1
        addi	 $5,$5,-1
        beq	 $5,$0,$L15	# $5 == 2
        addi	 $5,$5,-1
        beq	 $5,$0,$L16	# $5 == 3
        nop

        b       $L7
        nop

$L5:
        lw      $3,44($fp) # q
        li      $2,-2147483648                  # 0xffffffff80000000
        ori     $2,$2,0x3
        and     $2,$3,$2 # get p % 4
        bgez    $2,$L8 # if $2 >= 0
        nop

$L8: # div = 4 + pow(2, q%4)
        add     $5,$2,$0 
        li      $4,2                        # 0x2
        beq 	 $5,$0,$L9	# $5 == 0
        addi	 $5,$5,-1
        beq	 $5,$0,$L10	# $5 == 1
        addi	 $5,$5,-1
        beq	 $5,$0,$L11	# $5 == 2
        addi	 $5,$5,-1
        beq	 $5,$0,$L12	# $5 == 3
        nop

        b $L7
$L9: # 4 + 2^0
	addiu $4,$0,1
	addiu $4,$4,4
	sw $4,24($fp)
	b $L7
$L10: # 4 + 2^1
	addiu $4,$4,4
	sw $4,24($fp)
	b $L7
$L11: # 4 + 2^2
	sll $4,$4,1
	addiu $4,$4,4
	sw $4,24($fp)
	b $L7
$L12: # 4 + 2^3
	sll $4,$4,2
	addiu $4,$4,4
	sw $4,24($fp)
	b $L7
$L13: # 2 + 2^0
	addiu $4,$0,1
	addiu $4,$4,2
	sw $4,24($fp)
	b $L7
$L14: # 2 + 2^1
	addiu $4,$4,2
	sw $4,24($fp)
	b $L7
$L15: # 2 + 2^2
	sll $4,$4,1
	addiu $4,$4,2
	sw $4,24($fp)
	b $L7
$L16: # 2 + 2^3
	sll $4,$4,2
	addiu $4,$4,2
	sw $4,24($fp)
	b $L7
$L7:
        lw      $3,24($fp)
        nop
        move    $2,$3
        sll     $2,$2,2 # div = div * 5
        addu    $2,$2,$3
        sw      $2,24($fp)
        
        lw      $2,40($fp)
        nop
        sll     $2,$2,2 # divd = p * 4 + q
        lw      $3,44($fp)
        nop
        addu    $2,$3,$2
        sw      $2,28($fp)
        
        lw      $3,28($fp)
        lw      $2,24($fp)
        nop
        div     $0,$3,$2 #  divd % div
        mfhi    $2 
        sw	 $2,24($fp) # return  divd % div
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr      $31 # 0x...308
        nop
        
Exit:
# =====================================================
	li $v0, 10
	syscall
