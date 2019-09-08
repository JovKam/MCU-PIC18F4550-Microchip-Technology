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
    goto config_user

    org 0x0020

config_user:			;Configuracion de puertos 
    bcf TRISD, 0		;Puerto RD0 como salida
    
loop:
    btfss PORTB, 0	    ;El boton (RB0) ha sido presionado?
    goto loop		    ;No, entonces pregunto de nuevo
    btfsc PORTD, 0	    ;Si, el led (RD0) esta apagado?
    goto led_off	    ;No, y salta a led_off
    bsf LATD, 0		    ;Si, entonces se prende
    goto button_off
    
led_off:
    bcf LATD, 0		    ;Apago el led
    goto button_off
    
button_off:
    btfsc PORTB, 0	    ;Se dejo de presionar el boton (RB0)?
    goto button_off	    ;No, Aun mantengo presionado el boton 
    goto loop		    ;Si, Repito todo de nuevo
    
    end