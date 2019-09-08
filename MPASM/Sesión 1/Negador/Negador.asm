; Codigo hecho por Josué
; 07 de Setiembre del 2019  
    
    list p=18f4550
    #include "p18f4550.inc"

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
    CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000
    goto inicio

    org 0x0020

inicio: 
    bcf TRISD, 0		;Puerto RD0 como salida

led_on:
    btfsc PORTB, 0		;Pregunto si el RB0 es igual a cero
    goto led_off		;Salta aqui cuando es falso
    bsf LATD, 0			;Salta aqui cuando es verdadero y pone RD0 a uno
    goto led_on			;Salta a la etiqueta 'led_on'
    
led_off:
    bcf LATD, 0			;Pone RD0 a uno
    goto led_on			;Salta a la etiqueta 'led_off'
    
    end		    
    