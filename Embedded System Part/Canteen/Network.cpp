#include "Network.h"

#define WIFI_SSID "WE_9D74BF"
#define WIFI_PASSWORD "k7222558"

#define API_KEY "AIzaSyAzxeW0A5HnyOQ_gnLI0wVySnVm30RTjpc"
#define FIREBASE_PROJECT_ID "smartschool-6aee1"
#define USER_EMAIL "admin01@smartschool.com"
#define USER_PASSWORD "123123@smartschool"




void Network::initWiFi(){
 
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
}

void Network::initFirebase()
{
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
    config.api_key = API_KEY;

    /* Assign the user sign in firestore */
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;
    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
}

void Network::FirestoreDataUpdate(String studentUID)
{
   FirebaseJson updateData;

  if(WiFi.status() == WL_CONNECTED && Firebase.ready())
  {

     /* Path to save data of uid and student status */
    String documentPath = "Countries/RBH9GduunnyuyMqZ3kcz/Schools/EsiA0KfrRPBTJM2WBd87/Canteen/NoOml9Tj3MfGJgQpNk34";   

    updateData.clear();
    //updateData.set("fields/canteenStatus/booleanValue", true);
    FirebaseJson updateData;
    updateData.set("fields/CurrentBuyer/stringValue", studentUID);

    Serial.print("Update a document... ");

        /** if updateMask contains the field name that exists in the remote document and
         * this field name does not exist in the document (content), that field will be deleted from remote document
         */

if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, documentPath.c_str(), updateData.raw(), "CurrentBuyer" /* updateMask */))
      Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
    else
      Serial.println(fbdo.errorReason());
  
  }
}