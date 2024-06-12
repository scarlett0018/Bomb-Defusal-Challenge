# Bomb Defusal Challenge

## Overview

This project consists of a bomb defusal challenge, commonly used in systems programming courses to teach debugging, reverse engineering, and low-level programming skills. The bomb is a program that contains multiple phases, each requiring a specific input to defuse and proceed to the next phase.

## Project Structure

- **utils.c**: Contains various bitwise and arithmetic functions.
- **sema.c**: Manages semaphore operations for concurrent processes.
- **fshow.c**: Functions for displaying floating-point values.
- **ishow.c**: Functions for displaying integer values.
- **btest.c**: Main test harness to run and validate the implemented functions.
- **btest_server.c**: Manages batch execution of tests in a client-server setup.
- **bomb**: Compiled binary executable of the bomb program.
- **bomb.c**: Source code of the bomb program with multiple phases to defuse.
- **input.txt**: Contains input data for testing or running the bomb program.
- **README**: Provides identification information about the bomb.

## Files and Functions

### utils.c
- **isZero**: Check if a number is zero.
- **bitNor**: Perform bitwise NOR operation.
- **distinctNegation**: Check if negation is distinct.
- **dividePower2**: Divide by a power of 2.
- **getByte**: Get a specific byte from a word.
- **isPositive**: Check if a number is positive.
- **floatNegate**: Negate a floating-point number.
- **isLessOrEqual**: Check if a number is less than or equal to another.
- **bitMask**: Create a bit mask.
- **addOK**: Check if addition does not overflow.

### sema.c
- Handles semaphore initialization, waiting, and posting for safe concurrent access to shared resources.

### fshow.c & ishow.c
- Functions for converting and printing floating-point and integer values, respectively.

### btest.c
- Test harness for parsing command-line arguments, setting up tests, and executing functions with various inputs.

### btest_server.c
- Manages execution of tests in a batch, using shared memory and semaphores for synchronization.

### bomb.c
- Main logic of the bomb program with multiple phases that must be defused.

### input.txt
- Contains example inputs for the bomb program.

### README
- Identifies the bomb and its owner.

## How to Use

1. **Compile the Bomb**:
    ```
    gcc -o bomb bomb.c utils.c sema.c fshow.c ishow.c btest.c btest_server.c
    ```

2. **Run the Bomb**:
    ```
    ./bomb < input.txt
    ```

3. **Defuse the Bomb**:
    - Analyze the source code to understand each phase.
    - Provide the correct input for each phase to proceed.

4. **Testing**:
    - Use `btest.c` and `btest_server.c` to validate the functions in `utils.c`.
