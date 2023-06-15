//Select your modem
//SSL/TLS is currently supported only with SIM8xx series
#define TINY_GSM_MODEM_SIM800
//Increase RX buffer
#define TINY_GSM_RX_BUFFER 256
#include <SoftwareSerial.h>
#include <TinyGPS++.h> //https://github.com/mikalhart/TinyGPSPlus
#include <TinyGsmClient.h> //https://github.com/vshymanskyy/TinyGSM
#include <ArduinoHttpClient.h> //https://github.com/arduino-libraries/ArduinoHttpClient
#include <ArduinoJson.h>

const char FIREBASE_HOST[]  = "firestore.googleapis.com";
const String FIREBASE_AUTH  = "AIzaSyAzxeW0A5HnyOQ_gnLI0wVySnVm30RTjpc";
const String FIREBASE_PATH  = "/v1/projects/smartschool-6aee1/databases/(default)/documents/Countries/RBH9GduunnyuyMqZ3kcz/Schools/EsiA0KfrRPBTJM2WBd87/Students/4125209170162137/Location/location";
const int SSL_PORT          = 443;

// kThe serial connection to the GPS device
String str_date = "";
String str_time = "";
double latitude , longitude;
String lat_str , lng_str;

char apn[]  = "internet.vodafone.net";
char user[] = "";
char pass[] = "";

#define rxPin 4
#define txPin 2
HardwareSerial sim800(1);
TinyGsm modem(sim800);

#define RXD2 18
#define TXD2 19
HardwareSerial neogps(2);
TinyGPSPlus gps;
TinyGsmClientSecure gsm_client_secure_modem(modem, 0);
HttpClient http_client = HttpClient(gsm_client_secure_modem, FIREBASE_HOST, SSL_PORT);

unsigned long previousMillis = 0;
long interval = 10000;

void setup() {
  Serial.begin(115200);
  Serial.println("esp32 serial initialize");
  
  sim800.begin(9600, SERIAL_8N1, rxPin, txPin);
  Serial.println("SIM800L serial initialize");

 // neogps.begin(9600, SERIAL_8N1, RXD2, TXD2);
  //Serial.println("neogps serial initialize");
  neogps.begin(9600, SERIAL_8N1, RXD2, TXD2);
  Serial.println("neogps serial initialize");
  delay(3000);
  
  Serial.println("Initializing modem...");
  modem.restart();
  String modemInfo = modem.getModemInfo();
  Serial.print("Modem: ");
  Serial.println(modemInfo);
  
  http_client.setHttpResponseTimeout(90 * 1000); //^0 secs timeout
}

void loop() {
  Serial.print(F("Connecting to "));
  Serial.print(apn);
  if (!modem.gprsConnect(apn, user, pass)) {
    Serial.println(" fail");
    delay(1000);
    return;
  }
  Serial.println(" OK");
  
  http_client.connect(FIREBASE_HOST, SSL_PORT);
  
  while (true) {
    if (!http_client.connected()) {
      Serial.println();
      http_client.stop();// Shutdown
      Serial.println("HTTP not connect");
      break;
    }
    else{
      gps_loop();
    }
  }
}

