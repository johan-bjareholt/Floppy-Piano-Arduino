int bit0 = 0;
int bit1 = 0;
int bit2 = 0;
int bit3 = 0;

int count = 0;
boolean values[] = {1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1};
boolean prevValues[] = {1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1};

boolean changed = false;

void setup(){
 pinMode(A0, OUTPUT);
 pinMode(A1, OUTPUT);
 pinMode(A2, OUTPUT);
 pinMode(A3, OUTPUT);
 
 pinMode(13, INPUT_PULLUP);
 Serial.begin(9600);
}

void loop(){
  for(int i = 0; i<=15; i++){
    prevValues[i] = values[i];
  }
  changed = false;
  
  for(count = 0; count<=15; count++){
  
  bit0 = bitRead(count, 0);
  bit1 = bitRead(count, 1);
  bit2 = bitRead(count, 2);
  bit3 = bitRead(count, 3);
  
  digitalWrite(A0, bit0);
  digitalWrite(A1, bit1);
  digitalWrite(A2, bit2);
  digitalWrite(A3, bit3);
  
  values[count] = digitalRead(13);
  
  if(values[count] != prevValues[count]){
    changed = true; 
  }
  }
  
  if(changed){
    for(int i = 0; i<=15; i++){
      Serial.print(values[i]); 
    }
    Serial.println("");
  }
}

