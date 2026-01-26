*-----------------------------------------------------------
* Title      :Part 3
* Written by :Ryan Lowry
* Date       :26/01/26
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA HEALTH, A0
    SUB.B   #10, (A3)
    
        
    SIMHALT             ; halt simulator
    
HEALTH  dc.b    $64   ;Defines a byte name health with a value of 0

* Put program code here

 
* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
