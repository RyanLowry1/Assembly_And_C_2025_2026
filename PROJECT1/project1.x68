*-------------------------------------------------------
* NAME:        Ryan Lowry
* STUDENT ID:  C00305950
* DATE:        27/02/2026
*
* PROJECT:     Alternative Physics Text Based Game
*
*-------------------------------------------------------

*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
        ORG $1000

*-------------------------------------------------------
* VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*-------------------------------------------------------
EXIT        EQU 0           ; used to exit program
MIN_CHOICE  EQU 1           ; minimum menu choice
MAX_CHOICE  EQU 3           ; maximum menu choice

*-------------------------------------------------------
* START OF GAME
*-------------------------------------------------------
START:
    BSR RESET_GAME          ; initialise all variables
    BSR WELCOME             ; display welcome screen
    BSR GAME                ; branch to game subroutine

END:
    SIMHALT                 ; stop program execution

*-------------------------------------------------------
*-------------------GAME SUBROUTINE---------------------
*-------------------------------------------------------
GAME:
    BSR GAMELOOP            ; branch to main loop
    RTS                     ; return from subroutine

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
* This is the core loop of the game.
* It keeps running until win/lose condition is met.
*-------------------------------------------------------
GAMELOOP:
    BSR SEPARATOR           ; print visual separator
    BSR HUD                 ; show player stats
    BSR INPUT               ; get player decision
    BSR UPDATE              ; update resources
    BSR DRAW                ; handle weather events
    BSR CHECK_END           ; check win/lose
    BRA GAMELOOP            ; repeat loop

*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
* Displays intro message.
*-------------------------------------------------------
WELCOME:
    BSR ENDL
    LEA WELCOME_MSG,A1
    MOVE.B #14,D0
    TRAP #15                ; print welcome text
    RTS

*-------------------------------------------------------
*---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
*-------------------------------------------------------
INPUT:
    BSR ENDL
    LEA CHOICE_MSG,A1
    MOVE.B #14,D0
    TRAP #15                ; display menu

    MOVE.B #4,D0
    TRAP #15                ; read user input into D1

    CMP.B #MIN_CHOICE,D1
    BLT INPUT               ; if invalid, asks again
    CMP.B #MAX_CHOICE,D1
    BGT INPUT

    MOVE.B D1,CHOICE        ; store valid choice
    RTS

*-------------------------------------------------------
*----------------UPDATE QUEST PROGRESS------------------
*-------------------------------------------------------
UPDATE:
    ADD.W #1,DAYS           ; each action increases day count

    MOVE.B CHOICE,D0

    CMP.B #1,D0
    BEQ ATTACK

    CMP.B #2,D0
    BEQ LOOT

    CMP.B #3,D0
    BEQ HIDE

    RTS

*---------------- ATTACK OPTION ------------------------
ATTACK:
    SUB.W #50,GIANT_HP      ; giant loses 50 HP
    SUB.W #50,HEALTH        ; player also loses 50 HP
    LEA ATTACK_MSG,A1
    BRA PRINT_ACTION

*---------------- LOOT OPTION --------------------------
LOOT:
    ADD.W #10,BRAVERY       ; increase bravery
    SUB.W #10,HEALTH        ; lose health
    LEA LOOT_MSG,A1
    BRA PRINT_ACTION

*---------------- HIDE OPTION --------------------------
HIDE:
    SUB.W #20,BRAVERY       ; hiding loses bravery
    ADD.W #20,HEALTH        ; hiding gains health

    ADD.W #1,HIDE_COUNT     ; count how many times hidden

    CMP.W #3,HIDE_COUNT     ; every 3rd hide
    BLT SAFE_HIDE

    CLR.W HIDE_COUNT        ; reset counter
    SUB.W #50,HEALTH        ; giant finds player
    LEA FOUND_MSG,A1
    BRA PRINT_ACTION

SAFE_HIDE:
    LEA HIDE_MSG,A1

PRINT_ACTION:
    MOVE.B #14,D0
    TRAP #15                ; print action result
    RTS

*-------------------------------------------------------
*-----------------DRAW QUEST UPDATES--------------------
*-------------------------------------------------------
DRAW:
    MOVE.W DAYS,D0
    DIVU #2,D0
    SWAP D0
    CMP.W #0,D0
    BNE NO_WEATHER          ; only if divisible by 2

    MOVE.W DAYS,D0
    DIVU #3,D0
    SWAP D0                 ; remainder determines weather type

    CMP.W #0,D0
    BEQ STORM
    CMP.W #1,D0
    BEQ BLIZZARD
    BRA SUN

STORM:
    SUB.W #20,HEALTH        ; storm damage
    LEA STORM_MSG,A1
    BRA WEATHER_PRINT

BLIZZARD:
    SUB.W #50,HEALTH        ; blizzard damage
    LEA BLIZZARD_MSG,A1
    BRA WEATHER_PRINT

