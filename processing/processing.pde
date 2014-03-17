int window_x = 1280;
int window_y = 720;

int octaves = 3;

ArrayList<Pianokey> pianokeys;

void setup(){
  // Sets screen resolution
  size(window_x,window_y);
  pianokeys = new ArrayList<Pianokey>();
  for (int keynum=0; keynum<octaves*12; keynum++){
    pianokeys.add(new Pianokey(keynum));
  }
}

void draw(){
  background(40);    // Setting the background
  
  int pianokey_w = window_x/(7*octaves);
  int pianokey_h = 100;
  
  int toneline_spacing = window_x/(12*octaves);
  stroke(120);
  for (int linenum=0; linenum<(12*octaves); linenum++){
    line(linenum*toneline_spacing, 0, linenum*toneline_spacing, window_y);
  }
  
  
  rectMode(CORNER);
  
  for (int keynum=0; keynum<pianokeys.size(); keynum++){
    Pianokey pianokey = pianokeys.get(keynum);
    pianokey.draw();
  }
}

void keyPressed(){
  Pianokey pianokey;
  switch(key) {
    case('a'):case('A'):pianokey = pianokeys.get(0); pianokey.press() ;break;
    case('w'):case('W'):pianokey = pianokeys.get(1); pianokey.press() ;break;
    case('s'):case('S'):pianokey = pianokeys.get(2); pianokey.press() ;break;
    case('e'):case('E'):pianokey = pianokeys.get(3); pianokey.press() ;break;
    case('d'):case('D'):pianokey = pianokeys.get(4); pianokey.press() ;break;
    case('f'):case('F'):pianokey = pianokeys.get(5); pianokey.press() ;break;
    case('t'):case('T'):pianokey = pianokeys.get(6); pianokey.press() ;break;
    case('g'):case('G'):pianokey = pianokeys.get(7); pianokey.press() ;break;
    case('y'):case('Y'):pianokey = pianokeys.get(8); pianokey.press() ;break;
    case('h'):case('H'):pianokey = pianokeys.get(9); pianokey.press() ;break;
    case('u'):case('U'):pianokey = pianokeys.get(10); pianokey.press() ;break;
    case('j'):case('J'):pianokey = pianokeys.get(11); pianokey.press() ;break;
    case('k'):case('K'):pianokey = pianokeys.get(12); pianokey.press() ;break;
    case('o'):case('O'):pianokey = pianokeys.get(13); pianokey.press() ;break;
    case('l'):case('L'):pianokey = pianokeys.get(14); pianokey.press() ;break;
  }
}
 
void keyReleased(){
  Pianokey pianokey;
  switch(key) {
    case('a'):case('A'):pianokey = pianokeys.get(0); pianokey.release() ;break;
    case('w'):case('W'):pianokey = pianokeys.get(1); pianokey.release() ;break;
    case('s'):case('S'):pianokey = pianokeys.get(2); pianokey.release() ;break;
    case('e'):case('E'):pianokey = pianokeys.get(3); pianokey.release() ;break;
    case('d'):case('D'):pianokey = pianokeys.get(4); pianokey.release() ;break;
    case('f'):case('F'):pianokey = pianokeys.get(5); pianokey.release() ;break;
    case('t'):case('T'):pianokey = pianokeys.get(6); pianokey.release() ;break;
    case('g'):case('G'):pianokey = pianokeys.get(7); pianokey.release() ;break;
    case('y'):case('Y'):pianokey = pianokeys.get(8); pianokey.release() ;break;
    case('h'):case('H'):pianokey = pianokeys.get(9); pianokey.release() ;break;
    case('u'):case('U'):pianokey = pianokeys.get(10); pianokey.release() ;break;
    case('j'):case('J'):pianokey = pianokeys.get(11); pianokey.release() ;break;
    case('k'):case('K'):pianokey = pianokeys.get(12); pianokey.release() ;break;
    case('o'):case('O'):pianokey = pianokeys.get(13); pianokey.release() ;break;
    case('l'):case('L'):pianokey = pianokeys.get(14); pianokey.release() ;break;
  }
}

