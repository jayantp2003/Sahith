;
; ncs_04_03_3.asm
;
; Created: 04-03-2024 03:20:25 PM
; Author :NC SAHITH
;


// Custom Shape on LCD in 4-bit Mode
.INCLUDE "M32DEF.INC"
.ORG 0x0000
 
LDI R16,HIGH(RAMEND)
OUT SPH,R16
LDI R16,LOW(RAMEND)
OUT SPL,R16
 
// Data Direction Register Settings
LDI R16,0xF0
OUT DDRB,R16
 
SBI DDRD,PIND0 //Falling Edged Enable
SBI DDRD,PIND1 //Register Select
 
// LCD 4-bit mode initialization
CBI PORTD,PIND1 // Command Register Enable
LDI R16,0x20 // 4-bit Mode 
OUT PORTB,R16
CALL ENABLE
LDI R16,0x28 // 4-bit mode for a 2 line module with 5 x 7 dots per character
CALL FourBit_Mode
LDI R16,0x01 // Clear display screen
CALL FourBit_Mode
LDI R16,0x0C //Display on, cursor off
CALL FourBit_Mode
 
//Data for custom shape and store to CGRAM of LCD
LDI R16,0x40    //CGRAM Address Select
CALL FourBit_Mode
 
SBI PORTD,PIND1
 

LDI R16,0x04    //Data of Custom Image
CALL FourBit_Mode
LDI R16,0x0E
CALL FourBit_Mode
LDI R16,0x0E
CALL FourBit_Mode
LDI R16,0x0E
CALL FourBit_Mode
LDI R16,0x1F
CALL FourBit_Mode
LDI R16,0x00
CALL FourBit_Mode
LDI R16,0x04
CALL FourBit_Mode
LDI R16,0x00
CALL FourBit_Mode
 
//Set Cursor Coordinate
CBI PORTD,PIND1
LDI R16,0x82 //Set Cursor at begining of 1st Line 
CALL FourBit_Mode
 
//Print the custom Image on LCD
SBI PORTD,PIND1
LDI R16,0x00
CALL FourBit_Mode
 
LOOP_INF: NOP
          JMP LOOP_INF
 
ENABLE : SBI PORTD,PIND0
         LDI R18,0x20
         LOOP2: LDI R17,0xFF
                LOOP1:    NOP
                        DEC R17
                        BRNE LOOP1
                DEC R18
                BRNE LOOP2
         CBI PORTD,PIND0
         LDI R18,0x20
         LOOP4: LDI R17,0xFF
                LOOP3:    NOP
                        DEC R17
                        BRNE LOOP3
                DEC R18
                BRNE LOOP4
         RET
FourBit_Mode:    OUT PORTB,R16
                CALL ENABLE
                SWAP R16
                OUT PORTB,R16
                CALL ENABLE
                RET