# =========== Syed Muhammad Hamza Bhukhari (02-131192-022)=========== 
# =========== Arzoo Fatima (02-131192-032)=========== 
# =========== Bilal Fareed (02-131192-080)=========== 
# =========== Ahmed Faraz Ali (02-131192-023)=========== 
.data
line:		.asciiz "==============================================\n"
heading:	.asciiz "\tENCRYPTION / DECRYPTION SYSTEM\n\tUSING CAESAR CIPHER TECHNIQUE\n"
mainmenu:	.asciiz "PRESS 1 IF YOU WANT TO ENCRYPT\nPRESS. 2 IF YOU WANT TO DECRYPT. \nPRESS 3 IF YOU WANT TO EXIT. \nENTER CHOICE : "
keyinput:    	.asciiz "INSERT A KEY (GREATER THEN 0) : "
encryptiontext:	.asciiz "\n=============== ENCRYPTED TEXT ==============="
decryptiontext:	.asciiz "\n=============== DECRYPTED TEXT ==============="
input:		.asciiz "\nINSERT A STRING: "
result:		.asciiz "\t\tRESULT : "
choice:		.asciiz "\nPRESS 1 IF YOU WANT TO CONTINUE.\nPRESS 2 IF YOU WANT TO EXIT. \nENTER CHOICE :  "
thanks:		.asciiz "========== THANK YOU! ==========\n"
errortext:	.asciiz "========== INVALID STRING! ==========\n"
endl:		.asciiz "\n"
string:		.space 256

.text
Main:
li $v0, 4
la $a0, line
syscall
  
li $v0, 4
la $a0, heading
syscall
  
li $v0, 4
la $a0, line
syscall
                             
li $v0, 4
la $a0, mainmenu
syscall

li $v0, 5
syscall

beq $v0, $zero, exit
bltz $v0, Main
bgt $v0, 2, Main
addi $s0, $v0, 0

keyAsk:
li $v0, 4  
la $a0, keyinput
syscall

li $v0, 5
syscall

li $t0, 26
div $v0, $t0
mfhi $t1 

beqz $t1, keyAsk
blt $t1, $0, keyAsk
addi $s1, $t1, 0 

stringAsk:
li $v0, 4
la $a0, input
syscall

li $v0, 8
la $a0, string
li $a1, 255
syscall

la $a0, string
jal strLen

beq $v1, 0, stringOk
j stringAsk

stringOk:
addi $s2, $v0, 0

li $v0,9
addi $a0, $s2, 1
syscall

addi $s3, $v0, 0

opSelect:
beq $s0, 1, encryptionPrompt
beq $s0, 2, decryptionPrompt
j Main

decryptionPrompt:
add $t0, $s1, $s1
sub $s1, $s1, $t0

li $v0, 4
la $a0, decryptiontext
syscall

li $v0, 4
la $a0, endl
syscall

j invokeEncryption

encryptionPrompt:
li $v0, 4
la $a0, encryptiontext
syscall

li $v0, 4
la $a0, endl
syscall

invokeEncryption:
addi $a0, $s2, 0
li $a1, 0
addi $a2, $s3, 0
jal encryptionCore

j done

done:
li $v0, 4
la $a0, result
syscall

addi $a0, $s3, 0
li $v0, 4
syscall

li $a0, 4
la $a0, endl
syscall
  
li $v0, 4
la $a0, line
syscall

li $v0, 4 
la $a0, choice
syscall

li $v0, 5
syscall

addi $t0, $v0, 0

li $v0, 4
la $a0, endl
syscall

beq $t0, 1, Main

exit:
li $v0, 4
la $a0, thanks
syscall

li $v0, 10
syscall

encryptionCore:  
addi $sp, $sp -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $ra, 12($sp)

li $t5, 0
sb $t5, 0($a2)

bge $a1, $a0, encryptionCoreEnd

addi $t1, $a0, 0            

lb $a0, string($a1)

jal isSpace
beq $v0, 1, encryptionCoreIsSpace

jal getCharOffset
addi $t2, $v0, 0

    theEncryptionAlgorithm:
    li $t7, 26
    sub $t3, $a0, $t2
    add $t3, $t3, $s1
    div $t3, $t7
    mfhi $t3
    add $t3, $t3, $t2 

    sb $t3, 0($a2)

    encryptionCoreNextChar:
    addi $a0, $t1, 0
    addi $a1, $a1, 1
    addi $a2, $a2, 1
    jal encryptionCore

    encryptionCoreEnd:
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

    encryptionCoreIsSpace:
    li $t5, 32
    sb $t5, 0($a2)
    j encryptionCoreNextChar

getCharOffset:
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
  
jal isLowerCase

lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8

bne $v0, 1, encryptionCoreUpperCase
  
    encryptionCoreLowerCase:
    beq $s0, 2, decryptionCoreLowerCase
    li $v0, 97
    jr $ra

    decryptionCoreLowerCase:
    li $v0, 122
    jr $ra

    encryptionCoreUpperCase:
    beq $s0, 2, decryptionCoreUpperCase
    li $v0, 65
    jr $ra

    decryptionCoreUpperCase:
    li $v0, 90
    jr $ra

strLen:
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)

li $t0, 0
li $t1, 0
addi $t2, $a0, 0
li $t3, 10

    strLenLoop:
    lb $t1, 0($t2)
    beqz $t1, strLenExit
    beq $t1, $t3, strLenExit

    addi $a0, $t1, 0
    jal isValidChar
    bne $v0, 1, strLenError

    addi $t2, $t2, 1
    addi $t0, $t0, 1
    j strLenLoop

    strLenExit:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    addi $v0, $t0, 0
    li $v1, 0
    jr $ra

    strLenError:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    li $v0, 4
    la $a0, errortext
    syscall

    li $v0, -1
    li $v1, -1
    jr $ra

isValidChar:
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)

jal isLetter
beq $v0, 1, validCharFound

jal isSpace
beq $v0, 1, validCharFound

lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8

li $v0, 0
jr $ra

    validCharFound:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    li $v0, 1
    jr $ra

isLetter:
addi $sp, $sp, -8
sw $a0, 0($sp)  
sw $ra, 4($sp)

jal isLowerCase
beq $v0, 1, isLetterOk
blt $v0, 0, isLetterError

jal isUpperCase
beq $v0, 1, isLetterOk
blt $v0, 0, isLetterError

    isLetterError:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    li $v0, 0
    jr $ra

    isLetterOk:
    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    li $v0, 1
    jr $ra

isSpace:
bne $a0, 32, isNotSpace
  
li $v0, 1
jr $ra

    isNotSpace:
    li $v0, 0
    jr $ra

isLowerCase:
blt $a0, 97, isNotLowerCase
bgt $a0, 122, isLowerCaseError

li $v0, 1
jr $ra
    
    isLowerCaseError:
    li $v0, -1
    jr $ra
    
    isNotLowerCase:
    li $v0, 0
    jr $ra

isUpperCase:
blt $a0, 65, isUpperCaseError
bgt $a0, 90, isNotUpperCase

li $v0, 1
jr $ra
    
    isUpperCaseError:
    li $v0, -1
    jr $ra
    
    isNotUpperCase:
    li $v0, 0
    jr $ra