# Read the following instructions carefully
# You will provide your solution to this part of the project by
# editing the collection of functions in this source file.
#
# Some rules from Project 2 are still in effect for your assembly code here:
#  1. No global variables are allowed
#  2. You may not define or call any additional functions in this file
#  3. You may not use any floating-point assembly instructions
# You may assume that your machine:
#  1. Uses two's complement, 32-bit representations of integers.

# isZero - returns 1 if x == 0, and 0 otherwise
#   Argument 1: x
#   Examples: isZero(5) = 0, isZero(0) = 1
#   Rating: 1
.global isZero
isZero:
    movl $0, %eax    # Clear eax register
    cmpl $0, %edi    # Compare x with 0
    sete %al         # Set al to 1 if x == 0 (ZF flag is set)
    ret              # Return with the result in al

# bitNor - ~(x|y)
#   Argument 1: x
#   Argument 2: y
#   Example: bitNor(0x6, 0x5) = 0xFFFFFFF8
#   Rating: 1
.global bitNor
bitNor:
    movl %edi, %eax     # Move the value of x into eax
    # Perform bitwise OR between x and y and store the result in eax
    orl %esi, %eax  
    notl %eax       # Negate eax to get the bitwise NOR result
    ret

# distinctNegation - returns 1 if x != -x.
# and 0 otherwise
# Argument 1: x

.global distinctNegation
distinctNegation:
    # Compare x to its two's complement
    # If they are equal, jump to equal
    movl    %edi, %eax   # Load the value of x into the EAX register
    negl    %eax        # Calculate -x by negating EAX
    cmp     %edi, %eax
    je      equal
    
    # If not equal, return 1 (true)
    mov     $1, %eax
    ret
    
equal:
    # If equal, return 0 (false)
    xor     %eax, %eax
    ret


# dividePower2 - Compute x/(2^n), for 0 <= n <= 30
#  Round toward zero
#   Argument 1: x
#   Argument 2: n
#   Examples: dividePower2(15,1) = 7, dividePower2(-33,4) = -2
#   Rating: 2
.global dividePower2
dividePower2:
# Compare n with 0
    cmpl $0, %esi
    je .pow_zero

# If n is not 0, check the sign of x
    movl %edi, %eax     #x
    testl %eax, %eax
    jns .pow_positive
  # If x is positive, jump to the positive branch
    
    movl $1, %edx  # If x is negative, initialize a shift value of 1 (for rounding)
    movl %esi, %ecx  # Move the value of n to ecx
    shll %cl, %edx  # Shift 1 left by n bits to get 2^n
    decl %edx  # Decrement 2^n by 1
    addl %edx, %eax  # Add (2^n - 1) to x

# In the positive branch, shift right to perform the division
.pow_positive:
    movl %esi, %ecx  # Move the value of n to ecx
    sarl %cl, %eax  # Arithmetic shift right by n bits (x / 2^n)
    ret  # Return the result

# If n is 0, just return the original value of x
.pow_zero:
    movl %edi, %eax
    ret


# getByte - Extract byte n from word x
#   Argument 1: x
#   Argument 2: n
#   Bytes numbered from 0 (least significant) to 3 (most significant)
#   Examples: getByte(0x12345678,1) = 0x56
#   Rating: 2
.global getByte
getByte:
    # Extract byte n from word x
    movl    %edi, %eax      # Move the value of x (1st argument) into EAX register
    movl    %esi, %ecx      # Move the value of n (2nd argument) into ECX register
    shll    $3, %ecx        # Shift the value in ECX left by 3 to calculate n << 3
    sarl    %cl, %eax       # Arithmetic right shift EAX by CL (lower 8 bits of ECX)
    andl    $0xFF, %eax     # Perform a bitwise AND with 0xFF to extract the lowest 8 bits
    ret                     # Return the result in EAX



