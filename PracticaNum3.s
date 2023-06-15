;PIC16F887 Configuration Bit Setting
    
;Assembly source line config statements
    
;CONFIG1
    CONFIG FOSC = INTRC_CLKOUT
    CONFIG WDTE = OFF
    CONFIG PWRTE = OFF
    CONFIG MCLRE = ON
    CONFIG CP = OFF
    CONFIG CPD = OFF
    CONFIG BOREN = OFF
    CONFIG FCMEN = OFF
    CONFIG LVP = OFF
    
;CONFIG2
    CONFIG BOR4V = BOR40V
    CONFIG WRT = OFF
    
    #include <xc.inc>

; When assembly code is placed in a psect, it can be manipulated as a
; whole by the linker and placed in memory.  
;
; In this example, barfunc is the program section (psect) name, 'local' means
; that the section will not be combined with other sections even if they have
; the same name.  class=CODE means the barfunc must go in the CODE container.
; PIC18 should have a delta (addressible unit size) of 1 (default) since they
; are byte addressible.  PIC10/12/16 have a delta of 2 since they are word
; addressible.  PIC18 should have a reloc (alignment) flag of 2 for any
; psect which contains executable code.  PIC10/12/16 can use the default
; reloc value of 1.  Use one of the psects below for the device you use:

psect   barfunc,local,class=CODE,delta=2 ; PIC10/12/16
; psect   barfunc,local,class=CODE,reloc=2 ; PIC18
    
 MAIN:
    BANKSEL TRISA
    BCF TRISA,0
    BCF TRISA,1
    BCF TRISA,2
    BCF TRISA,3
    BCF TRISA,4
    BCF TRISA,5
    BCF TRISA,6
    
    BANKSEL TRISD
    BSF TRISD,0
    BSF TRISD,1
    BSF TRISD,2
    
    BANKSEL TRISC
    BCF TRISC,0
    BANKSEL TRISC
    BCF TRISC,1
    BANKSEL TRISC
    BCF TRISC,2
    BANKSEL TRISC
    BCF TRISC,3
    
 NUMERO EQU 0x12
 CLRF NUMERO
 MOVLW 4
 MOVWF NUMERO
 CLRW
 BCF PORTD, 0
 
 MAINLOOP:
    BTFSS PORTD, 0
    GOTO INCREMENTO
    
    BTFSS PORTD, 1
    GOTO DECREMENTO
    
    BTFSC PORTD, 2
    GOTO BORRAR
    CLRF PORTD
    
    GOTO MAINLOOP
    
    INCREMENTO:
    MOVLW 4
    SUBWF NUMERO, W
    BTFSS STATUS, 2
    INCF NUMERO
    MOVF NUMERO, 0
    BCF PORTC, 0
    GOTO MAINLOOP
    
    DECREMENTO:
    MOVLW 0
    SUBWF NUMERO, W
    BTFSS STATUS, 2
    INCF NUMERO
    MOVF NUMERO, 0
    BCF PORTC, 0
    GOTO MAINLOOP
    
    CALCULARLEDS:
    MOVLW 0
    SUBWF NUMERO, W
    BTFSC STATUS, 2
    CALL ACTIVARPORT0
    RETLW 0
    
    MOVLW 1
    SUBWF NUMERO, W
    BTFSC STATUS, 2
    CALL ACTIVARPORT1
    RETLW 0
    
    MOVLW 2
    SUBWF NUMERO, W
    BTFSC STATUS, 2
    CALL ACTIVARPORT2
    RETLW 0
    
    MOVLW 3
    SUBWF NUMERO, W
    BTFSC STATUS, 2
    CALL ACTIVARPORT3
    RETLW 0
    
    ACTIVARPORT0:
    CLRF PORTC
    BSF PORTC, 0
    RETLW 0
    
    ACTIVARPORT1:
    CLRF PORTC
    BSF PORTC, 1
    RETLW 0
    
    ACTIVARPORT2:
    CLRF PORTC
    BSF PORTC, 2
    RETLW 0
    
    ACTIVARPORT3:
    CLRF PORTC
    BSF PORTC, 3
    RETLW 0
    
    BORRAR:
    CLRW
    CLRF NUMERO
    RETLW 0
    
    DELAY:
    MOVLW 20
    MOVWF 0x10
    MOVWF 0x11
    
    DELAY_LOOP:
    DECFSZ 0x10, F
    GOTO DELAY_LOOP
    DECFSZ 0x11, F
    GOTO DELAY_LOOP
    RETLW 0
    
    END MAIN


