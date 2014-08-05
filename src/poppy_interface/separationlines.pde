void draw_separationlines(){
  for (int keynum=0; keynum<pianokeys.size(); keynum++){
    // Tone spacing lines
    Pianokey pianokey = pianokeys.get(keynum);
    stroke(120); // Line color
    int x;
    int y = window_y-125;
    switch(keynum%12){
      case(0):
      x = pianokey.x;
      line(x, 0, x, y);
      break;
      case(1):
      x = pianokey.x;
      line(x, 0, x, y);
      x = pianokey.x+pianokey.w;
      line(x, 0, x, y);
      break;
      case(2):
      break;
      case(3):
      x = pianokey.x;
      line(x, 0, x, y);
      x = pianokey.x+pianokey.w;
      line(x, 0, x, y);
      break;
      case(4):
      break;
      case(5):
      x = pianokey.x;
      line(x, 0, x, y);
      break;
      case(6):
      x = pianokey.x;
      line(x, 0, x, y);
      x = pianokey.x+pianokey.w;
      line(x, 0, x, y);
      break;
      case(7):
      break;
      case(8):
      x = pianokey.x;
      line(x, 0, x, y);
      x = pianokey.x+pianokey.w;
      line(x, 0, x, y);
      break;
      case(9):
      break;
      case(10):
      x = pianokey.x;
      line(x, 0, x, y);
      x = pianokey.x+pianokey.w;
      line(x, 0, x, y);
      break;
      case(11):
      break;
    }
  }
}