SUN:
    LEA SUN_MSG,A1          ; no damage

WEATHER_PRINT:
    BSR ENDL                ; print on new line
    MOVE.B #14,D0
    TRAP #15
NO_WEATHER:
    RTS

*-------------------------------------------------------
*-----------------HEADS UP DISPLAY (HUD)----------------
*-------------------------------------------------------
HUD:
    BSR ENDL
    LEA HP_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.W HEALTH,D1
    MOVE.B #3,D0
    TRAP #15

    BSR ENDL
    LEA BRAVERY_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.W BRAVERY,D1
    MOVE.B #3,D0
    TRAP #15

    BSR ENDL
    LEA DAY_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.W DAYS,D1
    MOVE.B #3,D0
    TRAP #15
    RTS

*-------------------------------------------------------
*-----------------------CHECK END-----------------------
*-------------------------------------------------------
CHECK_END:
    CMP.W #0,HEALTH
    BLE PLAYER_DEAD         ; lose if health <= 0

    CMP.W #0,BRAVERY
    BLE PLAYER_COWARD       ; lose if bravery <= 0

    CMP.W #10,DAYS
    BGE PLAYER_WIN          ; win if survived 10 days

    CMP.W #0,GIANT_HP
    BLE PLAYER_WIN          ; also win if giant defeated

    RTS

PLAYER_DEAD:
    LEA LOSE_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    BSR REPLAY
    RTS

PLAYER_COWARD:
    LEA COWARD_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    BSR REPLAY
    RTS

PLAYER_WIN:
    LEA WIN_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    BSR REPLAY
    RTS

*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------
REPLAY:
    BSR ENDL
    LEA REPLAY_MSG,A1
    MOVE.B #14,D0
    TRAP #15

    MOVE.B #4,D0
    TRAP #15                ; read replay input

    CMP.B #0,D1
    BEQ END

    CMP.B #1,D1
    BEQ RESET_AND_RESTART

    BRA REPLAY              ; force valid input

RESET_AND_RESTART:
    BSR RESET_GAME
    BRA GAMELOOP

*-------------------------------------------------------
*-------------------RESET GAME--------------------------
*-------------------------------------------------------
RESET_GAME:
    MOVE.W #100,HEALTH
    MOVE.W #100,BRAVERY
    MOVE.W #0,DAYS
    MOVE.W #250,GIANT_HP
    CLR.W HIDE_COUNT
    RTS

*-------------------------------------------------------
*------------------SCREEN DECORATION--------------------
*-------------------------------------------------------
SEPARATOR:
    BSR ENDL
    LEA LINE_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    RTS

ENDL:
    MOVEM.L D0/A1,-(A7)
    MOVE #14,D0
    LEA CRLF,A1
    TRAP #15
    MOVEM.L (A7)+,D0/A1
    RTS

*-------------------------------------------------------
*-------------------DATA DECLARATIONS--------------------
*-------------------------------------------------------
CRLF:          DC.B $0D,$0A,0
LINE_MSG:      DC.B '====================================================',0

WELCOME_MSG:   DC.B 'SURVIVE THE GIANT OR DEFEAT IT!',0
CHOICE_MSG:    DC.B '1=ATTACK  2=LOOT  3=HIDE : ',0

ATTACK_MSG:    DC.B 'YOU ATTACK! BOTH TAKE DAMAGE!',0
LOOT_MSG:      DC.B 'YOU LOOT AND GAIN BRAVERY.',0
HIDE_MSG:      DC.B 'YOU HIDE SUCCESSFULLY.',0
FOUND_MSG:     DC.B 'THE GIANT FINDS YOU WHILE HIDING!',0

STORM_MSG:     DC.B 'STORM! -20 HEALTH!',0
BLIZZARD_MSG:  DC.B 'BLIZZARD! -50 HEALTH!',0
SUN_MSG:       DC.B 'SUNNY DAY. NO DAMAGE.',0

HP_MSG:        DC.B 'HEALTH: ',0
BRAVERY_MSG:   DC.B 'BRAVERY: ',0
DAY_MSG:       DC.B 'DAY: ',0

WIN_MSG:       DC.B 'YOU SURVIVED OR DEFEATED THE GIANT!',0
LOSE_MSG:      DC.B 'YOU WERE CRUSHED WHILE LOOTING',0
COWARD_MSG:    DC.B 'YOU LOST ALL BRAVERY AND RAN AWAY!',0
REPLAY_MSG:    DC.B '0=QUIT  1=PLAY AGAIN : ',0

CHOICE:        DS.B 1
HEALTH:        DS.W 1
BRAVERY:       DS.W 1
DAYS:          DS.W 1
GIANT_HP:      DS.W 1
HIDE_COUNT:    DS.W 1

    END START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
