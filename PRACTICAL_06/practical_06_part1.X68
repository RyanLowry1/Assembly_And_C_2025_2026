*-----------------------------------------------------------
* Title      : Part 1
* Written by : Ryan Lowry
* Date       : 23/02/26
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    ORG $1000
START:
    ; Move Trap Task to D0
    MOVE.B #2, D0
    ; Interrupt and Trap Task
    TRAP   #15

    LEA    MESSAGE, A1
    MOVE.B #13, D0
    TRAP   #15

END_PROG:

MESSAGE: DC.B 'Trap Task Test', 0

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
