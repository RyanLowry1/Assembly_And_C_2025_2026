*-----------------------------------------------------------
* Title      : Part 3
* Written by : Ryan Lowry
* Date       : 23/02/26
* Description:
*-----------------------------------------------------------
    ORG    $1000

START:
    LEA   $4000, A7

    MOVE.B #1, -(A7)
    MOVE.B #2, -(A7)
    MOVE.B #3, -(A7)
    MOVE.B #4, -(A7)

    MOVE.B (A7)+, D1
    MOVE.B (A7)+, D1
    MOVE.B (A7)+, D1
    MOVE.B (A7)+, D1

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
