class ToneRect extends Rect {
  boolean enabled = true;
  ToneRect (int x, int y, int w, int h) {
    super(x,y,w,h);
  }
}

class Toneline{
  int tonenum;
  boolean enabled = false;
  ArrayList<ToneRect> lines;
  Toneline (int tonenum) {
    this.tonenum = tonenum;
    this.lines = new ArrayList<ToneRect>();
  }
  
  void draw() {
    stroke(200,200,200);
    fill(255,255,255);
    for (int linenum=0; linenum<lines.size(); linenum++){
      ToneRect line = this.lines.get(linenum);
      rect(line.x,line.y,line.w,line.h);  // Toggle, x, y, w , h
      if (line.enabled == true){
        line.h += 5;
      }
      line.y -= 5;
      if ((line.y+line.h)<0){
        lines.remove(linenum);
        linenum -= 1;
      }
    }
  }
  void enable(){
    if (this.enabled == false){
      int x = pianokeys.get(tonenum).x + (pianokeys.get(tonenum).w/2);
      lines.add(new ToneRect(x, window_y-125, 5, 5));
      this.enabled = true;
    }
  }
  void disable(){
    lines.get(lines.size()-1).enabled = false;
    this.enabled = false;
  }
}
