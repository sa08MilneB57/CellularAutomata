boolean record = false;
boolean paused = false;

final int maxColors = 360;
int currentColor = 1;
final int scale = 1;
final RainbowAndBlackMap cmap = new RainbowAndBlackMap(maxColors);

float noiseDx = 0.005*scale;
float noiseDy = 0.005*scale;
float noiseMu = 1;

FallingSand cells;

void setup(){
  size(600,600);
  //fullScreen();
  cells = new FallingSand(width/scale,height/scale,false);
  singleSeed();
  //randomGrid();
  //frameRate(4);
  
}

void draw(){
  cells.show(0,0,scale,cmap,color(100));
  if(mousePressed){
    if(mouseX>=0 && mouseX<width && mouseY>=0 && mouseY < width){
      if (scale==1){
        for(int i=0; i<36; i++){
          int x = constrain(mouseX + (int)(5*randomGaussian()),0,width-1);
          int y = constrain(mouseY + (int)(5*randomGaussian()),0,height-1);
          cells.setState(currentColor,x,y);
        }
      } else {
        cells.setState(currentColor,mouseX/scale,mouseY/scale);
      }
    }
    currentColor += 1;
    currentColor = currentColor % (maxColors+1);
    if(currentColor==0){currentColor = 1;}
  }
  if(!paused){
    cells.step();
    //if(record){saveFrame("frames2DTotallistic" + ((mooreMode)?"Moore":"VonNeumann") + ((stateDependent)?"StateDependent":"StateIndependent") + "Rule" + rule + "/frame##########.png");}
  }
}

void randomGrid(){
  cells.evenRandomise(maxColors+1);
}

void singleSeed(){
  cells.clear();
  cells.editState(1,width/scale/2,height/scale/2);
}

void keyPressed(){
  if (key=='g'){
    randomGrid();
  } else if (key=='o'){
    singleSeed();
  } else if (key=='p'){
    paused = !paused;
  } else if (key=='n'){
    cells.zeroOrEvenNoise(0.5,maxColors,noiseDx,noiseDy);
  } 
}
