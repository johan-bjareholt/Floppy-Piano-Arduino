void initialize_serial() {
  try {
    serial = new Serial(this, Serial.list()[0], 9600);
    serial_on = true;
  }
  catch (Exception e) {
    print("Could not open serial port (");
    print(e);
    print(")");
    serial_on = false;
  }
}

void read_serial() {
  if ( serial.available() > 0) {
    int serialValue = serial.read();
    println(serialValue);
    if (serialValue < 12*octaves){
      int tone = serialValue;
      println("Tone " + tone + "was pushed");
      Pianokey pianokey = pianokeys.get(serialValue);
      pianokey.press();
      pianokey.draw();
    }
    else if (serialValue >= 12*octaves && serialValue < 2*(12*octaves)) {
      int tone = serialValue-(12*octaves);
      println("Tone " + tone + "was released");
      Pianokey pianokey = pianokeys.get(serialValue-(12*octaves));
      pianokey.release();
      pianokey.draw();
    }
  }
}
