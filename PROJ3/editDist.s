.global _start

.data
  string1: .space 100 #creating space for my string1
  string2: .space 100 #creating space for my string2
  strlen1: .long 0 #length of string 1
  strlen2: .long 0 #length of string 2
  old_ebx: .long 0
  curDist: .space 400 #curDist
  oldDist: .space 400 #oldDist
  min: .long 0 #min value after the min function 
.text
#want to store the distance in EAX

min_function:
  #int a = EBX
  #int b = EDX
  #if a < b return a; else return b a - b >= 0
  cmpl %edx, %ebx
  jl ifmin_start
  jg elsemin_start
  ifmin_start:
    movl %ebx, %ecx #ECX = a
    jmp ifmin_end
  elsemin_start:
    movl %edx, %ecx #ECX = b
    jmp ifmin_end
  elsemin_end:
  ifmin_end:
  ret

Stringlength1:
  movl $0, %ebx #strlength = 0
  forfun_start2:
  cmpb $0, string1(,%ebx,1) #str at len - '\0' = 0
  jz forfun_end2
  addl $1, %ebx
  jmp forfun_start2
  forfun_end2:
  ret

Stringlength2:
  movl $0, %ebx #strlength = 0
  forfun_start1:
  cmpb $0, string2(,%ebx,1) #str at len - '\0' = 0
  jz forfun_end1
  addl $1, %ebx
  jmp forfun_start1
  forfun_end1:
  ret

swap_function:
 movl $0, %esi
 for_start:
 movl strlen2, %edx #edx
 addl $1, %edx #edx + 1
 cmpl %edx, %edi # i - edx 
 jge for_end # 
 movl oldDist(,%esi,4), %edx #swaps the values of old and cur Dist
 movl curDist(,%esi,4), %ecx
 movl %edx, curDist(,%esi,4)
 movl %ecx, oldDist(,%esi,4)
 addl $1, %esi 
 jmp for_start
 for_end:
 ret

edit_distance:
  call Stringlength1
  movl %ebx, strlen1 #strlen1 has been set
  call Stringlength2
  movl %ebx, strlen2 #strlen2 has been set
  movl $0, %ebx #i = 0
  stfor_start:
    movl strlen2, %eax # eax = srtlen2
    addl $1, %eax #strlen2 + 1
    cmpl %eax, %ebx #i - strlen2 < 0
    jge stfor_end
    movl %ebx, oldDist(,%ebx,4) #oldDist[i] = i
    movl %ebx, curDist(,%ebx,4) #curdist[i] = i
    addl $1, %ebx #i++
    jmp stfor_start
  stfor_end:
  movl $1, %ebx #i = 1
  ndfor_start:
    movl strlen1, %eax #eax =  strlen1
    addl $1, %eax #eax = strlen1 + 1
    cmpl %eax, %ebx #i - strlen1 => 0
    jge ndfor_end
    movl %ebx, curDist #curDist[0] = i
    movl $1, %edi # j = 1
    rdfor_start:
      movl strlen2, %edx #edx = strlen2
      addl $1, %edx #edx = strlen2 + 1
      cmpl %edi, %edx #j - (strlen2 +1) => 0
      jge ndfor_end
      ifequal_start:
        movb string1+(-1*1)(,%ebx), %ah #string1[i-1]
        cmpb %ah,string2+(-1*1)(,%edi) #string2[j-1]
        jl ifequal_end
        jg ifequal_end
        movl oldDist+(-1*4)(,%edi,4), %edx #oldDist[j-1]
        movl %edx, curDist(,%edi,4) # curDist[j] = oldDist[j-1]
        jmp else_end
      ifequal_end:
      ifoldmin:
        movl oldDist(,%edi,4), %ecx
        cmpl %ecx, curDist+(-1*4)(,%edi,4)
        jg endoldmin
        movl curDist+(-1*4)(,%edi,4), %edx
        movl %edx, min #min now cur dist 
      endoldmin:
      ifcurmin:
         movl oldDist(,%edi,4), %ecx
         cmpl %ecx, curDist+(-1*4)(,%edi,4)
         jle endcurmin
         movl %ecx, min
      endcurmin:
      if_less: #checks to see if less
        movl min, %ecx 
        cmpl %ecx, oldDist+(-1*4)(,%edi,4)
        jg if_less_end
        movl oldDist+(-1*4)(,%edi,4), %edx
        movl %edx, min #min now equals oldDist[j]
      if_less_end:
        subl $1, min
        movl min, %ecx
        movl %ecx, curDist(,%ebx,4)
      else_end:
      call swap_function
      addl $1, %edi #j++
      jmp rdfor_start
     rdfor_end:
  ndfor_end:
  ret
_start:
  call edit_distance
  movl strlen2, %ebx
  movl oldDist(,%ebx,4), %eax
done:
 nop

