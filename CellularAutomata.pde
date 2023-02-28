
//10000steps = 2.8min at 60steps per second
PImage img;
int SCALE = 2;
int stepsPerFrame = 5;
boolean mooreMode = false;
Sandpile sandpile;
IntegerColorMap sandmap;


void setup(){
  //size(1920,1080);
  size(1024,1024);
  //sandmap = new SandpileColorMap();
  sandmap = new LerpYCoCgMap((mooreMode)?8:4,color(20,0,0),color(255,255,100),color(255));
  //fullScreen();
  sandpile = new Sandpile(width/SCALE,height/SCALE,false);
  sandpile.setCenter( ( (mooreMode)?2:1 ) * width*height / (SCALE*SCALE));
  background(0);

  sandpile.show(0,0,SCALE,sandmap,null);

}

void draw(){
  background(0);
  sandpile.show(0,0,SCALE,sandmap,null);
  for(int i=0;i<stepsPerFrame;i++){
    sandpile.step(mooreMode);
  }
  saveFrame("C:\\sandFrames(Sandy)\\frame#######.png");
  if(frameCount > 55100){exit();}
}
