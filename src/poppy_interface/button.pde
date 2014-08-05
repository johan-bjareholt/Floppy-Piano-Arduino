class Rect {
  int x, y;
  int w, h;
  int[] bgcolor = new int[3];
  int[] fgcolor = new int[3];
  
  Rect(int x,int y,int w,int h){
    this.x = x;
    this.y = y;
    
    this.w = w;
    this.h = h;
    
    this.setBgColor(255,255,255);
    this.setFgColor(200,200,200);
  }

  void draw(){
    stroke(fgcolor[0], fgcolor[1], fgcolor[2]);
    fill(bgcolor[0], bgcolor[1], bgcolor[2]);
    rect(x,y,w,h);
  }

  boolean pointcollide(int x, int y){
    if (x <= this.x+this.w && x >= this.x &&
        y <= this.y+this.h && y >= this.y){
          return true;
        }
    else {
      return false;
    }
  }

  void setBgColor(int r, int g, int b){
    this.bgcolor[0] = r;
    this.bgcolor[1] = g;
    this.bgcolor[2] = b;
  }

  void setFgColor(int r, int g, int b){
    this.fgcolor[0] = r;
    this.fgcolor[1] = g;
    this.fgcolor[2] = b;
  }
}

class Button extends Rect {
  String btntext;
  int textsize;
  Button(String text , int x, int y, int w, int h){
    super(x,y,w,h);
    this.btntext = text;
    textsize = h-6;
  }
  
  void draw() {
    super.draw();
    textSize(textsize);
    fill(fgcolor[0], fgcolor[1], fgcolor[2]);
    text(btntext, x+5, y+textsize);
  }
  
  boolean clicked(){
    return pointcollide(mouseX, mouseY);
  }
}

class SerialButton extends Button {

  SerialButton(String text , int x, int y, int w, int h){
    super(text,x,y,w,h);
  }
  
  boolean clicked(){
    if (super.clicked()){
      if (!serial_on){
        initialize_serial();
      }
      update_status();
      return true;
    }
    return false;
  }
  
  void update_status(){
    if (serial_on){
      btntext = "Serial: off";
      setBgColor(255,50,50);
    }
    else {
      btntext = "Serial: on";
      setBgColor(50,255,50);
    }
  }
}

class SoundButton extends Button {
  SoundButton(String text, int x, int y, int w, int h){
    super(text,x,y,w,h);
  }
  
  boolean clicked(){
    if (super.clicked()){
      sound_on = !sound_on;
      update_status();
      return true;
    }
    return false;
  }
  
  void update_status(){
    if (!sound_on){
      btntext = "Sound: off";
      setBgColor(255,50,50);
    }
    else {
      btntext = "Sound: on";
      setBgColor(50,255,50);
    }
  }
}
