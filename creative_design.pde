// INSTALL SignalFilter LIBRARY BEFORE START!!!

import signal.library.*;

SignalFilter radiusFilter;

String inputFile = "capoeira.txt"; // leave "" for live input, put filename to play recorded data
float lastMillis = 0;

float FREQUENCY = 60;

Manipulator manipulator = new Manipulator();

float angel = 0;
float radius = 10;
float weight = 1;

FloatList x = new FloatList();
FloatList y = new FloatList();

boolean changed = false;

float hue;
float brightness = 255;


void setup(){
  size(600,600,P2D);
  colorMode(HSB, 255);
  smooth();
  
  setupIO();
  clearCanvas();
  
  radiusFilter = new SignalFilter(this);
  radiusFilter.setMinCutoff(2);
  radiusFilter.setFrequency(FREQUENCY);
}

void clearCanvas() {
  fill(0, 0, 0);
  noStroke();
  rect(0,0,width,height);
  hue = 0;
  x = new FloatList();
  y = new FloatList();
  angel = 0;
  
  strokeCap(SQUARE);
}

void draw(){
  
  //tint(255, overlayAlpha);
  //image(myMovie, 0, 0, width, height);
  if (changed) {
    stroke(hue, 255, 255, brightness);
    strokeWeight(weight);
    noFill();
    
    float newX = width / 2 - radius * sin(angel);
    float newY = height / 2 + radius * cos(angel);
    
    x.append(newX);
    y.append(newY);
    
    if (x.size() > 4) {
      x.remove(0);
      y.remove(0);
    }
    
    beginShape();
    if (x.size() == 4) {
      //curveVertex(x.get(0), y.get(0));
      for (int i = 0; i < 4; i++)
        curveVertex(x.get(i), y.get(i));
      //curveVertex(x.get(3), y.get(3));
      //line(x[0], y[0], x[1], y[1]);
    }
    endShape();
    
    changed = false;
  }
  
  if (inputFile != "") {
    int time = millis();
    for (float i = lastMillis; i < time - lastMillis; i += 1000 / FREQUENCY) {
      readLine();
      lastMillis = i;
    }
  }
}

void updateSettings() {
  // WE CAN PLAY WITH THIS PARAMS
  
  angel += 2 * manipulator.getLegSpin() / FREQUENCY;
  if (angel < 0)
    angel += 2 * PI;
  else if (angel >= 2 * PI)
    angel -= 2 * PI;
    
  hue += 180 / PI / 3 * manipulator.getAuSpin() / FREQUENCY;
  if (hue < 0)
    hue += 256;
  if (hue > 255)
    hue -= 256;
    
  float v = radiusFilter.filterUnitFloat(manipulator.getLegPosition());
  if (v != 0) {
    radius = sqrt(v) * (min(width, height) / 2 - 10);
    brightness = 255 * sqrt(v);
    weight = 1 + 3 * sqrt(v);
  }
  
  changed = true;
}


void keyReleased(){
  saveImage();
  if (keyCode == BACKSPACE) {
    clearCanvas();
  }
  else {
    exitIO();
    exit();
  }
}

void saveImage() {
  saveFrame("p_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+".png");
}