/**
 * @file    tankLevel.c
 * @author  Mahmoud Karam (ma.karam272@gmail.com)
 * @brief   Control level of liquid tank either on filling or empting with HC-SR04 ultrasonic and LCD.
 * @version 1.0.0
 * @date    Nov, 17, 2020
 * 
 * @copyright Copyright (c) 2021 for Mahmoud Karam
 *            Licensed to the Apache Software Foundation (ASF) under one
 *            or more contributor license agreements.  See the NOTICE file
 *            distributed with this work for additional information
 *            regarding copyright ownership.  The ASF licenses this file
 *            to you under the Apache License, Version 2.0 (the
 *            "License"); you may not use this file except in compliance
 *            with the License.  You may obtain a copy of the License at
 *            http://www.apache.org/licenses/LICENSE-2.0
 *            
 *            Unless required by applicable law or agreed to in writing,
 *            software distributed under the License is distributed on an 
 *            "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *            KIND, either express or implied.  See the License for the
 *            specific language governing permissions and limitations
 *            under the License.  
 */

/* Include Libraries                   */
#include <xc.h>

#include "LCD_config.h"

/* Macros definitions                  */
  #define PUMP                     PORTB.B7
  #define ULTRASONIC_TRIG          PORTB.B0
  #define ULTRASONIC_ECHO          PORTB.B4
  #define MIN_DISTANCE             0        //Minimum Distance to turn off pump
  #define MAX_DISTANCE             24      //Maximum Distance to turn on pump

void LCD_Plot     (unsigned int percentage);
void PUMP_OnOff   (unsigned short int PUMP_CopyTurnOnOff);

void main() {
  /* Variables' definitions              */
    unsigned int         time       = 0;         // 4 meters takes time = (11764 *2) uSec = 23526   ==> stored in 16bits ==> 65536
    unsigned short int   distance   = 0;         // Maximum depth < 2m(200 cm)   ==> stored in 8bits ==> 256
    unsigned int         percentage = 0;         // distance percentage (2 butes to avoid overflow condition in case MAX_DISTANCE is too small and sensor can read 6meters which may make percentage > 255 )    */
    unsigned short int   i          = 0;         // index of loops
    unsigned short int   state      = 0;         // state of pump

  /* Define I/P and O/P Pins             */
    trisb.b6 = 1;                               // Start button as I/P
    trisb.b7 = 0;     PUMP            = 0;      // Pump as O/P and initialized with zero
    TRISB.b0 = 0;     ULTRASONIC_TRIG = 0;      // Ultrasonic Trigger as O/P and initialized with zero
    TRISB.b4 = 1;                               // Ultrasonic Echo as I/P
    
  while (START == 0);                           // Check start button

  /* Initializing LCD                    */
    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    
    T1CON = 0x10;                               //Timer 1 prescalar set to 1:2
    
    Lcd_Out(1, 6, "WELCOME");
    Lcd_Out(2, 4, "TANK LEVEL");
    
    /* Blinking LCD for 3 Sec */
    for(i = 0; i <= 3; i++)
    {
      Lcd_Cmd(_LCD_TURN_OFF);
      delay_ms(500);
      
      Lcd_Cmd(_LCD_TURN_ON);
      delay_ms(250);
    }
    
    Lcd_Cmd(_LCD_CLEAR);

  while(1)                                      // Endless loop
  {
          TMR1H = TMR1L = 0;                    // Clearing Timer1 value Registers
          
          ULTRASONIC_TRIG = 1;
          delay_us(10);                         // Tell Ultrasonic to emit ultrasonic waves
          ULTRASONIC_TRIG = 0;
          
          /*********************************************/
          while(!ULTRASONIC_ECHO);             // Wait for the rising edge from Echo
          TMR1ON_bit = 1;                      // Start Timer 1  ==> (T1CON.F0)
          
          while(ULTRASONIC_ECHO);              // Wait for the falling edge from Echo
          TMR1ON_bit = 0;                      // Stop Timer 1  ==> (T1CON.F0)
          
          time = TMR1L | (TMR1H << 8);
          distance    = time / 58.8;
          distance   += 1;                     // distance calibration
          
          if((distance >= MIN_DISTANCE) && (distance <= MAX_DISTANCE))  // Check valid distance
          {
              percentage  = 100 - distance * 100 / MAX_DISTANCE;

              if   (percentage >= 80)      // Tank is FULL
              {      PUMP  = 0;         eeprom_write(1,0); state = 0;      }
              else if        (eeprom_read(1) || percentage <= 16)      // Tank is FULL
              {      PUMP  = 1;         eeprom_write(1,1); state = 1;      }

              switch (state)
              {
                     case 1: Lcd_Out(1, 1, "****PUMP  ON****");        break;
                     case 0: Lcd_Out(1, 1, "****PUMP OFF****");        break;
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
              PUMP = 0;
          }
          delay_ms(500);
  }                                             // End of while loop
}                                               // End of main

void LCD_Plot(unsigned int percentage)    
{
    char percentage_txt[7];
    WordToStr(percentage, percentage_txt);
    Ltrim(percentage_txt);
    Lcd_Out(2, 1, "=======    ======");
    Lcd_Out(2, 8, percentage_txt);
    Lcd_Out_Cp("%");
}