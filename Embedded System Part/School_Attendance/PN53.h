#ifndef PN53_H_
#define PN53_H_

#include <stdio.h>
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_PN532.h>

/* define serial prepheral interfacing pins (SPI)*/

#define PN532_SCK  (18)
#define PN532_MISO (19)
#define PN532_MOSI (23)
#define PN532_SS   (4)


/* functions prototype */

void Set_Up_PN53(void);
String readNFC(void);
String tagToString(byte id[7], uint8_t len);



#endif