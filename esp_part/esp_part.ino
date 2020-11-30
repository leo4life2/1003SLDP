#include <SoftwareSerial.h>

#include <ESP8266WiFi.h>
#define PubNub_BASE_CLIENT WiFiClient
#include <SPI.h>
#include <PubNub.h>

SoftwareSerial NodeMCU(D2, D3);

const char ssid[] = "精神三小伙";
const char pw[] = "womendewifi666";

char pubkey[]  = "pub-c-7c6e3833-ad7f-455b-bf96-cd4ed9b98bcd";
char subkey[]  = "sub-c-aabca7ee-3300-11eb-9d95-7ab25c099cb1";
char channel[] = "channel1";

WiFiClient wifi;
int status = WL_IDLE_STATUS;

int prev_val = 0;


void setup() {
  // -- Comms between Uno and NodeMCU
  Serial.begin(9600);
  NodeMCU.begin(9600);

  pinMode(D2, INPUT);
  pinMode(D3, OUTPUT);

  initWifi();

  PubNub.begin(pubkey, subkey);
  Serial.println("PubNub set up");
}

void initWifi(){
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
    Serial.println("waiting for a message (subscribe)");
    PubSubClient* client = PubNub.subscribe(channel);
    if (!client) {
        Serial.println("subscription error");
        delay(1000);
        return;
    }

    String msg;
    SubscribeCracker ritz(client);
    while (!ritz.finished()) {
        ritz.get(msg);
        if (msg.length() > 0) {
            Serial.print("Received: ");
            Serial.println(msg);
            handleResponse(msg);
        }
    }

    client->stop();

    delay(500);
}

void handleResponse(String response){
  int val = prev_val;

  if (response == "\"true\""){
    Serial.println("resp is true");
    val = 1;
  } else if (response == "\"false\""){
    Serial.println("resp is false");
    val = -1;
  } else {
    Serial.print("resp is");
    Serial.println(response);
    return;
  }
  
  if (val != prev_val){
    // If value is not the same as previous one, trigger the motor
    Serial.print("val changed! now is: ");
    Serial.println(val);

    NodeMCU.write(1);
    
    prev_val = val;
  }
  
}
