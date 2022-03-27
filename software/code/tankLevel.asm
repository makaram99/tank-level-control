
_main:

;Tank Level.c,21 :: 		void main() {
;Tank Level.c,23 :: 		unsigned int         time       = 0;         // 4 meters takes time = (11764 *2) uSec = 23526   ==> stored in 16bits ==> 65536
;Tank Level.c,24 :: 		unsigned short int   distance   = 0;         // Maximum depth < 2m(200 cm)   ==> stored in 8bits ==> 256
	CLRF       main_distance_L0+0
	CLRF       main_percentage_L0+0
	CLRF       main_percentage_L0+1
	CLRF       main_i_L0+0
	CLRF       main_state_L0+0
;Tank Level.c,30 :: 		trisb.b6 = 1;                               // Start button as I/P
	BSF        TRISB+0, 6
;Tank Level.c,31 :: 		trisb.b7 = 0;     PUMP            = 0;      // Pump as O/P and initialized with zero
	BCF        TRISB+0, 7
	BCF        PORTB+0, 7
;Tank Level.c,32 :: 		TRISB.b0 = 0;     ULTRASONIC_TRIG = 0;      // Ultrasonic Trigger as O/P and initialized with zero
	BCF        TRISB+0, 0
	BCF        PORTB+0, 0
;Tank Level.c,33 :: 		TRISB.b4 = 1;                               // Ultrasonic Echo as I/P
	BSF        TRISB+0, 4
;Tank Level.c,35 :: 		while (START == 0);                           // Check start button
L_main0:
	BTFSC      PORTB+0, 6
	GOTO       L_main1
	GOTO       L_main0
L_main1:
;Tank Level.c,38 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Tank Level.c,39 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Tank Level.c,40 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Tank Level.c,42 :: 		T1CON = 0x10;                               //Timer 1 prescalar set to 1:2
	MOVLW      16
	MOVWF      T1CON+0
;Tank Level.c,44 :: 		Lcd_Out(1, 6, "WELCOME");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Tank_32Level+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Tank Level.c,45 :: 		Lcd_Out(2, 4, "TANK LEVEL");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Tank_32Level+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Tank Level.c,48 :: 		for(i = 0; i <= 3; i++)
	CLRF       main_i_L0+0
L_main2:
	MOVF       main_i_L0+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main3
;Tank Level.c,50 :: 		Lcd_Cmd(_LCD_TURN_OFF);
	MOVLW      8
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Tank Level.c,51 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
	NOP
;Tank Level.c,53 :: 		Lcd_Cmd(_LCD_TURN_ON);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Tank Level.c,54 :: 		delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
	NOP
	NOP
;Tank Level.c,48 :: 		for(i = 0; i <= 3; i++)
	INCF       main_i_L0+0, 1
;Tank Level.c,55 :: 		}
	GOTO       L_main2
L_main3:
;Tank Level.c,57 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Tank Level.c,59 :: 		while(1)                                      // Endless loop
L_main7:
;Tank Level.c,61 :: 		TMR1H = TMR1L = 0;                    // Clearing Timer1 value Registers
	CLRF       TMR1L+0
	MOVF       TMR1L+0, 0
	MOVWF      TMR1H+0
;Tank Level.c,63 :: 		ULTRASONIC_TRIG = 1;
	BSF        PORTB+0, 0
;Tank Level.c,64 :: 		delay_us(10);                         // Tell Ultrasonic to emit ultrasonic waves
	MOVLW      6
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	NOP
;Tank Level.c,65 :: 		ULTRASONIC_TRIG = 0;
	BCF        PORTB+0, 0
;Tank Level.c,68 :: 		while(!ULTRASONIC_ECHO);             // Wait for the rising edge from Echo
L_main10:
	BTFSC      PORTB+0, 4
	GOTO       L_main11
	GOTO       L_main10
L_main11:
;Tank Level.c,69 :: 		TMR1ON_bit = 1;                      // Start Timer 1  ==> (T1CON.F0)
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;Tank Level.c,71 :: 		while(ULTRASONIC_ECHO);              // Wait for the falling edge from Echo
L_main12:
	BTFSS      PORTB+0, 4
	GOTO       L_main13
	GOTO       L_main12
L_main13:
;Tank Level.c,72 :: 		TMR1ON_bit = 0;                      // Stop Timer 1  ==> (T1CON.F0)
	BCF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;Tank Level.c,74 :: 		time = TMR1L | (TMR1H << 8);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;Tank Level.c,75 :: 		distance    = time / 58.8;
	CALL       _word2double+0
	MOVLW      51
	MOVWF      R4+0
	MOVLW      51
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2byte+0
	MOVF       R0+0, 0
	MOVWF      main_distance_L0+0
;Tank Level.c,76 :: 		distance   += 1;                     // distance calibration
	INCF       R0+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_distance_L0+0
;Tank Level.c,78 :: 		if((distance >= MIN_DISTANCE) && (distance <= MAX_DISTANCE))  // Check valid distance
	MOVLW      0
	SUBWF      R1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main16
	MOVF       main_distance_L0+0, 0
	SUBLW      24
	BTFSS      STATUS+0, 0
	GOTO       L_main16
