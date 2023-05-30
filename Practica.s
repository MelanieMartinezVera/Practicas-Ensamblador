
; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = INTRC_CLKOUT   ; Oscillator Selection bits (INTOSC oscillator: CLKOUT function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = ON            ; Brown Out Reset Selection bits (BOR enabled)
  CONFIG  IESO = ON             ; Internal External Switchover bit (Internal/External Switchover mode is enabled)
  CONFIG  FCMEN = ON            ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is enabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>
  PSECT MainCode,global,class=CODE,delta=2
  ;Etiqueta de maincode, es donde se encuentra el codigo principal
  MAIN: ;etiqueta, marca donde inicia el programa principal
   ;Configuracion de puertos como salida y entrada
   BANKSEL TRISB ;SELECCIONO EL BANCO DEL PUERTO B
   BCF TRISB, 3
   BANKSEL PORTB ;Envia la configuracion del registro al puerto
   
   BANKSEL TRISD
   BCF TRISD, 0
   BANKSEL PORTD
   
   BANKSEL TRISE
   BSF TRISE, 0
   BANKSEL PORTE
   
   BANKSEL TRISE
   BSF TRISE, 1
   BANKSEL PORTE
   
   MainLoop: ;inicio de ciclo iterativo principal
    ;asegurar que el pin se enuentre en 1 logico antes de apagarlo
    BTFSS	    PORTE, 0 ;revisar el pin 0 del puerto e
    BCF		    PORTD, 0 ;si el pin 0 del puerto e es 1, entonces saltar y no entrar a la condicion 
			     ;si el pin 0 del puerto e es 0, entonces entrar a bcf
    ;apagar, esperar y encender LED 1
    BCF		    PORTB, 3 ;COLOCAR A 0 EL PIN 3 DEL PUESTO B (APAGAR LED)
	CALL	    DELAY ;LLAMAR O EJECUTAR LA SUBRUTINA DELAY
    BSF		    PORTB, 3 ;COLOCAR A 1 EL PIN 3 DEL PUERTO B (ENCENDER EL LED)
	CALL        DELAY
    ;revisar si el boton 1 esta presionado
    BTFSC PORTE, 0 ;revisar el pin 0 del puerto e
    BSF PORTD, 0 ;si el pin es 0 logico, no entrar a instruccion bsf
		 ;si el pin es 1 logico, entrar a instruccion bsf
    ;revisar si el boton 2 esta presionado		 
    BTFSC PORTE, 1 ;revisar el pin 1 del puerto e
    BCF PORTD, 0 ;si el pin es 0 logico, no entrar a instruccion bcf
		 ;si el pin es 1 logico, entrar a instruccion bcf
		 
    GOTO MainLoop ;una vez que completa el retraso
    
    DELAY: 
	MOVLW 10 ;valor de los milisegundos de espera, mover literal de argumento a registro de trabajo
	MOVWF 0x10 ;mover el registro del trabajo a la direccion de argumento
	MOVWF 0x11 ;mover el registro del trabajo a la direccion de argumento, contador 
    
    DELAY_LOOP:
	DECFSZ 0x10, f
	GOTO DELAY_LOOP
	DECFSZ 0x11, f
	GOTO DELAY_LOOP
	RETLW 0
	
    END MAIN