#line 1 "H:/Code with Percentage/Tank Level.c"
#line 1 "h:/code with percentage/headers/lcd_config.h"










 sbit LCD_D4 at RD0_bit;
 sbit LCD_D5 at RD1_bit;
 sbit LCD_D6 at RD2_bit;
 sbit LCD_D7 at RD3_bit;
 sbit LCD_RS at RD4_bit;
 sbit LCD_EN at RD5_bit;


 sbit LCD_D4_Direction at TRISD0_bit;
 sbit LCD_D5_Direction at TRISD1_bit;
 sbit LCD_D6_Direction at TRISD2_bit;
 sbit LCD_D7_Direction at TRISD3_bit;
 sbit LCD_RS_Direction at TRISD4_bit;
 sbit LCD_EN_Direction at TRISD5_bit;
#line 18 "H:/Code with Percentage/Tank Level.c"
void LCD_Plot (unsigned int percentage);
void PUMP_OnOff (unsigned short int PUMP_CopyTurnOnOff);

void main() {

 unsigned int time = 0;
 unsigned short int distance = 0;
 unsigned int percentage = 0;
 unsigned short int i = 0;
 unsigned short int state = 0;


 trisb.b6 = 1;
 trisb.b7 = 0;  PORTB.B7  = 0;
 TRISB.b0 = 0;  PORTB.B0  = 0;
 TRISB.b4 = 1;

 while ( PORTB.B6  == 0);


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 T1CON = 0x10;

 Lcd_Out(1, 6, "WELCOME");
 Lcd_Out(2, 4, "TANK LEVEL");


 for(i = 0; i <= 3; i++)
 {
 Lcd_Cmd(_LCD_TURN_OFF);
 delay_ms(500);

 Lcd_Cmd(_LCD_TURN_ON);
 delay_ms(250);
 }

 Lcd_Cmd(_LCD_CLEAR);

 while(1)
 {
 TMR1H = TMR1L = 0;

  PORTB.B0  = 1;
 delay_us(10);
  PORTB.B0  = 0;


 while(! PORTB.B4 );
 TMR1ON_bit = 1;

 while( PORTB.B4 );
 TMR1ON_bit = 0;

 time = TMR1L | (TMR1H << 8);
 distance = time / 58.8;
 distance += 1;

 if((distance >=  0 ) && (distance <=  24 ))
 {
 percentage = 100 - distance * 100 /  24 ;

 if (percentage >= 80)
 {  PORTB.B7  = 0; eeprom_write(1,0); state = 0; }
 else if (eeprom_read(1) || percentage <= 16)
 {  PORTB.B7  = 1; eeprom_write(1,1); state = 1; }

 switch (state)
 {
 case 1: Lcd_Out(1, 1, "****PUMP  ON****"); break;
 case 0: Lcd_Out(1, 1, "****PUMP OFF****"); break;
 }

 LCD_Plot(percentage);
 }
 else
 {
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"**OUT OF RANGE**");
 Lcd_Out(2,1,"================");
 delay_ms(500);
 Lcd_Cmd(_LCD_TURN_OFF);
 delay_ms(250);
 Lcd_Cmd(_LCD_TURN_ON);
  PORTB.B7  = 0;
 }
 delay_ms(500);
 }
}

void LCD_Plot(unsigned int percentage)
{
 char percentage_txt[7];
 WordToStr(percentage, percentage_txt);
 Ltrim(percentage_txt);
 Lcd_Out(2, 1, "=======    ======");
 Lcd_Out(2, 8, percentage_txt);
 Lcd_Out_Cp("%");
}
