*-----------------------------------------------------------
* Title      : Part 2
* Written by : Ryan Lowry
* Date       : 26/01/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA $4000, A2   ;Load effectobe address $4000 into register A2
    MOVE.B #100, (A2)   ;Moves byte value 100 to A2
    SUB.B  #10, (A2)    ;Subtracts 10 from value in A2

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
