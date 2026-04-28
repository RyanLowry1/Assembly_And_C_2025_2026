// Name : Ryan Lowry
// File : Test.c

#include <stdio.h>
#include <assert.h>   // used for testing results

// tell C that this function exists in assembly
extern int REGISTER_ADDER(int a, int b);

int main() {

    int result;   // variable to store returned value

    // test different inputs
    result = REGISTER_ADDER(1, 2);     // 1 + 2
    assert(result == 3);               // check result is correct

    result = REGISTER_ADDER(10, 5);    // 10 + 5
    assert(result == 15);

    result = REGISTER_ADDER(0, 0);     // 0 + 0
    assert(result == 0);

    result = REGISTER_ADDER(-1, 1);    // -1 + 1
    assert(result == 0);

    printf("All tests passed!\n");     // only prints if all tests succeed

    return 0;
}
