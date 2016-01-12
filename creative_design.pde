import processing.video.*;

String inputFile = "capoeira.txt"; // leave "" for live input, put filename to play recorded data
float lastMillis = 0;

Movie myMovie;

float FREQUENCY = 60;

Manipulator manipulator = new Manipulator();

// ------ agents ------
Agent[] agents = new Agent[10000]; // create more ... to fit max slider agentsCount
int agentsCount = 10000;
float noiseScaleDefault = 300, noiseStrengthDefault = 10;
float noiseScale, noiseStrength;
float overlayAlpha = 20, agentsAlpha = 200, strokeWidth = 0.3;
int drawMode = 2;

float legRaise = 0;
float legPosition = 0;


void setup(){
  size(1069,786,P2D);
  colorMode(HSB, 255);
  smooth();
  
  //myMovie = new Movie(this, "example.mp4");
  myMovie = new Movie(this, "capoeira.mov");
  myMovie.loop();
  myMovie.speed(3);
  myMovie.volume(0);
  
  noiseScale = noiseScaleDefault;
  noiseStrength = noiseStrengthDefault;

  for(int i=0; i<agents.length; i++) {
    agents[i] = new Agent();
  }
  
  setupIO();
}

void movieEvent(Movie m) {
  m.read();
}


void draw(){
  //fill(255, 255, 255);
  //noStroke();
  //rect(0,0,width,height);
  
  tint(255, overlayAlpha);
  image(myMovie, 0, 0, width, height);

  stroke(100 + 50 * legPosition, 70, 180 + 55 * legRaise, agentsAlpha);
  //draw agents
  if (drawMode == 1) {
    for(int i=0; i<agentsCount; i++) agents[i].update1();
  } 
  else {
    for(int i=0; i<agentsCount; i++) agents[i].update2();
  }
  
  if (inputFile != "") {
    int time = millis();
    for (float i = lastMillis; i < time - lastMillis; i += 1000 / FREQUENCY) {
      readLine();
      lastMillis = i;
    }
  }
  
  magniteScale();
  //magniteStrength();
}

void updateSettings() {
  // WE CAN PLAY WITH THIS PARAMS
  noiseScale += manipulator.getLegBringing() * 2000 / FREQUENCY / frameRate;
  noiseStrength = noiseStrengthDefault + manipulator.getLegPosition() * 10000 / FREQUENCY / frameRate;
  legRaise = (1 - manipulator.getLegPosition());
  legPosition = manipulator.getLegBringing(); 
}


void keyReleased(){
  exitIO();
  exit();
}

// AND THIS: THIS CODE SLOWLY RETURNS PARAMS TO DEFAULT VALUES
void magniteScale() {
  float d = noiseScale - noiseScaleDefault;
  float power = 0.001 * pow(d, 2) / frameRate;
  if (power > 0)
    noiseScale -= power * d / abs(d);
}

/*
void magniteStrength() {
  float d = noiseStrength - noiseStrengthDefault;
  float power = 0.01 * pow(d, 2) / frameRate;
  if (power > 0)
    noiseStrength -= power * d / abs(d);
}
*/