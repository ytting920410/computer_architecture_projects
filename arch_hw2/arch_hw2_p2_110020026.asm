.data

$LC0:
        .ascii  "Please enter a number(Input 0 to exit): \000"
$LC1:
        .ascii  "%d\000"
$LC2:
        .ascii  "bye\000"
$LC3:
        .ascii  "MMM\000"
$LC4:
        .ascii  "MM\000"
$LC5:
        .ascii  "CM\000"
$LC6:
        .ascii  "DCCC\000"
$LC7:
        .ascii  "DCC\000"
$LC8:
        .ascii  "DC\000"
$LC9:
        .ascii  "CD\000"
$LC10:
        .ascii  "CCC\000"
$LC11:
        .ascii  "CC\000"
$LC12:
        .ascii  "XC\000"
$LC13:
        .ascii  "LXXX\000"
$LC14:
        .ascii  "LXX\000"
$LC15:
        .ascii  "LX\000"
$LC16:
        .ascii  "XL\000"
$LC17:
        .ascii  "XXX\000"
$LC18:
        .ascii  "XX\000"
$LC19:
        .ascii  "IX\000"
$LC20:
        .ascii  "VIII\000"
$LC21:
        .ascii  "VII\000"
$LC22:
        .ascii  "VI\000"
$LC23:
        .ascii  "IV\000"
$LC24:
        .ascii  "III\000"
$LC25:
        .ascii  "II\000"
$LC26:
        .ascii  "M\000"
$LC27:
        .ascii  "D\000"
$LC28:
        .ascii  "C\000"
$LC29:
        .ascii  "L\000"
$LC30:
        .ascii  "X\000"
$LC31:
        .ascii  "V\000"
$LC32:
        .ascii  "I\000"
output:
	.ascii	 "The Roman is: \000"
Pnewline: .asciiz "\n"
        
.text
        
main:
        addiu   $sp,$sp,-56
        sw      $31,52($sp)
        sw      $fp,48($sp)
        move    $fp,$sp
$L34:
	la $a0, $LC0	   # print "Please enter a number(Input 0 to exit): "
	li $v0, 4	   
	syscall	           

        li $v0, 5	# get input
        syscall
        sw $v0, 40($fp)

        lw      $2,40($fp)	# if input is not zero, do the conversion
        nop
        bne     $2,$0,$L2
        nop

        la $a0, $LC2	# print bye
        li $v0, 4
        syscall

        move    $2,$0	#leave
        b       $L35
        nop

$L2:	# compute the numbers in each number of digits
	la $a0, output
        li $v0, 4
        syscall
	
        lw      $t3,40($fp)
        li      $t2,1000           # 0x3e8
        div     $s3,$t3,$t2
        nop
        mfhi    $t2
        mflo    $t2
        sw      $t2,24($fp)
        lw      $t3,40($fp)
        li      $t2,1000           # 0x3e8
        div     $s2,$t3,$t2
        nop
        mfhi    $t2
        move    $t3,$t2
        li      $t2,100                  # 0x64
        div     $s2,$t3,$t2
        nop
        mfhi    $t2
        mflo    $t2
        sw      $t2,28($fp)
        lw      $t3,40($fp)
        li      $t2,100                  # 0x64
        div     $s1,$t3,$t2
        nop
        mfhi    $t2
        move    $t3,$t2
        li      $t2,10                 # 0xa
        div     $s1,$t3,$t2
        nop
        mfhi    $t2
        mflo    $t2
        sw      $t2,32($fp)
        lw      $t3,40($fp)
        li      $t2,10                 # 0xa
        div     $s1,$t3,$t2
        nop
        mfhi    $t2
        sw      $t2,36($fp)       # 24 28 32 36 ($fp) are thns huns tens ones
        
        lw      $t3,24($fp)	# if it is 3000
        li      $t2,3                        # 0x3
        bne     $t3,$t2,$L4
        nop

        la $a0, $LC3	# print "MMM"
        li $v0, 4
        syscall

        b       $L5
        nop

