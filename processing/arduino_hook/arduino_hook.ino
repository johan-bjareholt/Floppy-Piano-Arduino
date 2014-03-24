int lastkey;
int octaves = 3;

void setup() {
  // initialize serial communication
  Serial.begin(9600);
}

void loop() {
  // Read pot 
  int potval = analogRead(A0);
  // Convert pot to 3 octave piano
  int tonenum = map(potval, 0, 1024, 0, (12*octaves)-1);
  if (tonenum != lastkey){
    // Int to byte conversion to prepare for Serial.write
    byte tonenum_byte = char(tonenum);
    byte tonenum_release_byte = char(lastkey+(12*octaves));
    // Write byte to serial
    //Serial.println(tonenum);
    Serial.write(tonenum_byte);
    Serial.write(tonenum_release_byte);
    lastkey = tonenum;
  }
  delay(100);
}
