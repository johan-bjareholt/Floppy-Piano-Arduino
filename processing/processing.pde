// Window size
int window_x = 1280;
int window_y = 720;

// Serial enabled
boolean serial_on = false;

// Button amount
int octaves = 3;
ArrayList<Pianokey> pianokeys;

// Keyboard setup
import processing.serial.*;
Serial serial;

void setup(){
  // Sets screen resolution
  size(window_x,window_y);
  //frame.setResizable(true);
  pianokeys = new ArrayList<Pianokey>();
  for (int keynum=0; keynum<octaves*12; keynum++){
    pianokeys.add(new Pianokey(keynum));
  }
  /*
    Setial setup
  */
  println("Available serial ports:");
  println(Serial.list());
  
  if (serial_on){
    serial = new Serial(this, Serial.list()[0], 9600);
  }
}

void draw(){
   /*
    Base draw
  */
  rectMode(CORNER);
  background(40);    // Setting the background
  // Piano key size
  int pianokey_w = window_x/(7*octaves);
  int pianokey_h = 100;
  // Tone lines
  int toneline_spacing = window_x/(12*octaves);
  stroke(120);
  for (int linenum=0; linenum<(12*octaves); linenum++){
    line(linenum*toneline_spacing, 0, linenum*toneline_spacing, window_y);
  }
  // Draw pianokeys
  for (int keynum=0; keynum<pianokeys.size(); keynum++){
    Pianokey pianokey = pianokeys.get(keynum);
    pianokey.draw();
  }
 /*
    Serial check
  */
 if (serial_on){
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
     else if (serialValue > 12*octaves && serialValue < 2*(12*octaves)) {
       int tone = serialValue-(12*octaves);
       println("Tone " + tone + "was released");
       Pianokey pianokey = pianokeys.get(serialValue-(12*octaves));
       pianokey.release();
       pianokey.draw();
     }
   }
 }
 textSize(16);
 text("Frame rate: " + int(frameRate), 10, 20);
}

void keyPressed(){
  Pianokey pianokey;
  switch(key) {
    case('a'):case('A'):pianokey = pianokeys.get(0); pianokey.press(); pianokey.draw();break;
    case('w'):case('W'):pianokey = pianokeys.get(1); pianokey.press() ;pianokey.draw();break;
    case('s'):case('S'):pianokey = pianokeys.get(2); pianokey.press() ;pianokey.draw();break;
    case('e'):case('E'):pianokey = pianokeys.get(3); pianokey.press() ;pianokey.draw();break;
    case('d'):case('D'):pianokey = pianokeys.get(4); pianokey.press() ;pianokey.draw();break;
    case('f'):case('F'):pianokey = pianokeys.get(5); pianokey.press() ;pianokey.draw();break;
    case('t'):case('T'):pianokey = pianokeys.get(6); pianokey.press() ;pianokey.draw();break;
    case('g'):case('G'):pianokey = pianokeys.get(7); pianokey.press() ;pianokey.draw();break;
    case('y'):case('Y'):pianokey = pianokeys.get(8); pianokey.press() ;pianokey.draw();break;
    case('h'):case('H'):pianokey = pianokeys.get(9); pianokey.press() ;pianokey.draw();break;
    case('u'):case('U'):pianokey = pianokeys.get(10); pianokey.press() ;pianokey.draw();break;
    case('j'):case('J'):pianokey = pianokeys.get(11); pianokey.press() ;pianokey.draw();break;
    case('k'):case('K'):pianokey = pianokeys.get(12); pianokey.press() ;pianokey.draw();break;
    case('o'):case('O'):pianokey = pianokeys.get(13); pianokey.press() ;pianokey.draw();break;
    case('l'):case('L'):pianokey = pianokeys.get(14); pianokey.press() ;pianokey.draw();break;
  }
}
 
void keyReleased(){
  Pianokey pianokey;
  switch(key) {
    case('a'):case('A'):pianokey = pianokeys.get(0); pianokey.release() ;pianokey.draw();break;
    case('w'):case('W'):pianokey = pianokeys.get(1); pianokey.release() ;pianokey.draw();break;
    case('s'):case('S'):pianokey = pianokeys.get(2); pianokey.release() ;pianokey.draw();break;
    case('e'):case('E'):pianokey = pianokeys.get(3); pianokey.release() ;pianokey.draw();break;
    case('d'):case('D'):pianokey = pianokeys.get(4); pianokey.release() ;pianokey.draw();break;
    case('f'):case('F'):pianokey = pianokeys.get(5); pianokey.release() ;pianokey.draw();break;
    case('t'):case('T'):pianokey = pianokeys.get(6); pianokey.release() ;pianokey.draw();break;
    case('g'):case('G'):pianokey = pianokeys.get(7); pianokey.release() ;pianokey.draw();break;
    case('y'):case('Y'):pianokey = pianokeys.get(8); pianokey.release() ;pianokey.draw();break;
    case('h'):case('H'):pianokey = pianokeys.get(9); pianokey.release() ;pianokey.draw();break;
    case('u'):case('U'):pianokey = pianokeys.get(10); pianokey.release() ;pianokey.draw();break;
    case('j'):case('J'):pianokey = pianokeys.get(11); pianokey.release() ;pianokey.draw();break;
    case('k'):case('K'):pianokey = pianokeys.get(12); pianokey.release() ;pianokey.draw();break;
    case('o'):case('O'):pianokey = pianokeys.get(13); pianokey.release() ;pianokey.draw();break;
    case('l'):case('L'):pianokey = pianokeys.get(14); pianokey.release() ;pianokey.draw();break;
    
    case('m'):case('M'):toggleFullscreen();break;
  }
}
