#ifndef ESP32
#define ESP32
#endif

#include "PN53.h"
#include "Network.h"
const int redled = 27;
const int button = 12;

String studentUID = "";
String actionType = "";


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
  pinMode(redled, OUTPUT);
  pinMode(button, INPUT_PULLUP);
  pinMode(BUZZER, OUTPUT);

  attachInterrupt(digitalPinToInterrupt(button), changeMode, CHANGE);

  //default state
  digitalWrite(redled, LOW);
  actionType = "Arrived";


}

void loop()
{
  
  // default action
  // you will use the button here to update the action type
  
   studentUID = readNFC();
   if(studentUID)
   {
    network.FirestoreDataUpdate(studentUID, actionType);
    
   }
   
}

void changeMode()
{
      delayMicroseconds(200000);
      digitalWrite(redled,!digitalRead(redled));
      
      if(digitalRead(redled) == HIGH)
        {
          actionType = "Left";
        }else
        {
          actionType = "Arrived";
        }
        Serial.println(actionType);    
}
