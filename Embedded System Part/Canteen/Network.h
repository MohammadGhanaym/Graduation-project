#ifndef Network_H_
#define Network_H_
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

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