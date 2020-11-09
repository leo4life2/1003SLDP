#include <SoftwareSerial.h>
#include <ArduinoHttpClient.h>
#include <ESP8266WiFi.h>

SoftwareSerial NodeMCU(D2, D3);

const char ssid[] = "399";
const char pw[] = "wifi931018";

const char* host = "dweet.io";

const char serverAddress[] = "dweet.io";  // server address
int port = 80;
String dweetName = "wiswitch"; // use your own thing name here

WiFiClient wifi;
HttpClient client = HttpClient(wifi, serverAddress, port);
int status = WL_IDLE_STATUS;

int prev_val = 0;


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
  // assemble the path for the GET message:
  String path = "/listen/for/dweets/from/" + dweetName;

  // send the GET request
  Serial.println("making GET request");
  client.get(path);

  // read the status code and body of the response
  int statusCode = client.responseStatusCode();
  String response = client.responseBody();
  Serial.print("Status code: ");
  Serial.println(statusCode);
  Serial.print("Response: ");
  Serial.println(response);
  Serial.print("Is chunked: ");
  Serial.println(client.isResponseChunked());

  /*
    Typical response is:
    {"this":"succeeded",
    "by":"getting",
    "the":"dweets",
    "with":[{"thing":"my-thing-name",
      "created":"2016-02-16T05:10:36.589Z",
      "content":{"sensorValue":456}}]}
    You want "content": numberValue
  */
  
  // now parse the response looking for "content":
  int labelStart = response.indexOf("content\\\":");
  // find the first { after "content":
  int contentStart = response.indexOf("{", labelStart);
  // find the following } and get what's between the braces:
  int contentEnd = response.indexOf("}", labelStart);
  String content = response.substring(contentStart + 2, contentEnd - 2);
  Serial.println(content);

  // now get the value after the colon, and convert to an int:
  int valueStart = content.indexOf(":");
  String valueString = content.substring(valueStart + 3);
  Serial.print("Value string: ");
  Serial.println(valueString);

  handleResponse(valueString);
  
  Serial.println("Wait 1 second\n");
  delay(1000);
}

void handleResponse(String response){
  Serial.println(response);

  int val = prev_val;

  if (response == "true"){
    val = 1;
  } else if (response == "false"){
    val = -1;
  } else if (response == "neutral"){
    val = 0;
  } else {
    return;
  }
  
  if (val != prev_val){
    // If value is not the same as previous one, trigger the motor
    Serial.print("val changed! now is: ");
    Serial.println(val);

    NodeMCU.write(val);
    
    prev_val = val;
  }
  
}
