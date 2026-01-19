*-----------------------------------------------------------
* Title      : Practical 2 Part 4
* Written by : Ryan Lowry
* Date       : 19/01/2026
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.L  #%1010 , D0 ;Move binary 1010 to data address D0
    MOVE.L  #$1F , D1   ;Move hexadecimal 1F to data address D1
    MOVE.L  #12 , D2    ;Move decimal 12 to data address D2

    
    MOVE.L D0 , $3000   ;Store the value from D0 to memory address $3000
    MOVE.L D1 , $3010
    MOVE.L D2 , $3020
    
    MOVE.L $3000, D3    ;Load the value D3 from memory address $3000
    MOVE.L $3010 , D4
    MOVE.L $3020 , D5

*--------------------------------

    MOVE.B  #%1111 , D0 ;Move binary 1111 to data address D0
    MOVE.B  #$3A , D1
    MOVE.B  #9 , D2
    
    MOVE.B D0 , $3030   ;Store the value from D0 to memory address $3030
    MOVE.B D1 , $3040
    MOVE.B D2 , $3050
    
    MOVE.B $3030, D3    ;Load the value D3 from memory address $3030
    MOVE.B $3040 , D4
    MOVE.B $3050 , D5

*--------------------------------

    MOVE.W  #%1011 , D0 ;Move binary 1011 to data address D0
    MOVE.W  #$8B , D1
    MOVE.W  #2 , D2
    
    MOVE.W D0 , $3090   ;Store the value from D0 to memory address $3090
    MOVE.W D1 , $3100
    MOVE.W D2 , $3110
    
    MOVE.W $3090 , D3   ;Load the value D3 from memory address $3090
    MOVE.W $3100 , D4
    MOVE.W $3110 , D5




    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
