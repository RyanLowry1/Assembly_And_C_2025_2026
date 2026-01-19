*-----------------------------------------------------------
* Title      :  Practical_02_Part1
* Written by :  Ryan Lowry
* Date       :  19/01/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    
    MOVE.L  #%100,  D0  ; Load binary value 100 into register D0
    MOVE.L  #$100,  D1  ; Load hexadecimal 100 into register D1
    MOVE.L  #100,   D2  ; Load hexadecimal 100 into register D2

    MOVE.L  D0, $3000   ; Stores content of D0 into memory address $3000
    MOVE.L  D1, $3010   ; Stores content of D1 into memory address $3010
    MOVE.L  D2, $3020   ; Stores content of D2 into memory address $3020

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
