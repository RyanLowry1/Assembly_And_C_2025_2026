*-------------------------------------------------------
* NAME:        Ryan Lowry
* STUDENT ID:  C00305950
* DATE:        27/02/2026
*
* PROJECT:     Alternative Physics Text Based Game
*
*-------------------------------------------------------
        ORG $1000

CHOICE_MIN  EQU 1
CHOICE_MAX  EQU 3

*-------------------------------------------------------
* START OF GAME
*-------------------------------------------------------
START:
    BSR     RESET_GAME
    BSR     WELCOME
    BSR     GAME

END_GAME:
    SIMHALT

*-------------------------------------------------------
* RESET GAME VALUES
*-------------------------------------------------------
RESET_GAME:
    MOVE.W  #100,PLAYER_HP
    MOVE.W  #500,GIANT_HP
    MOVE.W  #0,DAYS_SURVIVED
    RTS

*-------------------------------------------------------
* GAME
*-------------------------------------------------------
GAME:
    BSR     GAMELOOP
    RTS

*-------------------------------------------------------
* MAIN LOOP
*-------------------------------------------------------
GAMELOOP:
    BSR     SEPARATOR
    BSR     HUD
    BSR     PLAYER_CHOICE
    BSR     UPDATE
    BSR     CHECK_END
    BRA     GAMELOOP

*-------------------------------------------------------
* WELCOME
*-------------------------------------------------------
WELCOME:
    BSR     ENDL
    LEA     WELCOME_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

*-------------------------------------------------------
* PLAYER INPUT
*-------------------------------------------------------
PLAYER_CHOICE:
    BSR     ENDL
    LEA     CHOICE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.B  #4,D0
    TRAP    #15

    CMP.B   #CHOICE_MIN,D1
    BLT     PLAYER_CHOICE
    CMP.B   #CHOICE_MAX,D1
    BGT     PLAYER_CHOICE

    MOVE.B  D1,CHOICE
    RTS

*-------------------------------------------------------
* UPDATE GAME STATE
*-------------------------------------------------------
UPDATE:
    ADD.W   #1,DAYS_SURVIVED

    MOVE.B  CHOICE,D0

    CMP.B   #1,D0
    BEQ     ATTACK

    CMP.B   #2,D0
    BEQ     REST

    CMP.B   #3,D0
    BEQ     HIDE

    RTS

ATTACK:
    SUB.W   #20,GIANT_HP
    SUB.W   #50,PLAYER_HP
    LEA     ATTACK_MSG,A1
    BRA     PRINT_EVENT

REST:
    ADD.W   #10,PLAYER_HP
    LEA     REST_MSG,A1
    BRA     PRINT_EVENT

HIDE:
    SUB.W   #10,PLAYER_HP

    MOVE.W  DAYS_SURVIVED,D0
    DIVU    #3,D0
    SWAP    D0
    CMP.W   #0,D0
    BNE     SAFE_HIDE

    SUB.W   #50,PLAYER_HP
    LEA     FOUND_MSG,A1
    BRA     PRINT_EVENT

SAFE_HIDE:
    LEA     HIDE_MSG,A1

PRINT_EVENT:
    MOVE.B  #14,D0
    TRAP    #15
    RTS

*-------------------------------------------------------
* CHECK WIN / LOSE
*-------------------------------------------------------
CHECK_END:
    CMP.W   #0,PLAYER_HP
    BLE     PLAYER_DEAD

    CMP.W   #0,GIANT_HP
    BLE     GIANT_DEAD

    RTS

PLAYER_DEAD:
    BSR     SEPARATOR
    LEA     LOSE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     REPLAY
    RTS

GIANT_DEAD:
    BSR     SEPARATOR
    LEA     WIN_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     REPLAY
    RTS

*-------------------------------------------------------
* REPLAY OPTION
*-------------------------------------------------------
REPLAY:
    BSR     ENDL
    LEA     REPLAY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.B  #4,D0
    TRAP    #15

    CMP.B   #0,D1
    BEQ     END_GAME

    CMP.B   #1,D1
    BEQ     RESTART_GAME

    BRA     REPLAY

RESTART_GAME:
    BSR     RESET_GAME
    BRA     GAMELOOP

*-------------------------------------------------------
* HUD
*-------------------------------------------------------
HUD:
    BSR     ENDL
    LEA     PLAYER_HP_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.W  PLAYER_HP,D1
    MOVE.B  #3,D0
    TRAP    #15

    BSR     ENDL
    LEA     GIANT_HP_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.W  GIANT_HP,D1
    MOVE.B  #3,D0
    TRAP    #15

    BSR     ENDL
    LEA     DAY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15

    MOVE.W  DAYS_SURVIVED,D1
    MOVE.B  #3,D0
    TRAP    #15
    RTS

*-------------------------------------------------------
* SEPARATOR
*-------------------------------------------------------
SEPARATOR:
    BSR     ENDL
    LEA     LINE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     ENDL
    RTS

*-------------------------------------------------------
* ENDL
*-------------------------------------------------------
ENDL:
    MOVEM.L D0/A1,-(A7)
    MOVE    #14,D0
    LEA     CRLF,A1
    TRAP    #15
    MOVEM.L (A7)+,D0/A1
    RTS

*-------------------------------------------------------
* DATA
*-------------------------------------------------------
CRLF:           DC.B    $0D,$0A,0

LINE_MSG:       DC.B '============================================================',0

WELCOME_MSG:    DC.B 'YOU ARE TINY. A GIANT STANDS BEFORE YOU.',0
CHOICE_MSG:     DC.B 'CHOOSE: 1=ATTACK  2=REST  3=HIDE : ',0

ATTACK_MSG:     DC.B 'YOU STRIKE THE GIANT! IT HITS BACK HARD!',0
REST_MSG:       DC.B 'YOU REST AND RECOVER STRENGTH.',0
HIDE_MSG:       DC.B 'YOU HIDE SUCCESSFULLY.',0
FOUND_MSG:      DC.B 'THE GIANT FINDS YOU WHILE HIDING!',0

PLAYER_HP_MSG:  DC.B 'PLAYER HEALTH: ',0
GIANT_HP_MSG:   DC.B 'GIANT HEALTH: ',0
DAY_MSG:        DC.B 'DAYS SURVIVED: ',0

WIN_MSG:        DC.B 'YOU DEFEATED THE GIANT! VICTORY!',0
LOSE_MSG:       DC.B 'YOU HAVE FALLEN. THE GIANT REMAINS.',0
REPLAY_MSG:     DC.B 'PRESS 0 TO QUIT OR 1 TO PLAY AGAIN: ',0

CHOICE:         DS.B    1
PLAYER_HP:      DS.W    1
GIANT_HP:       DS.W    1
DAYS_SURVIVED:  DS.W    1

    END START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
