.global _start
 #have to use cl for variabke amount shifting
.data
  dividend: .long 4294967295 #holds space for 32bit dividend
  divisor: .long 4 #holds space for 32bit divisor
  temp_dividend: .long 0 #holds space dividend before arithmetic
  #quotient: .long 0 #holds space for quotient

.text

_start:
  movl $0, %ebx #EBX = counter
  movl $31, %ecx #ECX = i which is 31
  movl $0, %eax #eax = temp dvidend
  movl $0, %esi #esi = temp divisor
  movl $0, %edi #EDI = quotient 
  #for(int i = 31;i >= 0; i--)
  for_start:
    cmpl $0, %ecx #i >= 0 negation i - 0 < 0
    jl for_end
    #if((dividend >> i) >= divisor) trying to modify dividend when last not needed
    movl dividend, %eax #eax temporarily holds the dividend
    shrl %cl, %eax  #dividend >> i
    cmpl divisor, %eax #(dividend >> i) - divisor < 0
    ja if1_start
    jb else_start
    if1_start:
       #dividend = dividend - (divisor <<(31 - counter))
       movl $31, %eax #eax = 31
       subl %ebx, %eax #eax = 31 - counter
       movl divisor, %esi #ESI = divisor 
       shll %cl, %esi #divisor = (divisor << cl)
       subl %esi, dividend # dividend = dividend - ESI
       #quotient = (quotient << 1) | 1
       #EDI = quotient << 1 
       shll $1, %edi #edi = edi << 1
       or $1, %edi #edi | 1 == EDI = (quotient << 1) | 1
       addl $1, %ebx #counter++
       jmp else_end
    if1_end:
    else_start:
       shll $1,%edi #quotient = quotient << 1
       addl $1,%ebx #counter++
       jmp else_end
    else_end:
    decl %ecx #i--
    jmp for_start
  for_end:
 #remainder = dividend
 movl dividend, %edx
 movl %edi, %eax #placing the quotient in EAX
done:
nop