L__main31:
;Tank Level.c,80 :: 		percentage  = 100 - distance * 100 / MAX_DISTANCE;
	MOVF       main_distance_L0+0, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      24
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	SUBLW      100
	MOVWF      R2+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R2+1
	SUBWF      R2+1, 1
	MOVF       R2+0, 0
	MOVWF      main_percentage_L0+0
	MOVF       R2+1, 0
	MOVWF      main_percentage_L0+1
;Tank Level.c,82 :: 		if   (percentage >= 80)      // Tank is FULL
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main33
	MOVLW      80
	SUBWF      R2+0, 0
L__main33:
	BTFSS      STATUS+0, 0
	GOTO       L_main17
;Tank Level.c,83 :: 		{      PUMP  = 0;         eeprom_write(1,0); state = 0;      }
	BCF        PORTB+0, 7
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	CLRF       FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
	CLRF       main_state_L0+0
	GOTO       L_main18
L_main17:
;Tank Level.c,84 :: 		else if        (eeprom_read(1) || percentage <= 16)      // Tank is FULL
	MOVLW      1
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main30
	MOVF       main_percentage_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main34
	MOVF       main_percentage_L0+0, 0
	SUBLW      16
L__main34:
	BTFSC      STATUS+0, 0
	GOTO       L__main30
	GOTO       L_main21
L__main30:
;Tank Level.c,85 :: 		{      PUMP  = 1;         eeprom_write(1,1); state = 1;      }
	BSF        PORTB+0, 7
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
	MOVLW      1
	MOVWF      main_state_L0+0
L_main21:
L_main18:
;Tank Level.c,87 :: 		switch (state)
	GOTO       L_main22
;Tank Level.c,89 :: 		case 1: Lcd_Out(1, 1, "****PUMP  ON****");        break;
L_main24:
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Tank_32Level+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_main23
;Tank Level.c,90 :: 		case 0: Lcd_Out(1, 1, "****PUMP OFF****");        break;
L_main25:
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Tank_32Level+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_main23
;Tank Level.c,91 :: 		}
L_main22:
	MOVF       main_state_L0+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main24
	MOVF       main_state_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main25
L_main23:
;Tank Level.c,93 :: 		LCD_Plot(percentage);
	MOVF       main_percentage_L0+0, 0
	MOVWF      FARG_LCD_Plot_percentage+0
	MOVF       main_percentage_L0+1, 0
	MOVWF      FARG_LCD_Plot_percentage+1
	CALL       _LCD_Plot+0
;Tank Level.c,94 :: 		}
	GOTO       L_main26
L_main16:
;Tank Level.c,97 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Tank Level.c,98 :: 		Lcd_Out(1,1,"**OUT OF RANGE**");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Tank_32Level+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Tank Level.c,99 :: 		Lcd_Out(2,1,"================");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Tank_32Level+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Tank Level.c,100 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	DECFSZ     R11+0, 1
	GOTO       L_main27
	NOP
	NOP
;Tank Level.c,101 :: 		Lcd_Cmd(_LCD_TURN_OFF);
	MOVLW      8
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Tank Level.c,102 :: 		delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main28:
	DECFSZ     R13+0, 1
	GOTO       L_main28
	DECFSZ     R12+0, 1
	GOTO       L_main28
	DECFSZ     R11+0, 1
	GOTO       L_main28
	NOP
	NOP
;Tank Level.c,103 :: 		Lcd_Cmd(_LCD_TURN_ON);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Tank Level.c,104 :: 		PUMP = 0;
	BCF        PORTB+0, 7
;Tank Level.c,105 :: 		}
L_main26:
;Tank Level.c,106 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main29:
	DECFSZ     R13+0, 1
	GOTO       L_main29
	DECFSZ     R12+0, 1
	GOTO       L_main29
	DECFSZ     R11+0, 1
	GOTO       L_main29
	NOP
	NOP
;Tank Level.c,107 :: 		}                                             // End of while loop
	GOTO       L_main7
;Tank Level.c,108 :: 		}                                               // End of main
L_end_main:
	GOTO       $+0
; end of _main

_LCD_Plot:

;Tank Level.c,110 :: 		void LCD_Plot(unsigned int percentage)
;Tank Level.c,113 :: 		WordToStr(percentage, percentage_txt);
	MOVF       FARG_LCD_Plot_percentage+0, 0
	MOVWF      FARG_WordToStr_input+0
	MOVF       FARG_LCD_Plot_percentage+1, 0
	MOVWF      FARG_WordToStr_input+1
	MOVLW      LCD_Plot_percentage_txt_L0+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;Tank Level.c,114 :: 		Ltrim(percentage_txt);
	MOVLW      LCD_Plot_percentage_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;Tank Level.c,115 :: 		Lcd_Out(2, 1, "=======    ======");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_Tank_32Level+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Tank Level.c,116 :: 		Lcd_Out(2, 8, percentage_txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      LCD_Plot_percentage_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Tank Level.c,117 :: 		Lcd_Out_Cp("%");
	MOVLW      ?lstr8_Tank_32Level+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;Tank Level.c,118 :: 		}
L_end_LCD_Plot:
	RETURN
; end of _LCD_Plot
