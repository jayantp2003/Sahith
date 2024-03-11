;
; ncs_04_03_2.asm
;
; Created: 04-03-2024 03:10:15 PM
; Author : NC Sahith


// LCD 4-bit Mode
 
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
 
//Data Loading to SRAM
LDI R26,0x80
LDI R27,0x00
 
LDI R16,'E'
ST X+,R16
LDI R16,'m'
ST X+,R16
LDI R16,'b'
ST X+,R16
LDI R16,'e'
ST X+,R16
LDI R16,'d'
ST X+,R16
LDI R16,'d'
ST X+,R16
LDI R16,'e'
ST X+,R16
LDI R16,'d'
ST X+,R16
LDI R16,' '
ST X+,R16
LDI R16,'S'
ST X+,R16
LDI R16,'y'
ST X+,R16
LDI R16,'s'
ST X+,R16
LDI R16,'t'
ST X+,R16
LDI R16,'e'
ST X+,R16
LDI R16,'m'
ST X+,R16
LDI R16,'s'
ST X+,R16
LDI R16,0
ST X,R16
 
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
LDI R16,0x06 // Shift Cursor to right automatically after print on LCD
CALL FourBit_Mode
 
//Set Cursor Coordinate
LDI R16,0x80 //Set Cursor at begining of 1st Line 
CALL FourBit_Mode
 
//Data Read and print on LCD
LDI R26,0x80
LCD_PRINT1: SBI PORTD,PIND1 // Data Register Enable
            LD R16,X+
            CALL FourBit_Mode
 
            LD R16,X
            CPI R16,0
            BRNE LCD_PRINT1
 
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
         RET
FourBit_Mode:    OUT PORTB,R16
                CALL ENABLE
                SWAP R16
                OUT PORTB,R16
                CALL ENABLE
                RET