*-------------------------------------------------------
* NAME:        Ryan Lowry
* STUDENT ID:  C00305950
* DATE:        05/03/2026
*
* PROJECT:     Alternative Physics Text Based Game
*
*-------------------------------------------------------

*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
        ORG $1000                 ; start address for program in memory

*-------------------------------------------------------
* VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*-------------------------------------------------------
EXIT        EQU 0                 ; value used to exit program
MIN_CHOICE  EQU 1                 ; minimum menu choice allowed
MAX_CHOICE  EQU 4                 ; maximum menu choice
*-------------------------------------------------------
* START OF GAME
*-------------------------------------------------------
START:
    BSR RESET_GAME                ; initialise all game variables
    BSR WELCOME                   ; display welcome screen
    BSR GAME                      ; branch to game subroutine

END:
    BRA RESTART_GAME

*-------------------------------------------------------
*-------------------GAME SUBROUTINE---------------------
*-------------------------------------------------------
GAME:
    BSR GAMELOOP                  ; branch to main loop
    RTS                           ; return from subroutine

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
* This loop keeps the game running each turn
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
* Displays intro message
*-------------------------------------------------------
WELCOME:
    BSR ENDL                      ; move to new line
    LEA WELCOME_MSG,A1            ; load address of welcome text
    MOVE.B #14,D0                 ; trap command to print string
    TRAP #15                      ; print welcome text
    RTS                           ; return to caller

*-------------------------------------------------------
*---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
*-------------------------------------------------------
INPUT:
    BSR ENDL                      ; move to new line
    LEA CHOICE_MSG,A1             ; load menu text
    MOVE.B #14,D0                 ; prepare to print string
    TRAP #15                      ; display menu

    MOVE.B #4,D0                  ; trap command to read input
    TRAP #15                      ; read user input into D1

    CMP.B #MIN_CHOICE,D1          ; check if input < 1
    BLT INPUT                     ; if invalid, asks again
    CMP.B #MAX_CHOICE,D1          ; check if input > 4
    BGT INPUT                     ; ask again if too big

    MOVE.B D1,CHOICE              ; store valid choice
    RTS                           ; return

*-------------------------------------------------------
*----------------UPDATE QUEST PROGRESS------------------
*-------------------------------------------------------
UPDATE:
    ADD.W #1,DAYS                 ; each action increases day count

    MOVE.B CHOICE,D0              ; load player choice

    CMP.B #1,D0                   ; compare choice to 1
    BEQ ATTACK                    ; branch if player attacks

    CMP.B #2,D0                   ; compare choice to 2
    BEQ LOOT                      ; branch if player loots

    CMP.B #3,D0                   ; compare choice to 3
    BEQ HIDE                      ; branch if player hides

    CMP.B #4,D0                   ; compare choice to 4
    BEQ SHOOT                     ; branch if player shoots

    RTS                           ; return if no match

*---------------- ATTACK OPTION ------------------------
ATTACK:
    SUB.W #30,HEALTH              ; player loses some health
    ADD.W #5,BRAVERY              ; player gains bravery
    SUB.W #40,GIANT_HP            ; giant loses health
    LEA ATTACK_MSG,A1             ; load attack message
    BRA PRINT_ACTION              ; print action result

*---------------- LOOT OPTION --------------------------
LOOT:
    ADD.W #5,BRAVERY
    SUB.W #10,HEALTH
    ADD.W #1,LOOT_COUNT
    ADD.W #1,ARROWS
    LEA LOOT_MSG,A1               ; load loot message
    BRA PRINT_ACTION              ; print result

*---------------- HIDE OPTION --------------------------
HIDE:
    SUB.W #25,BRAVERY             ; hiding loses bravery
    ADD.W #25,HEALTH              ; hiding gains health

    ADD.W #1,HIDE_COUNT           ; count how many times hidden
    
    CMP.W #3,HIDE_COUNT           ; every 3rd hide
    BLT SAFE_HIDE                 ; safe if less than 3

    CLR.W HIDE_COUNT              ; reset counter
    SUB.W #45,HEALTH              ; giant finds player
    LEA FOUND_MSG,A1              ; load found message
    BRA PRINT_ACTION              ; print result

SAFE_HIDE:
    LEA HIDE_MSG,A1               ; load hide success message
    BRA PRINT_ACTION                ; print action result
    
PRINT_ACTION:
    MOVE.B #14,D0                 ; trap command for printing
    TRAP #15                      ; print action message
    RTS                           ; return to game loop

