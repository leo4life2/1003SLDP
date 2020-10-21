#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>

SoftwareSerial NodeMCU(D2, D3);

const char* ssid = "399";
const char* pw = "wifi931018";

const char* host = "dweet.io";

char prev_val = 'z';


void setup() {
  // -- Comms between Uno and NodeMCU
  Serial.begin(9600);
  NodeMCU.begin(4800);

  pinMode(D2, INPUT);
  pinMode(D3, OUTPUT);

  // -- Init Wifi
  WiFi.begin(ssid, pw);

  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(500);
  }
  
  Serial.println("");
  Serial.print("IP Adrress: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  // put your main code here, to run repeatedly:

//  delay(500);

//  Serial.print("connecting to ");
//  Serial.println(host);

   // Use WiFiClient class to create TCP connections
  WiFiClient client;
  const int httpPort = 80;
  if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;
  }
  
  // We now create a URI for the request
  String url = "https://dweet.io:443/get/latest/dweet/for/thisisourdoor";

  // Send request
//  Serial.print("Requesting URL: ");
//  Serial.println(url);
  
  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" + 
               "Connection: close\r\n\r\n");
               
  unsigned long timeout = millis();
  
  while (client.available() == 0) {
    if (millis() - timeout > 5000) {
      Serial.println(">>> Client Timeout !");
      client.stop();
      return;
    }
  }

  // Read all the lines from the answer
  while(client.available()){
    String line = client.readStringUntil('\r');
    handleResponse(line);
  }

  // Close connecting
//  Serial.println();
//  Serial.println("closing connection");
}

void handleResponse(String response){
  Serial.println(response);

  char* lock = strstr(response.c_str(), "\"lock\":");
  
  if (lock > 0){
    char val = lock[7];
//    Serial.println(val);

    if (val != prev_val){
      Serial.print("val changed! now is: ");
      Serial.println(val);

      NodeMCU.write(0);
      
      prev_val = val;
    }
  }
}
