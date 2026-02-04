*-----------------------------------------------------------
* Title      :Part 4
* Written by :Ryan Lowry
* Date       :04/02/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    MOVE.B  #100, $3000

    MOVE.B  #$5, $3001

    MOVE.B  #$12, D2

    MOVE.B  #$22, D3

    MOVE.B  #$12, $3002      ; Player X and Y Position
    MOVE.B  #100, $3003      ; Boss Health
    MOVE.B  #$22, $3004      ; Boss X and Y Position

    LEA     $3000,  A1

    AND.B   D2, D3
    OR.B    D2, D3
    EOR.B   D2, D3

    BSR     TAKING_DAMAGE
    BSR     HEALTH_PICKUP
    BSR     BOSS_DAMAGE
    BRA     GAME_END

    TAKING_DAMAGE:
    SUB.B   #20, (A1)
    RTS

    HEALTH_PICKUP:
    ADD.B   #10, (A1)
    ADD.B   #5, 1(A1)
    RTS

    BOSS_DAMAGE:
    SUB.B   #10, 3(A1)
    ADD.B   #1, 4(A1)
    RTS

    GAME_END:
    MOVE.B  #$00, (A1)
* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