*---------------- SHOOT OPTION -------------------------
SHOOT:
    CMP.W #0,ARROWS               ; check if player has arrows
    BLE NO_ARROWS                 ; branch if none

    SUB.W #1,ARROWS               ; use one arrow
    ADD.W #1,SHOOT_COUNT          ; track shots fired

    MOVE.W SHOOT_COUNT,D0         ; copy shot count
    AND.W #1,D0                   ; check odd/even

    CMP.W #0,D0                   ; check result
    BNE AUTO_HIT                  ; odd shots always hit

    MOVE.W DAYS,D0                ; load day number
    AND.W #1,D0                   ; use day for random chance

    CMP.W #0,D0                   ; check if miss
    BEQ MISS                      ; branch to miss
    BRA HIT                       ; otherwise hit

AUTO_HIT:
HIT:
    SUB.W #40,GIANT_HP            ; giant loses health
    LEA HIT_MSG,A1                ; load hit message
    BRA PRINT_ACTION              ; print result

MISS:
    LEA MISS_MSG,A1               ; load miss message
    BRA PRINT_ACTION              ; print result

NO_ARROWS:
    LEA NO_ARROW_MSG,A1           ; load no arrow message
    BRA PRINT_ACTION              ; print result

*-------------------------------------------------------
*-----------------DRAW QUEST UPDATES--------------------
*-------------------------------------------------------

DRAW:
    MOVE.W DAYS,D0        ; copy current day number

CHECK_MOD3:
    CMP.W #3,D0           ; check if less than 3
    BLT NO_WEATHER        ; if <3 then no weather

    BEQ WEATHER_DAY       ; if exactly 3 then weather triggers

    SUB.W #3,D0           ; subtract 3
    BRA CHECK_MOD3        ; keep checking


WEATHER_DAY:
    MOVE.W DAYS,D0        ; reload original day value
    AND.W #1,D0           ; check if day is odd or even

    CMP.W #0,D0
    BEQ SUNNY             ; even days = sunny

    BRA STORM             ; odd days = storm


STORM:
    SUB.W #20,HEALTH      ; storm damages player
    LEA STORM_MSG,A1      ; load storm message
    BRA WEATHER_PRINT


SUNNY:
    LEA SUN_MSG,A1        ; load sunny message


WEATHER_PRINT:
    BSR ENDL              ; move to new line
    MOVE.B #14,D0         ; trap command for printing
    TRAP #15              ; print message
    RTS                   ; return to game


NO_WEATHER:
    RTS                   ; return if no weather
*-------------------------------------------------------
*-----------------HEADS UP DISPLAY (HUD)----------------
*-------------------------------------------------------
HUD:
    BSR ENDL                      ; new line
    LEA HP_MSG,A1                 ; load health label
    MOVE.B #14,D0
    TRAP #15                      ; print label
    MOVE.W HEALTH,D1              ; move health to D1
    MOVE.B #3,D0
    TRAP #15                      ; print health value

    BSR ENDL                      ; new line
    LEA BRAVERY_MSG,A1            ; load bravery label
    MOVE.B #14,D0
    TRAP #15
    MOVE.W BRAVERY,D1
    MOVE.B #3,D0
    TRAP #15                      ; print bravery value

    BSR ENDL
    LEA DAY_MSG,A1                ; load day label
    MOVE.B #14,D0
    TRAP #15
    MOVE.W DAYS,D1
    MOVE.B #3,D0
    TRAP #15                      ; print days survived

    BSR ENDL
    LEA GIANT_MSG,A1              ; load giant hp label
    MOVE.B #14,D0
    TRAP #15
    MOVE.W GIANT_HP,D1
    MOVE.B #3,D0
    TRAP #15                      ; print giant hp

    BSR ENDL
    LEA ARROW_MSG,A1              ; load arrow label
    MOVE.B #14,D0
    TRAP #15
    MOVE.W ARROWS,D1
    MOVE.B #3,D0
    TRAP #15                      ; print arrow count
    RTS                           ; return

*-------------------------------------------------------
*-----------------------CHECK END-----------------------
*-------------------------------------------------------
CHECK_END:
    CMP.W #0,HEALTH                 ; check player health
    BLE PLAYER_DEAD                 ; lose if health <= 0

    CMP.W #0,BRAVERY                ; check bravery
    BLE PLAYER_COWARD               ; lose if bravery <= 0

    CMP.W #0,GIANT_HP               ; check giant health
    BGT CONTINUE_GAME               ; continue if giant alive
    
    
    BSR WIN_WITH_DAYS             ; player wins
    BRA RESTART_GAME

CONTINUE_GAME:
    RTS

PLAYER_DEAD:
    LEA LOSE_MSG,A1               ; load lose message
    MOVE.B #14,D0
    TRAP #15                      ; display lose message
    BRA RESTART_GAME

PLAYER_COWARD:
    LEA COWARD_MSG,A1             ; load coward message
    MOVE.B #14,D0
    TRAP #15                      ; display coward message
    BRA RESTART_GAME                       ; stop program

