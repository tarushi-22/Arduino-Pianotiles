int val1; 
int inputPin = 1;                // Set the input to analog in pin 0
int pirPin = 3;                 // PIR Out pin 
int pirStat ;  
int but;
const int buttonPin = 2;     // the number of the pushbutton pin
int buttonState = 0;         // variable for reading the pushbutton status
const int ProxSensor=2;
int inputVal = 0;
 
void setup() { 
  Serial.begin(9600); // Start serial communication at 9600 bps 
  pinMode(pirPin, INPUT); 
  pinMode(buttonPin, INPUT);// initialize the pushbutton pin as an input:
  
  pinMode(ProxSensor,INPUT);    //Pin 2 is connected to the output of proximity senso
} 
 
void loop() { 
   pirStat = digitalRead(pirPin); 
 if (pirStat == 1) {            // if motion detected
  Serial.println(pirStat);
 } 
 else {
   pirStat=0;
   Serial.println(0);
  val1 = analogRead(inputPin);// Read analog input pin, put in range 0 to 255
  if(val1>=500)
  Serial.println(val1); // Send the value
  delay(100);                    // Wait 100ms for next reading 
   // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (buttonState == HIGH) {
    but=1;
    Serial.print(but);
  } else {
    but=0;
    Serial.print(but);
}

inputVal = digitalRead(ProxSensor);
Serial.println(inputVal);
delay(1000);              // wait for a second
 }
}
