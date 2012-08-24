/*

*/


#include <IRremote.h>
#include <Messenger.h>

//initialize messenger with ":" separator
Messenger message = Messenger(':'); 

//initialize irsend
IRsend irsend;

void setup()
{
 Serial.begin(9600); 
 message.attach(messageReady);
 //Serial.println("started..");
 pinMode(13,1);
 digitalWrite(13,0);
}

void messageReady() {
    //Serial.println("reading");
       // Loop through all the available elements of the message
       while ( message.available() ) {
         char cmd[50] = "";
	 message.copyString(cmd, 50);
         long data1 = message.readLong();
         long data2 = message.readLong();
         
         /*Serial.print(cmd);
         Serial.print(":");
         Serial.print(data1);
         Serial.print(":");
         Serial.println(data2);
         */
         
         long result = 1;
         
         //process commands
         if (String("irsend").equals(cmd)) {
           sendIR(data1);
           //no confirmation for IR
           return;
         }
         
         if (String("pinmode").equals(cmd)) {
           //Serial.println("detected pinmode");
           pinMode(data1,data2);
         }
         
         if (String("aread").equals(cmd)) {
           //Serial.println("detected");
           result = aRead(data1);
           
         }
         
         if (String("awrite").equals(cmd)) {
           //Serial.println("detected");
           aWrite(data1, data2);
           
         }
         
         if (String("dread").equals(cmd)) {
           //Serial.println("detected");
           result = dRead(data1);
           
         }
         
         if (String("dwrite").equals(cmd)) {
           //Serial.println("detected");
           dWrite(data1, data2);
           
         }
         
         if (String("0").equals(cmd)) {
           //bogus command - ignore
           return;
           
         }
         
         sendResult(cmd, data1, data2, result);
      }
      
      
}

void sendResult(char* cmd, long data1, long data2, long result) {
  Serial.print(cmd);
  Serial.print(":");
  Serial.print(data1);
  Serial.print(":");
  Serial.print(data2); 
  Serial.print(":");
  Serial.println(result); 
}

long aRead(long pin) {
  long result = analogRead(pin);
  return result; 
}

void aWrite(long pin, long val) {
  analogWrite(pin, val);
  
}

long dRead(long pin) {
  long result = digitalRead(pin);
  return result; 
}

void dWrite(long pin, long val) {
  digitalWrite(pin, val);
   
}

long sendIR(long data) {
  //long data = 652;
  //Serial.println(data);
  irsend.sendRC5(data, 12);
  
  return 1;
}

void loop() {
  while ( Serial.available() )  message.process(Serial.read () );   
}
