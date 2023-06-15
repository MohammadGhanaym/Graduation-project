#ifndef Network_H_
#define Network_H_
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
const int BUZZER = 25;
class Network{
private:
  FirebaseData fbdo;
  FirebaseAuth auth;
  FirebaseConfig config;

public:
  void initWiFi();
  void initFirebase();
  void FirestoreDataUpdate(String studentUID);
};


#endif