# isPositive - return 1 if x > 0, return 0 otherwise
#   Argument 1: x
#   Example: isPositive(-1) = 0.
#   Rating: 2
.global isPositive
isPositive:
    # Move the input argument (x) from %edi to %eax for further processing
    movl    %edi, %eax
    # Compare %eax with 0 to check if x is greater than 0
    cmpl    $0, %eax
    # Set the result to 1 if x is greater than 0
    setg    %al
    # Zero-extend the result in %al to a 32-bit value in %eax
    movzbl  %al, %eax

    ret




# floatNegate - Return bit-level equivalent of expression -f for
#   floating point argument f.
#   Both the argument and result are passed as unsigned int's, but
#   they are to be interpreted as the bit-level representations of
#   single-precision floating point values.
#   When argument is NaN, return argument.
#   Argument 1: f
#   Rating: 2
# This assembly code implements the floatNegate function, which returns the bit-level equivalent of -f for a floating-point argument f.
# Both the argument and result are passed as unsigned int's, representing the bit-level representations of single-precision floating-point values.
# When the argument is NaN, it returns the argument itself.

.global floatNegate
floatNegate:
    # Move the input argument (uf) from %edi to %eax for further processing
    movl    %edi, %eax
    movl    %edi, %ecx

    # Check if the argument is NaN by comparing the exponent bits and fraction bits to zero.
    shr     $23, %eax         # Shift right by 23 bits to isolate the exponent
    and     $0xFF, %eax       # Mask out all but the lowest 8 bits (exponent bits)
    and     $0x7FFFFF, %ecx   # Mask out the sign bit and the exponent bits, leaving only the fraction bits

    cmpl    $0xFF, %eax  # Compare the exponent bits to 0x7F800000 (exponent bits for NaN)
    jne     not_nan           # Jump to "not_nan" label if exponent is not NaN

    cmpl    $0, %ecx          # Compare the fraction bits to 0 (frac != 0 check)
    je      not_nan           # Jump to "not_nan" label if fraction bits are zero

    # It's NaN, return the argument itself
    movl    %edi, %eax         # Move the original value (uf) back to %eax
    ret

not_nan:
    # Toggle the sign bit by flipping the most significant bit (bit 31)
    xorl    $0x80000000, %edi  # Toggle the sign bit
    movl    %edi, %eax  
    ret




# isLessOrEqual - if x <= y  then return 1, else return 0
#   Argument 1: x
#   Argument 2: y
#   Example: isLessOrEqual(4,5) = 1.
#   Rating: 3
.global isLessOrEqual
isLessOrEqual:
    movl    %edi, %eax  # Move the value of x (Argument 1) into %eax
    cmpl    %esi, %eax  # Compare x (in %eax) and y (in %esi)
    jle     less_or_equal   # Jump to less_or_equal if x <= y
    movl    $0, %eax  # Set %eax to 0 (x > y)
    ret

less_or_equal:
    movl    $1, %eax  # Set %eax to 1 (x <= y)
    ret



# bitMask - Generate a mask consisting of all 1's between
#   lowbit and highbit
#   Argument 1: highbit
#   Argument 2: lowbit
#   Examples: bitMask(5,3) = 0x38
#   Assume 0 <= lowbit <= 31, and 0 <= highbit <= 31
#   If lowbit > highbit, then mask should be all 0's
#   Rating: 3

.global bitMask
bitMask:
    # Copy the value of 'highbit' (Argument 1) to %eax
    movl    %edi, %eax
    # Copy the value of 'lowbit' (Argument 2) to %ecx
    movl    %esi, %ecx
    
    cmpl    %eax, %ecx  # if %eax > %ecx jump
    jg      .Lno_mask

    # Initialize a base integer with all bits set to 1
    movl    $-1, %edx
    movl    $-1, %r8d

    # Create a mask with 1's from 'highbit' to the most significant bit
    movl    %edi, %ecx
    shll    %ecx, %edx
    shll    $1, %edx
    notl    %edx

    # Create a mask with 1's from the least significant bit to 'lowbit'
    movl    %esi, %ecx
    shll    %ecx, %r8d

    # Combine the two masks by bitwise AND
    andl    %r8d, %edx

    # Return the result
    movl    %edx, %eax
    ret
.Lno_mask:
    movl   $0, %eax
    ret

