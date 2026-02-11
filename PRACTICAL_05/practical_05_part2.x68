*-----------------------------------------------------------
* Title      : Part 2
* Written by : Ryan Lowry
* Date       : 09/02/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA PLAYER_POSITION, A1
    LEA ENEMY_POSITION, A2

    MOVE.B #50, D1
    MOVE.B #55, D2

COLLISION_CHECK:
    MOVE.B  (A1),D0                
    CMP.B   #55,D0
    BNE     NEXT_MOVE

    MOVE.B  1(A1),D0               
    CMP.B   #55,D0
    BNE     NEXT_MOVE
    
    MOVE.B  (A2),D0               
    CMP.B   #55,D0
    BNE     NEXT_MOVE

    MOVE.B  1(A2),D0               
    CMP.B   #55,D0
    BNE     NEXT_MOVE


    BRA     COLLISION

NEXT_MOVE:
    ADD.B #1, D2
    BRA COLLISION_CHECK

COLLISION:
    BRA GAME_OVER

GAME_OVER:

PLAYER_POSITION: DC.B 10, 15
ENEMY_POSITION:  DC.B 50, 55


* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
