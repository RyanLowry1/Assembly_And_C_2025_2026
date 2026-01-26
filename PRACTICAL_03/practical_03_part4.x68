*-----------------------------------------------------------
* Title      :Part 4
* Written by :Ryan Lowry
* Date       :26/01/26
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA HEALTH, A0
    MOVE.B (A0) , $6000
    
    LEA PLAYERPOINTS, A1
    MOVE.L   (A1), $6001 
    
    LEA PLAYERX, A2
    MOVE.W   (A2), $6010
    
    LEA PLAYERY, A3
    MOVE.W   (A3), $6020
    
    LEA BOSSHEALTH, A4
    MOVE.B   (A4), $6030
    
    LEA BOSSPOINTS, A5
    MOVE.L   (A5), $6040
    
    LEA BOSSX, A6
    MOVE.W   (A6), $6050
    
    LEA BOSSY, A7
    MOVE.W   (A7), $6060
    
    LEA PLAYERAMMO, A0
    MOVE.B (A0), $6070
    
    LEA BOSSAMMO, A1
    MOVE.B  (A1), $6080
    
    LEA PLAYERDAMAGE, A2
    MOVE.B  (A2), $6090
    
    LEA BOSSDAMAGE, A3
    MOVE.B  (A3), $6100


    
    SIMHALT             ; halt simulator
    
HEALTH  dc.b    $64   ;Defines a byte name health with a value of 0

PLAYERPOINTS    dc.l    100

PLAYERX     dc.w    10

PLAYERY     dc.w    100

BOSSHEALTH  dc.b    100

BOSSPOINTS  dc.l    100

BOSSX       dc.w    10

BOSSY       dc.w    100

PLAYERAMMO  dc.b    10

BOSSAMMO    dc.b    100

PLAYERDAMAGE dc.b   100

BOSSDAMAGE  dc.b    100
    

* Put program code here

    


* Put variables and constants here

    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
