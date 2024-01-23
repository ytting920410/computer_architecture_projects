.data

$LC0:
        .ascii  "Move disk \000"
$LC1:
	.ascii  " from \000"
$LC2:
	.ascii  " to \000"
$LC3:
        .ascii  "Please input the total number of disk: \000"
$LC4:
        .ascii  "Total number of mivement = \000"
Pnewline: 
	.asciiz "\n"
.text

main:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        add     $fp,$sp,$0
        la $a0, $LC3	# print "Please input the total number of disk: "
        li $v0, 4
        syscall
        nop

        li $v0, 5	# get input
        syscall
        sw $v0, 28($fp) # n
        nop

        lw      $2,28($fp)
        li      $7,66                 # B
        li      $6,67                 # C
        li      $5,65                 # A
        add     $4,$2,$0
        jal     hanoi
        nop

        sw      $2,24($fp) # get the movement
        lw      $5,24($fp)
        la $a0, $LC4	# print "Total number of mivement = "
        li $v0, 4
        syscall
        add      $a0,$5,$0	# print movement
  	li $v0, 1        # service 1 (print integer)
  	syscall
        nop

        move    $2,$0
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        j       Exit
        nop

hanoi:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp) # n
        move    $2,$5
        move    $4,$6
        move    $3,$7
        sb      $2,44($fp) # A
        move    $2,$4
        sb      $2,48($fp) # B
        move    $2,$3
        sb      $2,52($fp) # C
        lw      $2,40($fp)
        nop
        blez    $2,$L2 # if $2 <= 0, do nothing
        nop

        lw      $2,40($fp)
        nop
        addiu   $2,$2,-1
        lb      $5,48($fp) # B
        lb      $4,52($fp) # C
        lb      $3,44($fp) # A
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     hanoi # hanoi(n-1, A, C, B)
        nop

        sw      $2,24($fp) # movement
        lw      $2,40($fp) # start moving disk
        nop
        addiu   $2,$2,-1
        lb      $3,44($fp)
        lb      $4,52($fp)
        nop
        move    $7,$4 # C
        move    $6,$3 # A
        move    $5,$2 # movement
        la $a0, $LC0	   # print "Move disk "
	li $v0, 4
	syscall
	add      $a0,$5,$0	# print movement 
  	li $v0, 1        # service 1 (print integer)
  	syscall
  	la $a0, $LC1	   # print " from "
	li $v0, 4
	syscall
	add      $a0,$6,$0	# print A
  	li $v0, 11        # service 11 (print character)
  	syscall
  	la $a0, $LC2	   # print " to "
	li $v0, 4
	syscall
	add      $a0,$7,$0	# print C
  	li $v0, 11        # service 11 (print character)
  	syscall
  	jal	PrintNewline
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp) # movement++
        lw      $2,40($fp)
        nop
        addiu   $2,$2,-1
        lb      $5,52($fp) # C
        lb      $4,44($fp) # A
        lb      $3,48($fp) # B
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     hanoi
        nop

        move    $3,$2
        lw      $2,24($fp)
        nop
        addu    $2,$2,$3
        sw      $2,24($fp) # return number of movement
        lw      $2,24($fp)
        b       $L3
        nop

$L2:
        move    $2,$0 # do nothing
$L3:
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr      $31
        nop
        
PrintNewline:
	la $a0, Pnewline # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	jr $ra           # return
        
Exit:
# =====================================================
	li $v0, 10
	syscall