*-------------------------------------------------------
*----------------------PLAYER WIN-----------------------
*-------------------------------------------------------
WIN_WITH_DAYS:
    BSR ENDL                      ; move to new line
    LEA WIN_MSG,A1                ; load win message
    MOVE.B #14,D0
    TRAP #15                      ; print win text

    BSR ENDL
    LEA DAY_MSG,A1                ; print day label
    MOVE.B #14,D0
    TRAP #15

    MOVE.W DAYS,D1                ; load day value
    MOVE.B #3,D0
    TRAP #15                      ; print number of days
    RTS

*-------------------------------------------------------
*-------------------RESET GAME--------------------------
*-------------------------------------------------------
RESTART_GAME:
    BSR ENDL
    LEA RESTART_MSG,A1
    MOVE.B #14,D0
    TRAP #15                 ; print restart message

    MOVE.B #4,D0
    TRAP #15                 ; read input into D1

    CMP.B #0,D1
    BEQ EXIT_GAME            ; 0 = exit

    CMP.B #1,D1
    BEQ RESTART              ; 1 = restart

    BRA RESTART_GAME         ; invalid input asks again


RESTART:
    BRA START


EXIT_GAME:
    SIMHALT                  ; stop program
    
RESET_GAME:
    MOVE.W #150,HEALTH            ; starting player health
    MOVE.W #100,BRAVERY           ; starting bravery
    MOVE.W #0,DAYS                ; reset day counter
    MOVE.W #250,GIANT_HP          ; giant starting health
    CLR.W HIDE_COUNT              ; reset hide counter
    CLR.W ARROWS                  ; reset arrow count
    CLR.W LOOT_COUNT              ; reset loot counter
    CLR.W SHOOT_COUNT             ; reset shoot counter
    RTS                           ; return

*-------------------------------------------------------
*------------------SCREEN DECORATION--------------------
*-------------------------------------------------------
SEPARATOR:
    BSR ENDL                      ; new line
    LEA LINE_MSG,A1               ; load separator line
    MOVE.B #14,D0
    TRAP #15                      ; print separator
    RTS

ENDL:
    MOVEM.L D0/A1,-(A7)           ; save registers
    MOVE #14,D0                   ; trap command
    LEA CRLF,A1                   ; load newline chars
    TRAP #15                      ; print newline
    MOVEM.L (A7)+,D0/A1           ; restore registers
    RTS                           ; return

*-------------------------------------------------------
*-------------------DATA DECLARATIONS-------------------
*-------------------------------------------------------
CRLF:          DC.B $0D,$0A,0
LINE_MSG:      DC.B '====================================================',0

WELCOME_MSG:   DC.B 'SURVIVE THE GIANT OR DEFEAT IT!',0
CHOICE_MSG:    DC.B '1=ATTACK  2=LOOT  3=HIDE  4=SHOOT : ',0
RESTART_MSG:   DC.B 'PLAY AGAIN? 1=YES 0=NO : ',0

ATTACK_MSG:    DC.B 'YOU ATTACK! BOTH TAKE DAMAGE!',0
LOOT_MSG:      DC.B 'YOU LOOT AND GAIN BRAVERY.',0
HIDE_MSG:      DC.B 'YOU HIDE SUCCESSFULLY.',0
FOUND_MSG:     DC.B 'THE GIANT FINDS YOU WHILE HIDING!',0

HIT_MSG:       DC.B 'YOU SHOOT THE GIANT! -40 HP!',0
MISS_MSG:      DC.B 'YOU MISSED THE GIANT!',0
NO_ARROW_MSG:  DC.B 'NO ARROWS LEFT!',0

STORM_MSG:     DC.B 'STORM! -20 HEALTH!',0
SUN_MSG:       DC.B 'SUNNY DAY. NO DAMAGE.',0

HP_MSG:        DC.B 'HEALTH: ',0
BRAVERY_MSG:   DC.B 'BRAVERY: ',0
DAY_MSG:       DC.B 'DAYS: ',0
GIANT_MSG:     DC.B 'GIANT HP: ',0
ARROW_MSG:     DC.B 'ARROWS: ',0

WIN_MSG:       DC.B 'YOU DEFEATED THE GIANT IN:',0
LOSE_MSG:      DC.B 'YOU WERE CRUSHED BY THE GIANT',0
COWARD_MSG:    DC.B 'YOU LOST ALL BRAVERY AND RAN AWAY!',0

CHOICE:        DS.B 1             ; stores player menu choice
HEALTH:        DS.W 1             ; player health value
BRAVERY:       DS.W 1             ; player bravery value
DAYS:          DS.W 1             ; number of days survived
GIANT_HP:      DS.W 1             ; giant health value
HIDE_COUNT:    DS.W 1             ; count number of hides
ARROWS:        DS.W 1             ; player arrows
LOOT_COUNT:    DS.W 1             ; number of loot actions
SHOOT_COUNT:   DS.W 1             ; number of shots fired

        END START
