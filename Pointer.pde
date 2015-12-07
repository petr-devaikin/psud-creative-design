int TRACK_LENGTH = 100; // ms

class Pointer {
  ArrayList<Point> track;
  float currentX = 0;
  float currentY = 0;
  color currentColor = color(255);
  
  Pointer() {
    track = new ArrayList<Point>();
  }
  
  void change(float ax, float ay, float az, float gx, float gy, float gz) {
    currentX += az * 3600 / FREQUENCY / frameRate;
    currentY += -ax * 3600 / FREQUENCY / frameRate;
    
    currentColor = color(100 + 100 * gz, 100 + 100 * gy, 100 + 100 * gz);
  }
  
  void draw() {
    magnite();
    
    if (track.size() > TRACK_LENGTH)
      track.remove(0);
      
    track.add(new Point(currentX, currentY, currentColor));
    
    //beginShape();
    for (int i = 1; i < track.size(); i++) {
      Point p1 = track.get(i-1);
      Point p2 = track.get(i);
      stroke(p2.c, 255.0 * i / track.size());
      strokeWeight(10.0 * i / track.size());
      line(p1.x, p1.y, p2.x, p2.y);
      //vertex(p1.x, p1.y);
    }
    //endShape();
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