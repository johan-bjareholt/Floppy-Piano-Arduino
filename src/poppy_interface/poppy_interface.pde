import ddf.minim.* ;
import ddf.minim.signals.* ;
import ddf.minim.effects.* ;

// Sound variables
Minim minim;
AudioOutput au_out ;
SquareWave sqw ;
LowPassSP lpass ;



// C        C#        D      D#        E        F        F#      G        G#        A        A#      B              
float tones[] = {
130.81,   138.59,  146.83,  155.56,  164.81,  174.61,  185.00,  196.00,  207.65,  220.00,  233.08, 246.94,
261.63,   277.18,  293.66,  311.13,  329.63,  349.23,  369.99,  392.00,  415.30,  440.00,  466.16, 493.88,
523.25,   554.37,  587.33,  622.25,  659.25,  698.46,  739.99,  783.99,  830.61,  880.00,  932.33, 987.77,
1046.50,  1108.73, 1174.66, 1244.51, 1318.51, 1396.91, 1479.98, 1567.98, 1661.22, 1760.00, 1864.66, 1975.53,  
2093.00,  2217.46, 2349.32, 2489.02, 2637.02, 2793.83, 2959.96, 3135.96, 3322.44, 3520.00, 3729.31, 3951.07
};














// Window size
int window_x = 1280;
int window_y = 720;

// Serial enabled
boolean serial_on = true;

// Button amount
int octaves = 3;
ArrayList<Pianokey> pianokeys;
ArrayList<Toneline> tonelines;

// Keyboard setup
import processing.serial.*;
Serial serial;

void setup(){
  // Sets screen resolution
  size(window_x,window_y);
  //frame.setResizable(true);
  tonelines = new ArrayList<Toneline>();
  pianokeys = new ArrayList<Pianokey>();
  // Initialize pianokeys and tonelines
  for (int keynum=0; keynum<octaves*12; keynum++){
    pianokeys.add(new Pianokey(keynum));
    tonelines.add(new Toneline(keynum));
  }
  /*
    Setial setup
  */
  println("Available serial ports:");
  println(Serial.list());
  if (serial_on){
    serial = new Serial(this, Serial.list()[0], 9600);
  }
  /*
    Sound initialization
  */
  minim = new Minim(this) ;
  au_out = minim.getLineOut() ;
  // create a SquareWave with a frequency of 440 Hz,
  // an amplitude of 1 and the same sample rate as out
  sqw = new SquareWave(440, 1, 44100);
  au_out.mute();
  // create a LowPassSP filter with a cutoff frequency of 200 Hz
  // that expects audio with the same sample rate as out
  lpass = new LowPassSP(200, 44100);
  // now we can attach the square wave and the filter to our output
  au_out.addSignal(sqw);
  au_out.addEffect(lpass);
}

void draw(){
  /*
    Base draw
  */
  rectMode(CORNER);
  background(40);
  // Piano key size
  int pianokey_w = window_x/(7*octaves);
  int pianokey_h = 100;
  // Draw pianokeys
  for (int keynum=0; keynum<pianokeys.size(); keynum++){
    Pianokey pianokey = pianokeys.get(keynum);
    pianokey.draw();
  }
  // Draw tonelines
  for (int tonenum=0; tonenum<tonelines.size(); tonenum++){
    Toneline toneline = tonelines.get(tonenum);
    toneline.draw();
  }
  
  /*
     Serial read
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
      else if (serialValue >= 12*octaves && serialValue < 2*(12*octaves)) {
        int tone = serialValue-(12*octaves);
        println("Tone " + tone + "was released");
        Pianokey pianokey = pianokeys.get(serialValue-(12*octaves));
        pianokey.release();
        pianokey.draw();
      }
    }
  }
  
  // Play note
  boolean musicOn = false;
  for (int keynum = 0; keynum<pianokeys.size(); keynum++){
    Pianokey pianokey = pianokeys.get(keynum);
    if (pianokey.toggled){
      sqw.setFreq(tones[keynum]);
      musicOn = true;
    }
  }
  if (musicOn) { au_out.unmute(); }
  else { au_out.mute(); }

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
  }
}
