#include "Network.h"

//#define WIFI_SSID "POCO F3"
//#define WIFI_PASSWORD "123456789"
#define WIFI_SSID "Khater"
#define WIFI_PASSWORD "#khater#12"

#define API_KEY "AIzaSyAzxeW0A5HnyOQ_gnLI0wVySnVm30RTjpc"
#define FIREBASE_PROJECT_ID "smartschool-6aee1"
#define USER_EMAIL "admin01@smartschool.com"
#define USER_PASSWORD "123123@smartschool"
#define FIREBASE_FCM_SERVER_KEY "AAAArAAgmhg:APA91bFj5XE1LoBN9ZdzthL9rh77pFIDSfeSlv7xEiAkBpuMNymcLh4RkFNOdOoid9EYClLMdTRKCFIqOKZlnzKxIoVfBX4UBGrsf94Su0K0qQd8xkapt7xvzohfX6B0VO8c4K54rAOV"

//const int BUZZER = 25;

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

    /* Assign the callback function for the long running token generation task */

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);

    // required for legacy HTTP API
    Firebase.FCM.setServerKey(FIREBASE_FCM_SERVER_KEY);
}

void Network::FirestoreDataUpdate(String studentUID, String actionType)
{
   FirebaseJson updateData;

  if(WiFi.status() == WL_CONNECTED && Firebase.ready())
  {
    Serial.print("Update a document... ");
    
     /* Path to save data of uid and student status */
    String documentPath = "Countries/RBH9GduunnyuyMqZ3kcz/Schools/EsiA0KfrRPBTJM2WBd87/Students/" + studentUID + "/SchoolAttendance/" + actionType;         
    //String documentPath = "Mohamed/HDK2CnBhPBxPygo3zkG/l_collection/" + studentUID;
    std::vector<struct fb_esp_firestore_document_write_t> writes;      
    struct fb_esp_firestore_document_write_t update_write;
    update_write.type = fb_esp_firestore_document_write_type_update;
    updateData.clear();
    //updateData.set("fields/canteenStatus/booleanValue", true);
    FirebaseJson updateData;
    updateData.set("fields/action/stringValue", actionType);
    update_write.update_document_content = updateData.raw();
    update_write.update_document_path = documentPath.c_str();
    update_write.update_masks = "action";
    Serial.println(updateData.raw());
    
    writes.push_back(update_write);
    
    // set updateTime
    struct fb_esp_firestore_document_write_t transform_write;
    transform_write.type = fb_esp_firestore_document_write_type_transform;
    transform_write.document_transform.transform_document_path = documentPath;
    struct fb_esp_firestore_document_write_field_transforms_t field_transforms;
    field_transforms.fieldPath = "updateTime";
    field_transforms.transform_type = fb_esp_firestore_transform_type_set_to_server_value;
    field_transforms.transform_content = "REQUEST_TIME";
    // Add a field transformation object to a write object.
    transform_write.document_transform.field_transforms.push_back(field_transforms);
    writes.push_back(transform_write);

    

        /** if updateMask contains the field name that exists in the remote document and
         * this field name does not exist in the document (content), that field will be deleted from remote document
         */

    if (Firebase.Firestore.commitDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, writes /* dynamic array of fb_esp_firestore_document_write_t */, "" /* transaction */))
      {
        Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
        sendNotification("Countries/RBH9GduunnyuyMqZ3kcz/Schools/EsiA0KfrRPBTJM2WBd87/Students/" + studentUID, "parent,name", actionType);
        tone(BUZZER, 2000); 
        delay(200);        
        noTone(BUZZER);
        delay(200);
      }
    else
      Serial.println(fbdo.errorReason());
  
  }
}

String Network::getDocumentFieldValue(String path, String mask)
{

    Serial.print("Get a document... ");

        if (Firebase.Firestore.getDocument(&fbdo, FIREBASE_PROJECT_ID, "", path.c_str(), mask.c_str()))
        {
          Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
          return fbdo.payload();
        }
        else
            Serial.println(fbdo.errorReason());

    return "";
}

void Network::sendNotification(String path, String mask, String actionType)
{
  String parentId="";
  String name = "";
  String DEVICE_REGISTRATION_ID_TOKEN="";

  String payload;
  FirebaseJson data;
  FirebaseJsonData result;

  payload = getDocumentFieldValue(path, mask);
  data.setJsonData(fbdo.payload().c_str());
  data.get(result, "fields/parent/stringValue");
  parentId = result.to<const char*>();
  data.get(result, "fields/name/stringValue");
  name = result.to<const char*>();
  Serial.println("Student data");
  Serial.println(parentId);
  Serial.println(name);

  // get parent device token
  payload = getDocumentFieldValue("Parents/" + parentId, "device_token");
  data.setJsonData(fbdo.payload().c_str());
  data.get(result, "fields/device_token/stringValue");
  DEVICE_REGISTRATION_ID_TOKEN = result.to<const char*>();
  Serial.println(DEVICE_REGISTRATION_ID_TOKEN);



    Serial.print("Send Firebase Cloud Messaging... ");

    // Read more details about legacy HTTP API here https://firebase.google.com/docs/cloud-messaging/http-server-ref
    FCM_Legacy_HTTP_Message msg;

    msg.targets.to = DEVICE_REGISTRATION_ID_TOKEN;

    msg.options.priority = "HIGH";

    msg.payloads.notification.title = "School Attendance ";
    msg.payloads.notification.body = getFirstName(name) + " " + actionType;
    
    // For the usage of FirebaseJson, see examples/FirebaseJson/BasicUsage/Create.ino
    FirebaseJson messageData;

    // all data key-values should be string
    messageData.add("click_action", "FLUTTER_NOTIFICATION_CLICK");
    
    msg.payloads.data = messageData.raw();

    if (Firebase.FCM.send(&fbdo, &msg)) // send message to recipient
        Serial.printf("ok\n%s\n\n", Firebase.FCM.payload(&fbdo).c_str());
    else
        Serial.println(fbdo.errorReason());
}



String Network::getFirstName(String fullName) {
  String firstName = "";

  // Find the first space in the full name
  int firstSpaceIndex = fullName.indexOf(" ");
  if (firstSpaceIndex >= 0) {
    // Extract the first name
    firstName = fullName.substring(0, firstSpaceIndex);
    
    // Capitalize the first letter of the first name
    firstName[0] = toupper(firstName[0]);
  }

  Serial.println(firstName);
  return firstName;
}