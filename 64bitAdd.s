
/*
*/
.global _start

.data
num1: .space 8  #label for number 1	
num2: .space 8 #label for number 2
 
.text

_start:

#upper 32 bit of sum = EDX
#lower 32 bit of sum = EAX
#temperary upper for num2 = EBX
#temperary lower for num2 = ECX
#temporary upper num 1 = ESI

movl $0, %edx #upper sum, edx = 0
movl $0, %eax #lower sum, eax = 0

movl num2+1*4, %ecx #ECX = lower 32bits of num2
movl num2, %ebx #EBX = upper 32bits of num1

movl num1, %esi #ESI = upper 32 of num1
movl num1+1*4, %eax #EAX = lower 32 of num1

addl %ecx, %eax #EAX = EAX + ECX 
#if the addition is more than 10 want to carry the 1 and add it to EDX
jc ifcarry_start
jnc else_start
ifcarry_start:
  movl $1, %edx
  jmp end_else
else_start:
  movl $0, %edx
  jmp end_else
end_else:
addl %ebx, %esi #ESI = ESI + EBX
addl %esi, %edx #EDX = EDX + ESI

done:
 nop