$L4:
        lw      $t3,24($fp)	# if it is 2000
        li      $t2,2                        # 0x2
        bne     $t3,$t2,$L6
        nop

        la $a0, $LC4	# print "MM"
        li $v0, 4
        syscall

        b       $L5
        nop

$L6:
        lw      $t3,24($fp)		# if it is 1000
        li      $t2,1                        # 0x1
        bne     $t3,$t2,$L5
        nop

        la      $4,$LC26             	# print "M"
        li	 $v0,4
        syscall
        nop

$L5:
        lw      $t3,28($fp)		# if it is 900
        li      $t2,9                        # 0x9
        bne     $t3,$t2,$L7
        nop

        la $a0, $LC5	# print "CM"
        li $v0, 4
        syscall

        b       $L8
        nop

$L7:
        lw      $t3,28($fp)		# if it is 800
        li      $t2,8                        # 0x8
        bne     $t3,$t2,$L9
        nop

        la $a0, $LC6	# print "DCCC"
        li $v0, 4
        syscall

        b       $L8
        nop

$L9:
        lw      $t3,28($fp)		# if it is 700
        li      $t2,7                        # 0x7
        bne     $t3,$t2,$L10
        nop

        la $a0, $LC7	# print "DCC"
        li $v0, 4
        syscall

        b       $L8
        nop

$L10:
        lw      $t3,28($fp)		# if it is 600
        li      $t2,6                        # 0x6
        bne     $t3,$t2,$L11
        nop

        la $a0, $LC8	# print "DC"
        li $v0, 4
        syscall

        b       $L8
        nop

$L11:
        lw      $t3,28($fp)		# if it is 500
        li      $t2,5                        # 0x5
        bne     $t3,$t2,$L12
        nop

        la      $4,$LC27                 # print "D"
        li	 $v0,4
        syscall
        nop

        b       $L8
        nop

$L12:
        lw      $t3,28($fp)		# if it is 400
        li      $t2,4                        # 0x4
        bne     $t3,$t2,$L13
        nop

        la $a0, $LC9	# print "CD"
        li $v0, 4
        syscall

        b       $L8
        nop

$L13:
        lw      $t3,28($fp)		# if it is 300
        li      $t2,3                        # 0x3
        bne     $t3,$t2,$L14
        nop

        la $a0, $LC10	# print "CCC"
        li $v0, 4
        syscall

        b       $L8
        nop

$L14:
        lw      $t3,28($fp)		# if it is 200
        li      $t2,2                        # 0x2
        bne     $t3,$t2,$L15
        nop

        la $a0, $LC11	# print "CC"
        li $v0, 4
        syscall

        b       $L8
        nop

$L15:
        lw      $t3,28($fp)		# if it is 100
        li      $t2,1                        # 0x1
        bne     $t3,$t2,$L8
        nop

        la      $4,$LC28                 	# print "C"
        li	 $v0,4
        syscall
        nop

$L8:
        lw      $t3,32($fp)		# if it is 90
        li      $t2,9                        # 0x9
        bne     $t3,$t2,$L16
        nop

        la $a0, $LC12	# print "XC"
        li $v0, 4
        syscall

        b       $L17
        nop

$L16:
        lw      $t3,32($fp)		# if it is 80
        li      $t2,8                        # 0x8
        bne     $t3,$t2,$L18
        nop

        la $a0, $LC13	# print "LXXX"
        li $v0, 4
        syscall

        b       $L17
        nop

$L18:
        lw      $t3,32($fp)		# if it is 70
        li      $t2,7                        # 0x7
        bne     $t3,$t2,$L19
        nop

        la $a0, $LC14	# print "LXX"
        li $v0, 4
        syscall

        b       $L17
        nop

$L19:
        lw      $t3,32($fp)		# if it is 60
        li      $t2,6                        # 0x6
        bne     $t3,$t2,$L20
        nop

        la $a0, $LC15	# print "LX"
        li $v0, 4
        syscall

        b       $L17
        nop

