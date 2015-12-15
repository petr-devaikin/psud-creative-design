int TRACK_LENGTH = 100; // ms
float SPEED = 5000;

class Pointer {
  ArrayList<Point> track;
  float currentX = 0;
  float currentY = 0;
  color currentColor = color(255);
  
  Pointer() {
    track = new ArrayList<Point>();
  }
  
  void change(Manipulator m) {
    currentY += m.getLegSpin() * SPEED / FREQUENCY / frameRate;
    currentX += m.getLegBringing() * SPEED / FREQUENCY / frameRate;
    
    currentColor = color(150 + 200 * m.getLegPosition(), 100, 100);
  }
  
  void draw() {
    magnite();
    
    if (track.size() > TRACK_LENGTH)
      track.remove(0);
      
    track.add(new Point(currentX, currentY, currentColor));
    
    for (int i = 1; i < track.size(); i++) {
      Point p1 = track.get(i-1);
      Point p2 = track.get(i);
      stroke(p1.c, 255.0 * i / track.size());
      strokeWeight(10.0 * i / track.size());
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }
  
  void magnite() {
    float d = dist(0, 0, currentX, currentY);
    float power = 0.01 * pow(d, 2) / frameRate;
    if (power > 0) {
      currentX -= power * currentX / d;
      currentY -= power * currentY / d;
    }
  }
}