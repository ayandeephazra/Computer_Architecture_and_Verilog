// finalTest
//
// Extra tests beyond the first four programs.
// For the single-cycle implementation.
//
// CS/ECE 552, Spring 2006
// Andy Phelps  30 March 2006
// Modified 
// Pratap Ramamurthy 6th May, 2007

// Rotate left by 16, 15, 14,...1 bits.

lbi r0, 16          // r0 = 0x0010  // loop count
lbi r1, 1           // r1 = 0x0001
lbi r2, 2           // r2 = 0x0002
lbi r3, 4           // r3 = 0x0004
lbi r4, 8           // r4 = 0x0008
lbi r5, 16          // r5 = 0x0010

.loop:
rol r1, r1, r0      // 
rol r2, r2, r0      // 
rol r3, r3, r0      // 
rol r4, r4, r0      // 
rol r5, r5, r0      // 
addi r0, r0, -1     // 
bnez r0, .loop       // 

roli r1, r1, 8      // r1 = 0x0001
roli r2, r2, 8      // r2 = 0x0002
roli r3, r3, 8      // r3 = 0x0004
roli r4, r4, 8      // r4 = 0x0008
roli r5, r5, 8      // r5 = 0x0010
add r1, r1, r2      // r1 = 0x0003
add r1, r1, r3      // r1 = 0x0007
add r1, r1, r4      // r1 = 0x000f
add r1, r1, r5      // r1 = 0x001f
addi r1, r1, 1      // r1 = 0x0020
roli r1, r1, 11     // r1 = 0x0001

lbi r0, U.DataArea
slbi r0, L.DataArea // r0 = .DataArea
st r1, r0, 0        // DataArea = 0x0001

// Factorial test from Casey:

// Load the input parameter into r1 (can be up to 8):
lbi  r1, 6           // r1 = 0x0006
addi r4,r1,0         // Initialize the result to the input param r1

.factorialloop:

addi r5,r1,-2        // Multiply by r1-1, so (r1-2)..0 will be r1-1 times
addi r6,r4,0         // r6 will preserve the original r4
beqz r5,.storeresult // Stop when we are about to multiply by zero!

.multiplyloop:

add r4,r4,r6          // Add r4 to r6 (original r4) and store in r4
addi r5,r5,-1         // Subtract one from multiplication loop counter
bnez r5,.multiplyloop // Keep multiplying until counter reaches zero

addi r1,r1,-1         // Subtract one from the input parameter so it equals n-1 
j .factorialloop      // Keep going until the input param equals one

.storeresult:

lbi r7, U.DataArea
slbi r7, L.DataArea
// Store the result to memory
st r4,r7,2            // DataArea+2 = 0x02d0

// Loop to add up a range of memory;
// complement the sum, then add it all
// on again to sum to 0xffffffff.
// r0:r1 is the accumulator.

lbi r5, 0   // starting location to read data from
lbi r6, 0x10  // loop downcounter
lbi r0, 0   // initialize accumulator
lbi r1, 0   // initialize accumulator

.addloop:
ld r2, r5, 0
ld r3, r5, 2
addi r5, r5, 4
jal .Add32 // Call addition subroutine
addi r6, r6, -1
bnez r6, .addloop

// 1's complement the accumulator:
lbi r6, -1
xor r0, r0, r6
xor r1, r1, r6

lbi r5, 0   // starting location to read data from
lbi r6, 0x10  // loop downcounter

.subloop:
ld r2, r5, 0
ld r3, r5, 2
addi r5, r5, 4
jal .Add32 // Call addition subroutine
addi r6, r6, -1
bnez r6, .subloop

lbi r7, U.DataArea
slbi r7, L.DataArea
st r0, r7, 4    // DataArea+4 = 0xffff
st r1, r7, 6    // DataArea+6 = 0xffff

halt

/////////////////////////////////////
// Subroutine to do 32-bit addition:
// r0:r1 is the accumulator
// r2:r3 is added on
// r4 is a temp
// preserve r5, r6

.Add32:
sco r4, r1, r3
add r1, r1, r3
add r0, r0, r2
add r0, r0, r4
jr r7, 0        // return

halt
halt
halt

.DataArea:
halt          // 0x0001
halt          // 0x02d0
halt          // 0xffff
halt          // 0xffff


