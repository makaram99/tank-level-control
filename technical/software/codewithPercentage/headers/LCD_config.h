/**********************************************************************/
/* Author     : Mahmoud Karam                                         */
/* Version    : V01                                                   */
/* Date       : Nov, 10, 2020                                         */
/**********************************************************************/

#ifndef LCD_CONFIG_H
#define LCD_CONFIG_H

  /* LCD Pinouts      */
  sbit   LCD_D4             at RD0_bit;
  sbit   LCD_D5             at RD1_bit;
  sbit   LCD_D6             at RD2_bit;
  sbit   LCD_D7             at RD3_bit;
  sbit   LCD_RS             at RD4_bit;
  sbit   LCD_EN             at RD5_bit;
  
  /* Pins' Direction  */
  sbit   LCD_D4_Direction   at TRISD0_bit;
  sbit   LCD_D5_Direction   at TRISD1_bit;
  sbit   LCD_D6_Direction   at TRISD2_bit;
  sbit   LCD_D7_Direction   at TRISD3_bit;
  sbit   LCD_RS_Direction   at TRISD4_bit;
  sbit   LCD_EN_Direction   at TRISD5_bit;
	

#endif
