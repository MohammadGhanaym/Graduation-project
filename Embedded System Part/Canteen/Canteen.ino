#ifndef ESP32
#define ESP32
#endif

#include "PN53.h"
#include "Network.h"
const int BUZZER = 2;
String studentUID = "";


/*************************************************************************/
/* Project how to read PN532 nfc reader from an ESP32 using multi-      */
/* tasking.                                                            */
/* This project depends on the <Adafruit_PN532.h>, <SPI.h> libraries  */
/*                                                                   */
/********************************************************************/

Network network;

void setup()
{
 
  Serial.begin(115200);
  Serial.println("Hello!");

  network.initWiFi();
  network.initFirebase();

  Set_Up_PN53();
  pinMode(BUZZER, OUTPUT);
}

void loop()
{
   studentUID = readNFC();
   if(studentUID)
   {
     network.FirestoreDataUpdate(studentUID);
     tone(BUZZER, 2000); 
     delay(200);        
     noTone(BUZZER);
     delay(200);
   }
}
