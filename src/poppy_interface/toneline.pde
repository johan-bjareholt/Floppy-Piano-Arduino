class Rect {
  int x, y;
  int w, h;
  boolean enabled = true;
  Rect (int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}

class Toneline{
  int tonenum;
  boolean enabled = false;
  ArrayList<Rect> lines;
  Toneline (int tonenum) {
    this.tonenum = tonenum;
    this.lines = new ArrayList<Rect>();
  }
  
  void draw() {
    stroke(200,200,200);
    fill(255,255,255);
    for (int linenum=0; linenum<lines.size(); linenum++){
      Rect line = this.lines.get(linenum);
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
      lines.add(new Rect(x, window_y-125, 5, 5));
      this.enabled = true;
    }
  }
  void disable(){
    lines.get(lines.size()-1).enabled = false;
    this.enabled = false;
  }
}