void PostToFirebase(const char* method, const String & path, double latitude, double longitude, const String & time, const String & date, HttpClient* http) {
  String response;
  int statusCode = 0;
  http->connectionKeepAlive(); // Currently, this is needed for HTTPS
  
  String url = path + "?key=" + FIREBASE_AUTH;
  Serial.print(method);
  Serial.print(":");
  Serial.println(url);
    // Create a StaticJsonDocument with enough capacity for the JSON object
    StaticJsonDocument<256> jsonDoc;

    // Set the fields in the JSON object
    jsonDoc["fields"]["latitude"]["doubleValue"] = latitude;
    jsonDoc["fields"]["longitude"]["doubleValue"] = longitude;
    jsonDoc["fields"]["date"]["stringValue"] = date.c_str();
    jsonDoc["fields"]["time"]["stringValue"] = time.c_str();

    // Convert the JSON object to a String
    String data;
    serializeJson(jsonDoc, data);

  // Create a JSON object with the GPS data
  Serial.print("Data:");
  Serial.println(data);
  
  String contentType = "application/json";
  http->beginRequest();

  // Use the method parameter to determine the type of request
  if (strcmp(method, "PATCH") == 0) {
    http->patch(url, contentType, data);
  } else if (strcmp(method, "POST") == 0) {
    http->post(url, contentType, data);
  } else if (strcmp(method, "PUT") == 0) {
    http->put(url, contentType, data);
  } else {
    Serial.println("Invalid method specified.");
    return;
  }
  
  statusCode = http->responseStatusCode();
  Serial.print("Status code: ");
  Serial.println(statusCode);
  response = http->responseBody();
  Serial.print("Response: ");
  Serial.println(response);

  if (!http->connected()) {
    Serial.println();
    http->stop(); // Shutdown
    Serial.println("HTTP disconnected");
  }
}


void gps_loop() {
  latitude = gps.location.lat();
  longitude = gps.location.lng();
  printFloat(gps.location.lat(), gps.location.isValid(), 11, 6);
  printFloat(gps.location.lng(), gps.location.isValid(), 12, 6);
  
  str_date = printDate(gps.date);
  Serial.print(' ');
  str_time = printTime(gps.time);
  lat_str = String(latitude , 14); 
  lng_str = String(longitude , 14);
  Serial.println();
   
    if (gps.location.isValid())
   {
     //String jsonString = "{\"fields\":{\"to\":{\"stringValue\":\"ELOMDA\"}}}";
     PostToFirebase("PATCH", FIREBASE_PATH, latitude, longitude, str_time, str_date, &http_client);
     //network.FirestoreDataUpdate(str_date, str_time, latitude, longitude);
     delay(10000);

   }

  smartDelay(1000);

  if (millis() > 5000 && gps.charsProcessed() < 10)
    Serial.println(F("No GPS data received: check wiring"));
}

// This custom version of delay() ensures that the gps object
// is being "fed".
static void smartDelay(unsigned long ms)
{
  unsigned long start = millis();
  do 
  {
    while (neogps.available())
      gps.encode(neogps.read());
  } while (millis() - start < ms);
}

static void printFloat(float val, bool valid, int len, int prec)
{
  if (!valid)
  {
    while (len-- > 1)
      Serial.print('*');
    Serial.print(' ');
  }
  else
  {
    Serial.print(val, prec);
    int vi = abs((int)val);
    int flen = prec + (val < 0.0 ? 2 : 1); // . and -
    flen += vi >= 1000 ? 4 : vi >= 100 ? 3 : vi >= 10 ? 2 : 1;
    for (int i=flen; i<len; ++i)
      Serial.print(' ');
  }
  smartDelay(0);
}

static void printInt(unsigned long val, bool valid, int len)
{
  char sz[32] = "*****************";
  if (valid)
    sprintf(sz, "%ld", val);
  sz[len] = 0;
  for (int i=strlen(sz); i<len; ++i)
    sz[i] = ' ';
  if (len > 0) 
    sz[len-1] = ' ';
  Serial.print(sz);
  smartDelay(0);
}

String printDate(TinyGPSDate &d)
{
  if (!d.isValid())
  {
    Serial.print(F("********** "));
  }
  else
  {
    char sz[32];
    sprintf(sz, "%02d/%02d/%02d", d.month(), d.day(), d.year());
    Serial.print(sz);
    return sz;
  }
}

String printTime(TinyGPSTime &t)
{
  if (!t.isValid())
  {
    Serial.print(F("******** "));
  }
  else
  {
    char sz[32];
    sprintf(sz, "%02d:%02d:%02d", t.hour() + 2, t.minute(), t.second());
    Serial.print(sz);
    return sz;
  }
}


static void printStr(const char *str, int len)
{
  int slen = strlen(str);
  for (int i=0; i<len; ++i)
    Serial.print(i<slen ? str[i] : ' ');
  smartDelay(0);
}
