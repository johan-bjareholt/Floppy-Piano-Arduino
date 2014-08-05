class Pianokey extends Rect{
  int keynum;
  int[] releasedcolor = new int[3];
  int[] pressedcolor = {130,130,130};
  boolean halfkey = false;
  boolean toggled = false;
  
  Pianokey (int keynum, boolean halfkey, int x, int y, int w, int h){
    super(x,y,w,h);
    
    this.keynum = keynum;
    
    // Is it a half note?
    this.halfkey = halfkey;
    if ( halfkey ){
      releasedcolor[0] = 150;
      releasedcolor[1] = 150;
      releasedcolor[2] = 150;
    }
    else {
      releasedcolor[0] = 255;
      releasedcolor[1] = 255;
      releasedcolor[2] = 255;
    }
    //fg color
    setFgColor(200,200,200);
  }

  void draw(){
    stroke(fgcolor[0], fgcolor[1], fgcolor[2]);
    if ( toggled == true ){
      fill(pressedcolor[0], pressedcolor[1], pressedcolor[2]);
    }
    else {
      fill(releasedcolor[0], releasedcolor[1], releasedcolor[2]);
    }
    rect(x,y,w,h);
    if (halfkey == false && keynum>0 && keynum<12*octaves){
      Pianokey pianokey = pianokeys.get(keynum-1);
      pianokey.draw();
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