# addOK - Determine if can compute x+y without overflow
#   Argument 1: x
#   Argument 2: y
#   Example: addOK(0x80000000,0x80000000) = 0, overflow
#            addOK(0x80000000,0x70000000) = 1, not overflow
#   Rating: 3
.global addOK
addOK:
    movl    %edi, %r9d      # Move the value of x (1st argument) into r9d
    movl    %esi, %ecx      # Move the value of y (2nd argument) into ecx

    addl    %ecx, %r9d      # Add y to x and store the result in r9d
    jno     add_no_overflow     # Jump to 'no_overflow' if there is no overflow

    # Overflow occurred
    movl    $0, %eax        # Set the return value to 0 (overflow)
    ret

add_no_overflow:
    movl    $1, %eax        # Set the return value to 1 (no overflow)
    ret




# floatScale64 - Return bit-level equivalent of expression 64*f for
#   floating point argument f.
#   Both the argument and result are passed as unsigned int's, but
#   they are to be interpreted as the bit-level representation of
#   single-precision floating point values.
#   When argument is NaN, return argument
#   Argument 1: f
#   Rating: 4
.global floatScale64
floatScale64:
    movl    $6, %ecx   # Initialize loop counter to 6
        # Check if the input is zero
    movl    %edi, %eax
    movl    %edi, %edx
    shrl    $31, %edi  # sign
    andl    $0x7F800000, %edx  # expo
    andl    $0x007FFFFF, %eax  # fraction
    
    test    %edx, %edx
    je      is_demor

loop_start:
    # Check if the input is NaN
    cmpl    $0x7F800000, %edx
    je      is_nan

    # Scale the floating-point value by 64
    addl    $0x800000, %edx #10000000000000000000000
     # Check if %edi is overflow
    cmpl    $0x7F800000, %edx
    je      overflow

    # Decrement the loop counter and loop if not zero
    subl    $1, %ecx
    jnz     loop_start

    shll    $31, %edi
    orl     %edi, %edx
    orl     %edx, %eax


    # If the loop counter is zero, return the scaled value
    ret
is_demor:
    cmpl    $0, %eax
    je      is_nan

de_loop_start:
    cmpl     $0x400000, %eax
    jae      de_overflow
   
    subl    $1, %ecx
    shll    $0x1, %eax 
    # Check if %edi is overflow


    # Decrement the loop counter and loop if not zero
    cmpl    $0x0, %ecx
    ja     de_loop_start
    
    shll    $31, %edi
    orl     %edi, %edx
    orl     %edx, %eax
    ret

de_overflow:
    #subl    $0x1, %eax
    
    shll    $23, %ecx
    addl    %ecx, %edx
    shll    $0X1, %eax
    andl    $0x7fffff, %eax
    
    shll    $31, %edi
    orl     %edi, %edx
    orl     %edx, %eax
    # If %edi is overflow, return the value
    ret

is_nan:
    # If the input is NaN, return the input itself
    shll    $31, %edi
    orl     %edi, %edx
    orl     %edx, %eax
    ret

overflow:

    movl    $0x0, %eax
    shll    $31, %edi
    orl     %edi, %edx
    orl     %edx, %eax
    # If %edi is overflow, return the value
    ret







# floatPower2 - Return bit-level equivalent of the expression 2.0^x
#   (2.0 raised to the power x) for any 32-bit integer x.
#
#   The unsigned value that is returned should have the identical bit
#   representation as the single-precision floating-point number 2.0^x.
#   If the result is too small to be represented as a denorm, return
#   0. If too large, return +INF.
#
#   Argument 1: x
#   Rating: 4
.global floatPower2
floatPower2: 
    movl %edi, %r9d 
    addl $127, %r9d
    cmpl $255, %r9d
    jg .float_infi
    
    cmpl $0, %r9d
    jl .float_zero
    
    shll $23,%r9d
    movl %r9d, %eax
    ret

    .float_infi:
        movl $0x7F800000, %eax
        ret
    
    .float_zero:
        movl $0x0, %eax
        ret

