.global knapsack

.text
  max_function:
   max_prologue:
  .equ ws, 4

   push %ebp
   movl %esp, %ebp #now on top of the stack
   subl $1*ws, %esp #making space for the locals old_ebx
   .equ a, 2*ws #%ebp
   .equ b, 3*ws #%ebp

    #locals:
   .equ old_ebx, (-1*ws) #%ebp
   
    #a > b ? a : b
   ifa_greater: #a - b > 0
     movl %ebx, old_ebx(%ebp) #saving old ebx
     movl a(%ebp), %eax #eax = a
     movl b(%ebp), %ebx #ebx = b
     cmpl %ebx, %eax #a - b
     jb else_b_greater_start
     #a is greater
     jmp max_epilogue
     else_b_greater_start:
       movl %ebx, %eax # b is the greater and moved into EBX
       jmp max_epilogue
    max_epilogue:
    movl old_ebx(%ebp), %ebx #restoring ebx
    movl %ebp, %esp
    pop %ebp
    ret

 knapsack:
  knapsack_prologue: #int* weights, unsigned int* values, unsigned int num_items, int capacity, unsigned int cur_value
   push %ebp
   movl %esp, %ebp #now on top of the stack
   subl $5*ws, %esp #making space for the Knapsack locals
   .equ cur_val, (6*ws) #%ebp
   .equ capacity, (5*ws) #%ebp
   .equ num_items, (4*ws) #%ebp
   .equ values, (3*ws) #%ebp
   .equ weights, (2*ws) #%ebp

   #locals:
   .equ old_esi, (-1*ws) #%ebp
   .equ old_edi, (-2*ws) #%ebp
   .equ old_ebx, (-3*ws) #%ebp
   .equ best_value, (-4*ws) #%ebp
   .equ i, (-5*ws) #%ebp
  #for(int i =0; i < num_items; i++)
   movl $0, %edx #i = 0
   movl %esi, old_esi(%ebp) #saving old ESI
   movl %edi, old_edi(%ebp) #storing old edi
   movl %ebx, old_ebx(%ebp) #storing old ebx
   movl cur_val(%ebp), %eax
   movl %eax, best_value(%ebp) #bestvalue = curvalue
   for_start:
    movl %edx, i(%ebp)
    movl num_items(%ebp), %esi #esi = num_items
    cmpl %esi, %edx #negation:i - num_items >= 0
    jae knapsack_Epilogue
    #if(capacity - weights[i] >= 0 ), 
    if_start:
      movl weights(%ebp), %edi #EDI = weights
      movl capacity(%ebp), %ecx #ECX = capacity
      cmpl (%edi, %edx, 4), %ecx # capacity - weights[i] LINE WHICH SEGFAULTS
      jb ifend
      #best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i])); RETURN VALUE STORED IN EAX
      movl values(%ebp), %ebx #EBX = values
      movl cur_val(%ebp), %esi #ESI = cur_val
      addl (%ebx, %edx, 4), %esi #cur_val = cur_values +values[i]
      pushl %esi #pushing cur_val + values[i]

      subl (%edi, %edx, 4), %ecx #capacity = capacity - weights[i]
      pushl %ecx #pushing copy of capacity - weights[i]

      movl num_items(%ebp), %esi #ESI = num_items
      subl %edx, %esi #num_items = num_items - i
      subl $1, %esi #num_items - 1
      pushl %esi #pushing copy of num_items - i - 1

      leal 1*ws(%ebx, %edx, 4), %esi #values + i + 1
      pushl %esi #pushing copy of values + i + 1

      leal 1*ws(%edi, %edx, 4), %esi # ESI = weights + i + 1
      pushl %esi #pushing copy of weights + i + 1

      call knapsack #calling the function
      addl $5*ws, %esp #clearing up the arguments in Knapsack function 
      pushl %eax #where the result is stored 
      pushl best_value(%ebp) 
      call max_function #stored in EAX
      addl $2*ws, %esp #clearing up arguments in max function
      movl %eax, best_value(%ebp) #best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]
     ifend:
     movl i(%ebp), %edx
     addl $1, %edx #i++
     jmp for_start

   knapsack_Epilogue:
     movl best_value(%ebp), %eax 
     movl old_ebx(%ebp), %ebx #restoring EBX
     movl old_esi(%ebp), %esi #restoring ESI
     movl old_edi(%ebp), %edi #restoring EDI
     movl %ebp, %esp #clearing locals and args
     pop %ebp
     ret

done:
  nop





