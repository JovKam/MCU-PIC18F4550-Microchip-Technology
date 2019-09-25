; Codigo hecho por Josué
; 18 de Setiembre del 2019 
    
    list p=18f4550
    #include<p18f4550.inc>
    #include "LCD_LIB.asm"

    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    cblock 0x030		 ;Bloque de variable para delaymon

	adc_result
	v_result
	c_1
	c_2
	c_3
	v_3canales
	endc

    org 0x1000
    
    mensaje da "Micro L2 AN0:   AN1:    AN2:           "
    
    org 0x0000
	goto inicio
		
    org 0x0020
    
inicio:				
    ;Configuracion del LCD
    clrf TRISD			;Conexion al LCD
    call DELAY15MSEG
    call LCD_CONFIG
    call BORRAR_LCD
    call CURSOR_OFF
    call CURSOR_HOME
    
    setf TRISB

    bsf INTCON2, RBPU		;Activacion Pull-up


    ;Configuracion del ADC
    movlw 0x24
    movwf ADCON2		;8TAD, FOsc/4, ADFM=0
    movlw 0x0C
    movwf ADCON1
    movf 0x01, W
    movwf ADCON0
    
    clrf v_3canales
    
    
tabla:
    ;Configuracion de la tabla 
    
    movlw LOW mensaje
    movwf TBLPTRL
    movlw HIGH mensaje
    movwf TBLPTRH    
 
    
imp_tabla:
	;Impresion de caracteres
	
	TBLRD*+
	movf TABLAT, W  
	call ENVIA_CHAR
	movlw .16
	cpfseq TBLPTRL
	goto imp_tabla
	
	movlw .0
	call POS_CUR_FIL2
imp_tabla2:
	TBLRD*+
	movf TABLAT, W
	call ENVIA_CHAR
	movf .32, W
	cpfseq TBLPTRL
	goto imp_tabla2
	
	
conversor:
    
    ;UNOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
    movlw 0x01
    movwf ADCON0
    bsf ADCON0, 1	;Iniciamos la conversion  
    
    wait1:
	btfsc ADCON0, 1		;Preguntamos si termino de convertir
	goto wait1		;Aun no termina de convertir
	clrf v_result
    
    ;Algoritmo para sacar los digitos de una variable de 8 bit

    movff ADRESH, adc_result
    
    movlw .0
    
    btfsc adc_result, 0
    addlw .1
    btfsc adc_result, 1
    addlw .2
    btfsc adc_result, 2
    addlw .4
    btfsc adc_result, 3
    addlw .8
    btfsc adc_result, 4
    addlw .16
    btfsc adc_result, 5
    addlw .32
    btfsc adc_result, 6
    addlw .64
    btfsc adc_result, 7
    addlw .128
    
    movwf v_result
    movf v_result, w
    movwf c_1
    
    
    ;DOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOS
    
    
    movlw 0x05
    movwf ADCON0
    bsf ADCON0, 1	;Iniciamos la conversion  
    
    wait2:
	btfsc ADCON0, 1		;Preguntamos si termino de convertir
	goto wait2		;Aun no termina de convertir
	clrf v_result
    
    ;Algoritmo para sacar los digitos de una variable de 8 bit

    movff ADRESH, adc_result
    
    movlw .0
    
    btfsc adc_result, 0
    addlw .1
    btfsc adc_result, 1
    addlw .2
    btfsc adc_result, 2
    addlw .4
    btfsc adc_result, 3
    addlw .8
    btfsc adc_result, 4
    addlw .16
    btfsc adc_result, 5
    addlw .32
    btfsc adc_result, 6
    addlw .64
    btfsc adc_result, 7
    addlw .128
    
    movwf v_result
    movf v_result, w
    movwf c_2
    
    
    ;TREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEESSS
    
    movlw 0x09
    movwf ADCON0
    bsf ADCON0, 1	;Iniciamos la conversion  
    
    wait3:
	btfsc ADCON0, 1		;Preguntamos si termino de convertir
	goto wait3		;Aun no termina de convertir
	clrf v_result
    
    ;Algoritmo para sacar los digitos de una variable de 8 bit

    movff ADRESH, adc_result
    
    movlw .0
    
    btfsc adc_result, 0
    addlw .1
    btfsc adc_result, 1
    addlw .2
    btfsc adc_result, 2
    addlw .4
    btfsc adc_result, 3
    addlw .8
    btfsc adc_result, 4
    addlw .16
    btfsc adc_result, 5
    addlw .32
    btfsc adc_result, 6
    addlw .64
    btfsc adc_result, 7
    addlw .128
    
    movwf v_result
    movf v_result, w
    movwf c_3
    
    ;IMPRESION
    ;UNOOOOOOOOOOOO
    movlw .13
    call POS_CUR_FIL1
    movf c_1, W
    call BIN_BCD

    movf BCD2, W 
    addlw 0x30
    call ENVIA_CHAR  

    movf BCD1, W
    addlw 0x30
    call ENVIA_CHAR

    movf BCD0, W
    addlw 0x30
    call ENVIA_CHAR
    ;DOOOOOOOOOOOOOOOOS
	
    movlw .4
    call POS_CUR_FIL2
    movf c_2, W
    call BIN_BCD

    movf BCD2, W 
    addlw 0x30
    call ENVIA_CHAR  

    movf BCD1, W
    addlw 0x30
    call ENVIA_CHAR

    movf BCD0, W
    addlw 0x30
    call ENVIA_CHAR
	
    ;TREEES
    movlw .12
    call POS_CUR_FIL2
    movf c_3, W
    call BIN_BCD

    movf BCD2, W 
    addlw 0x30
    call ENVIA_CHAR  

    movf BCD1, W
    addlw 0x30
    call ENVIA_CHAR

    movf BCD0, W
    addlw 0x30
    call ENVIA_CHAR
    
    goto conversor

    
    end