$L20:
        lw      $t3,32($fp)		# if it is 50
        li      $t2,5                        # 0x5
        bne     $t3,$t2,$L21
        nop

        la      $4,$LC29                 	# print "L"
        li	 $v0,4
        syscall
        nop

        b       $L17
        nop

$L21:
        lw      $t3,32($fp)		# if it is 40
        li      $t2,4                        # 0x4
        bne     $t3,$t2,$L22
        nop

        la $a0, $LC16	# print "XL"
        li $v0, 4
        syscall

        b       $L17
        nop

$L22:
        lw      $t3,32($fp)		# if it is 30
        li      $t2,3                        # 0x3
        bne     $t3,$t2,$L23
        nop

        la $a0, $LC17	# print "XXX"
        li $v0, 4
        syscall

        b       $L17
        nop

$L23:
        lw      $t3,32($fp)		# if it is 20
        li      $t2,2                        # 0x2
        bne     $t3,$t2,$L24
        nop

        la $a0, $LC18	# print "XX"
        li $v0, 4
        syscall

        b       $L17
        nop

$L24:
        lw      $t3,32($fp)		# if it is 10
        li      $t2,1                        # 0x1
        bne     $t3,$t2,$L17
        nop

        la      $4,$LC30                 	# print "X"
        li	 $v0,4
        syscall
        nop

$L17:
        lw      $t3,36($fp)		# if it is 9
        li      $t2,9                        # 0x9
        bne     $t3,$t2,$L25
        nop

        la $a0, $LC19	# print "IX"
        li $v0, 4
        syscall

        b       $L26
        nop

$L25:
        lw      $t3,36($fp)		# if it is 8
        li      $t2,8                        # 0x8
        bne     $t3,$t2,$L27
        nop

        la $a0, $LC20	# print "VIII"
        li $v0, 4
        syscall

        b       $L26
        nop

$L27:
        lw      $t3,36($fp)		# if it is 7
        li      $t2,7                        # 0x7
        bne     $t3,$t2,$L28
        nop

        la $a0, $LC21	# print "VII"
        li $v0, 4
        syscall

        b       $L26
        nop

$L28:
        lw      $t3,36($fp)		# if it is 6
        li      $t2,6                        # 0x6
        bne     $t3,$t2,$L29
        nop

        la $a0, $LC22	# print "VI"
        li $v0, 4
        syscall

        b       $L26
        nop

$L29:
        lw      $t3,36($fp)		# if it is 5
        li      $t2,5                        # 0x5
        bne     $t3,$t2,$L30
        nop

        la      $4,$LC31             	# print "V"
        li	 $v0,4
        syscall
        nop

        b       $L26
        nop

$L30:
        lw      $t3,36($fp)		# if it is 4
        li      $t2,4                        # 0x4
        bne     $t3,$t2,$L31
        nop

        la $a0, $LC23	# print "IV"
        li $v0, 4
        syscall

        b       $L26
        nop

$L31:
        lw      $t3,36($fp)		# if it is 3
        li      $t2,3                        # 0x3
        bne     $t3,$t2,$L32
        nop

        la $a0, $LC24	# print "III"
        li $v0, 4
        syscall

        b       $L26
        nop

$L32:
        lw      $t3,36($fp)		# if it is 2
        li      $t2,2                        # 0x2
        bne     $t3,$t2,$L33
        nop

        la $a0, $LC25	# print "II"
        li $v0, 4
        syscall

        b       $L26
        nop

$L33:
        lw      $t3,36($fp)		# if it is 1
        li      $t2,1                        # 0x1
        bne     $t3,$t2,$L26
        nop

        la      $4,$LC32                 	# print "I"
        li	 $v0,4
        syscall
        nop

$L26:	# do everything again
        jal PrintNewline

        b       $L34
        nop

$L35:	# do exit
        move    $sp,$fp
        lw      $31,52($sp)
        lw      $fp,48($sp)
        addiu   $sp,$sp,56
        j       Exit
        nop
        
PrintNewline:	# new line
	la $a0, Pnewline # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	jr $ra           # return
	
Exit:
# =====================================================
li $v0, 10
syscall
