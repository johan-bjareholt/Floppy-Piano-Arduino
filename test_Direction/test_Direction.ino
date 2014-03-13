int directionPin = 0;
int activationPin = 1;
int btnPin = 2;
int potPin = A0;

boolean active = LOW;
boolean onOffState = LOW;
boolean prevOnOffState = LOW;
boolean activationState = LOW;
boolean directionState = HIGH;

int currentPosition = 0;
int maxPosition = 80;
int potVal = 0;
int mapPot = 0;

static int microPeriods[] = {       
        30578, 28861, 27242, 25713, 24270, 22909, 21622, 20409, 19263, 18182, 17161, 16198, //C1 - B1
        15289, 14436, 13621, 12856, 12135, 11454, 10811, 10205, 9632, 9091, 8581, 8099, //C2 - B2
        7645, 7218, 6811, 6428, 6068, 5727, 5406, 5103, 4816, 4546, 4291, 4050, //C3 - B3
        3823, 3609, 3406, 3214, 3034, 2864, 2703, 2552, 2408, 2273, 2146, 2025, //C4 - B4
};
        
void setup(){
 pinMode(directionPin, OUTPUT);
 pinMode(activationPin, OUTPUT);
 pinMode(btnPin, INPUT);
 pinMode(potPin, INPUT);
 //Serial.begin(9600);
}
 
void loop(){

onOffState = digitalRead(btnPin);
potVal = analogRead(A0);
mapPot = constrain(map(potVal, 0, 1023, 12, 47), 12, 47);
//Serial.println(mapPot);

if(onOffState != prevOnOffState){
  // change the value of active if pressed
  if(onOffState == HIGH){
  active = !active;
  }
}
if(active){
  if (currentPosition >= maxPosition) {
    directionState = LOW;
    digitalWrite(directionPin, directionState);
  } 
  else if (currentPosition <= 0) {
    directionState = HIGH;
    digitalWrite(directionPin, directionState);
  }
  
  digitalWrite(activationPin,HIGH);
  delayMicroseconds(microPeriods[mapPot]);
  digitalWrite(activationPin,LOW);
  
  if(directionState == LOW){
    currentPosition--;
  }
  else{
    currentPosition++; 
  } 
}
prevOnOffState = onOffState;
}
