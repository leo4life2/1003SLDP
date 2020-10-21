#include "SoftwareSerial.h"
#include "Servo.h"

SoftwareSerial ArduinoUno(3, 2);

Servo servo;
float ang = 0;

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);
  ArduinoUno.begin(4800);

  servo.attach(8);

  servo.write(ang);
}

void loop() {
  // put your main code here, to run repeatedly:

  while (ArduinoUno.available()>0){ // if there is data it's gonaa be >0

    Serial.println(ArduinoUno.read());
    
    if (ArduinoUno.parseFloat() == 0.0){
      
      Serial.println("servo motor moving");
      
      if (ang == 0){
        ang = 180;
      } else {
        ang = 0;
      }

      servo.write(ang);
      
    }
    
  }
  delay(30);
}