class Pianokey {
  int keynum;
  int x, y;
  int w, h;
  int[] bgcolor = new int[3];
  int[] togglecolor = new int[3];
  int[] fgcolor = new int[3];
  boolean halfkey = false;
  boolean toggled = false;
  
  Pianokey (int keynum){
    this.keynum = keynum;
    w = window_x/(7*octaves);
    h = 125;
    
    int scalekeynum = keynum%12;
    
    int octavestart = w*(keynum/12)*7;
    int scalex = w*(keynum%12)/2;
    if (scalekeynum > 4){ scalex += w/2; }
    
    x = octavestart + scalex;
    y = window_y-h;
    
    // Is it a half note?
    if ( scalekeynum == 1 || scalekeynum == 3 ||
         scalekeynum == 6 || scalekeynum == 8 ||
         scalekeynum == 10 ){
      halfkey = true;
           
      h = 75;
      
      x += w/4;
      w /= 2;
      
      //  Colors
      //bg color
      bgcolor[0] = 150;
      bgcolor[1] = 150;
      bgcolor[2] = 150;
      //toggle bg color
      togglecolor[0] = 100;
      togglecolor[1] = 100;
      togglecolor[2] = 100;
      //fg color
      fgcolor[0] = 200;
      fgcolor[1] = 200;
      fgcolor[2] = 200;
    }
    else {
      // Colors
      //bg color
      bgcolor[0] = 255;
      bgcolor[1] = 255;
      bgcolor[2] = 255;
      //toggle bg color
      togglecolor[0] = 150;
      togglecolor[1] = 150;
      togglecolor[2] = 150;
      //fg color
      fgcolor[0] = 200;
      fgcolor[1] = 200;
      fgcolor[2] = 200;
    }
  }

  void draw(){
    stroke(fgcolor[0], fgcolor[1], fgcolor[2]);
    if ( toggled == true ){
      fill(togglecolor[0], togglecolor[1], togglecolor[2]);
    }
    else {
      fill(bgcolor[0], bgcolor[1], bgcolor[2]);
    }
    rect(x,y,w,h);
    if (halfkey == false && keynum>0 && keynum<12*octaves){
      Pianokey pianokey = pianokeys.get(keynum-1);
      pianokey.draw();
    }
    // Tone spacing lines
    stroke(120); // Line color
    int x;
    int y = window_y-125;
    switch(keynum%12){
      case(0):
      x = this.x;
      line(x, 0, x, y);
      break;
      case(1):
      x = this.x;
      line(x, 0, x, y);
      x = this.x+this.w;
      line(x, 0, x, y);
      break;
      case(2):
      break;
      case(3):
      x = this.x;
      line(x, 0, x, y);
      x = this.x+this.w;
      line(x, 0, x, y);
      break;
      case(4):
      break;
      case(5):
      x = this.x;
      line(x, 0, x, y);
      break;
      case(6):
      x = this.x;
      line(x, 0, x, y);
      x = this.x+this.w;
      line(x, 0, x, y);
      break;
      case(7):
      break;
      case(8):
      x = this.x;
      line(x, 0, x, y);
      x = this.x+this.w;
      line(x, 0, x, y);
      break;
      case(9):
      break;
      case(10):
      x = this.x;
      line(x, 0, x, y);
      x = this.x+this.w;
      line(x, 0, x, y);
      break;
      case(11):
      break;
    }
  }
  void press(){
    toggled = true;
    tonelines.get(this.keynum).enable();
  }
  void release(){
    toggled = false;
    tonelines.get(this.keynum).disable();
  } 
}
