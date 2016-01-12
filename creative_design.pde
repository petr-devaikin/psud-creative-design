
String inputFile = "capoeira.txt"; // leave "" for live input, put filename to play recorded data
float lastMillis = 0;

float FREQUENCY = 60;

Manipulator manipulator = new Manipulator();

// ------ agents ------
Agent[] agents = new Agent[10000]; // create more ... to fit max slider agentsCount
int agentsCount = 4000;
float noiseScaleDefault = 300, noiseStrengthDefault = 10;
float noiseScale, noiseStrength;
float overlayAlpha = 30, agentsAlpha = 190, strokeWidth = 0.3;
int background = 255; 
int drawMode = 1;


void setup(){
  size(1280,800,P2D);
  smooth();
  
  noiseScale = noiseScaleDefault;
  noiseStrength = noiseStrengthDefault;

  for(int i=0; i<agents.length; i++) {
    agents[i] = new Agent();
  }
  
  setupIO();
}


void draw(){
  fill(background, background, background, overlayAlpha);
  noStroke();
  rect(0,0,width,height);

  stroke(0, agentsAlpha);
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
  noiseStrength = noiseStrengthDefault + manipulator.getLegPosition() * 1000 / FREQUENCY / frameRate;
  background = round(255 * (1 - manipulator.getLegPosition()));
}


void keyReleased(){
  exitIO();
  exit();
}

// AND THIS: THIS CODE SLOWLY RETURNS PARAMS TO DEFAULT VALUES
void magniteScale() {
  float d = noiseScale - noiseScaleDefault;
  float power = 0.01 * pow(d, 2) / frameRate;
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