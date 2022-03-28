/******************************************************************************
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
 *            http: ;//www.apache.org/licenses/LICENSE-2.0
 *
 *            Unless required by applicable law or agreed to in writing,
 *            software distributed under the License is distributed on an
 *            "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *            KIND, either express or implied.  See the License for the
 *            specific language governing permissions and limitations
 *            under the License.
 ******************************************************************************/
#include "headers/LCD_config.h"

#define START PORTB.B6
#define PUMP PORTB.B7
#define ULTRASONIC_TRIG PORTB.B0
#define ULTRASONIC_ECHO PORTB.B4
#define MIN_DISTANCE 0  // Minimum Distance to turn off pump
#define MAX_DISTANCE 24 // Maximum Distance to turn on pump

void LCD_Plot(unsigned int percentage);
void PUMP_OnOff(unsigned short int PUMP_CopyTurnOnOff);

void main(void) {
  /* Variables' definitions              */
  unsigned short int time = 0;           /*!< 4 meters takes time = (11764 *2) uSec = 23526 (< 65536 --> 16 bit) */
  unsigned char distance = 0;      /*!< Maximum depth < 2m = 200 cm (< 256 --> 8 bit) */
  unsigned short int percentage = 0;     /*!< distance percentage (2 bytes to avoid overflow condition in case MAX_DISTANCE is too small and sensor can read 6meters which may make percentage > 255 )    */
  unsigned char i = 0;            
  unsigned char state = 0;         /*!< state of pump (0 = off, 1 = on) */

  /* Define I/P and O/P Pins             */
  trisb.b6 = 1;         /*!< Start button as I/P  */
  trisb.b7 = 0;
  PUMP = 0;             /*!< Pump as O/P and initialized with zero  */
  TRISB.b0 = 0;
  ULTRASONIC_TRIG = 0;  /*!< Ultrasonic Trigger as O/P and initialized with zero  */
  TRISB.b4 = 1;         /*!< Ultrasonic Echo as I/P  */

  /*!< Wait until press Start button */
  while(START == 0)
    ;

  /* Initializing LCD                    */
  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);

  T1CON = 0x10; // Timer 1 prescalar set to 1: ;2

  /*!< Initializing LCD                    */
  Lcd_Out(1, 6, "WELCOME");
  Lcd_Out(2, 4, "TANK LEVEL");
  /* Blinking LCD for 3 Sec */
  for(i = 0; i <= 3; i++) {
    Lcd_Cmd(_LCD_TURN_OFF);
    delay_ms(500);

    Lcd_Cmd(_LCD_TURN_ON);
    delay_ms(250);
  }
  Lcd_Cmd(_LCD_CLEAR);

  while(1) {
    TMR1H = TMR1L = 0;    /*!< Reset Timer 1 */

    ULTRASONIC_TRIG = 1;  /*!< Triggering Ultrasonic Sensor */
    delay_us(10);         /*!< 10uSec delay to trigger Ultrasonic Sensor correctly */
    ULTRASONIC_TRIG = 0;  /*!< Stop triggering Ultrasonic Sensor */

    /*!< Wait until Ultrasonic echo is received */
    while(0 == ULTRASONIC_ECHO)
      ;

    TMR1ON_bit = 1;       /*!< Start Timer 1 ==> (T1CON.F0) */

    /*!< Wait until Ultrasonic echo is received */
    while(ULTRASONIC_ECHO)
      ;          

    /*!< Stop Timer 1 and calculate distance */  
    TMR1ON_bit = 0;       
    time = TMR1L | (TMR1H << 8);
    distance = time / 58.8;
    distance += 1;        /*!< Add 1 to avoid distance = 0 */

    /*!< Check if distance is in range */
    if((distance >= MIN_DISTANCE) && (distance <= MAX_DISTANCE)) {
      percentage = 100 - distance * 100 / MAX_DISTANCE;

      /*!< If tank is full, turn off pump */
      if(percentage >= 80) {
        PUMP = 0;
        eeprom_write(1, 0);
        state = 0;
      } else if(eeprom_read(1) || percentage <= 16) { /*!< If tank is empty, turn on pump */
        PUMP = 1;
        eeprom_write(1, 1);
        state = 1;
      }

      switch(state) {
        case 1: ;
          Lcd_Out(1, 1, "****PUMP  ON****");    /*!< Display Pump ON on LCD Row 1, Column 1 */
          break;
        case 0: ;
          Lcd_Out(1, 1, "****PUMP OFF****");    /*!< Display Pump OFF on LCD Row 1, Column 1 */
          break;
      }

      LCD_Plot(percentage);                     /*!< Plot percentage on LCD */
    } else {    /*!< If distance is out of range */
      Lcd_Cmd(_LCD_CLEAR);                      /*!< Clear LCD */
      Lcd_Out(1, 1, "**OUT OF RANGE**");        /*!< Display Out of Range on LCD Row 1, Column 1 */
      Lcd_Out(2, 1, "================");        
      delay_ms(500);
      Lcd_Cmd(_LCD_TURN_OFF);
      delay_ms(250);
      Lcd_Cmd(_LCD_TURN_ON);
      PUMP = 0;
    }

    delay_ms(500);                              /*!< Delay for 500ms before next reading */
  } /* End of while(1) */
}   /* End of main() */

/*!< Plot percentage on LCD */
void LCD_Plot(unsigned int percentage) {
  char percentage_txt[7];
  WordToStr(percentage, percentage_txt);
  Ltrim(percentage_txt);
  Lcd_Out(2, 1, "=======    ======");
  Lcd_Out(2, 8, percentage_txt);
  Lcd_Out_Cp("%");
}