String readString;
      
float sensor;
float sensor_raw;
int dc_pin = 9;  
int pwm;
int power;              

unsigned long message_time;
unsigned long message_time_prev;

void setup() {
  pinMode(dc_pin, OUTPUT);                          
  Serial.begin(9600);

}

void loop() {

  while (Serial.available()) {
    char c = Serial.read();  
    readString += c; 
    delay(2);
  }

  if (readString.length() >0) {
    
      power  = readString.toInt();  
      readString=""; 
    }
  
  message_time = millis() - message_time_prev;
  if (message_time > 500){

  
  pwm = map(power, 0,100,0,255);
  analogWrite(dc_pin, pwm);
  
  sensor_raw = ((analogRead(A0))/10);
  sensor = sensor_raw;
  //Serial.print(power); 
  //Serial.print("  ");
  //Serial.print(pwm); 
  //Serial.print("  "); 
  Serial.print(sensor); 
  Serial.println(); 
  message_time_prev = millis();
  }

}
