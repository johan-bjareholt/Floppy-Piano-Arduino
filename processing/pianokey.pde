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
    if (halfkey == false && keynum>0){
      Pianokey pianokey = pianokeys.get(keynum-1);
      pianokey.draw();
    }
  }
  void press(){
    toggled = true;
  }
  void release(){
    toggled = false;
  } 
}
