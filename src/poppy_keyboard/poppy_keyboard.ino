boolean values[] = {1,1,1,1, 1,1,1,1};
boolean prevValues[] = {1,1,1,1, 1,1,1,1};

// Values for each floppy representing it's activation and direction pins
// -1 = unused
// 0< = button assigned
short assigned[] = {0,0,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0};

void setup(){
 // Multiplexer control pins
 pinMode(A0, OUTPUT);
 pinMode(A1, OUTPUT);
 pinMode(A2, OUTPUT);
 // Multiplexer read pin
 pinMode(13, INPUT_PULLUP);
 
 Serial.begin(9600);
}

void loop(){
  boolean changed = false;  
  for(int keyNum = 0; keyNum<=7; keyNum++){
    if (readKey(keyNum)){
      changed = true;
      // Iterate floppys activation pins
      for (int activationPin = 2; activationPin <= 6; activationPin+=2){
        // If key is pressed
        if(values[keyNum] == 0){
          // If floppy not busy
          if (assigned[activationPin] < 0){
            // Set tone to activation pin
            //currentPeriod[activationPin] = (microPeriods[keyNum])/(RESOLUTION*2);
            Serial.write(char(keyNum));
            // Memorize button
            assigned[activationPin] = keyNum;
            //Serial.print("button ");
            //Serial.print(keyNum);
            //Serial.println(" is pressed");
            //Serial.print(assigned[activationPin]);
            //Serial.print(" to: ");
            //Serial.println(activationPin);
            // Stop loop
            activationPin = 9;
          }
        }
        // If key is released
        else if (values[keyNum] == 1){
          // If floppy is busy with current butNum
          if(assigned[activationPin] == keyNum){
            // Stop floppy
            //currentPeriod[activationPin] = 0;
            Serial.write(char(keyNum+(12*3)));
            //Serial.print("button ");
            //Serial.print(keyNum);
            //Serial.println(" is released");
            //Serial.print(assigned[activationPin]);
            //Serial.print(" from: ");
            //Serial.println(activationPin);       
            // Set floppy floppy as unused
            assigned[activationPin] = -1;
            // Stop loop
            activationPin = 9;
          }
        }
      }
    }
  }
  
  if(changed){
    for(int i = 0; i<=7; i++){
      //Serial.print(values[i]); 
    }
    //Serial.println("");
  }
}

boolean readKey (int keyNum){
  prevValues[keyNum] = values[keyNum];

  short bit0 = bitRead(keyNum, 0);
  short bit1 = bitRead(keyNum, 1);
  short bit2 = bitRead(keyNum, 2);
  
  digitalWrite(A0, bit0);
  digitalWrite(A1, bit1);
  digitalWrite(A2, bit2);
  
  values[keyNum] = digitalRead(13);
  
  if(values[keyNum] != prevValues[keyNum]){
    return true;
  }
  else {
    return false;
  }
}
