boolean recording = false;
boolean paused = false;

LightningAutomata cells;
final int scale = 1;
IntegerColorMap cmap;

void setup(){
  //randomSeed(95834338);
  //noiseSeed(65434562);
  fullScreen();
  //frameRate(4);
  //size(500,500);
  cells = new LightningAutomata(width/scale,height/scale);
  cells.seedLightning(0.0001,false);
  //cells.editState(1,width/2/scale,height/2/scale);
  //cells.balancedRandomise(0.001);
  //cells.binaryRandomise(0.00005);
}

void draw(){
  //cmap = new AbsoluteValueWrapper(new LerpYCoCgMap(cells.maxFeeder,color(0,0,1),color(255,255,80)));
  cmap = new RedBlueMap(cells.maxFeeder);
  //cmap = new GradientFromFile("uniform/plasma",cells.maxFeeder);
  //cmap = new AlphaIgnoreWrapper(new NullColorMap());
  
  cells.show(0,0,scale,cmap,color(255));
  
  image(cells.permittivityImage,0,0,width,height);
  //image(cells.electricFieldImage,0,0,width,height);
   if (!paused){
    if (random(1f) < 0.1){
      cells.step(false,0.01,2)  ;
    } else {
      cells.step(true,0.2,2);
    }
    
    
    //for (int j=0; j<cells.h; j++){
    //  for (int i=0; i<cells.w; i++){
    //    print(cells.getState(i,j),",");
    //  }
    //  print("\n");
    //}
    
    if(recording){saveFrame("LightningAutomataFrames/frame#######.png");}
   }
}

void keyPressed(){
  if (key=='p'){paused = !paused;}
}
