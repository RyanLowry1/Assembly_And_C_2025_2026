// Name : Ryan Lowry
// File : Test.c
#include <stdio.h>      // needed for printf and scanf

// function that adds two numbers 
int REGISTER_ADDER(int a, int b) {
    return a + b;       // return the result of a + b
}

int main() {

    int num1, num2;     // variables to store users input
    int sum = 0;        // running total of all results

    // loop runs 3 times
    for (int i = 0; i < 3; i++) {

        printf("Enter first number: ");     // ask user for first number
        scanf("%d", &num1);                 // read first number

        printf("Enter second number: ");    // ask for second number
        scanf("%d", &num2);                 // read second number

        int result = REGISTER_ADDER(num1, num2);   // call function to add numbers

        printf("The sum is: %d\n", result);  // print result

        sum += result;                      // add result to total
    }

    printf("Final sum is: %d\n", sum);      // print final total after loop

    return 0;      // end program
}
