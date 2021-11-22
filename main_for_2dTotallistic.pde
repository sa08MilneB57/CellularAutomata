//boolean record = false;
//boolean paused = false;

//final int scale = 1;
//final IntegerColorMap cmap = new BinaryColorMap();
//final int gameOfLife = 0b000001100;
//final int caveRule = 0b111111111000000000; //Moore State Dependent (around 50:50)
//final int mouldy = 244783; //Moore State Dependent (around 50:50)
//final int petrieDish  = 45282;//Moore State Dependent (small seed of live cells)
//final int orthoStripes = 481;//VonNeumann State Dependent
//final int toothpicks   = 686;//VonNeumann State Dependent
//final int starsGoingOut = 242321;//Moore State Dependent (very small seed of live cells)
//final int checkers = 4;//Von Neumann State Dependent

//int               rule = caveRule;
//boolean stateDependent = true;
//boolean      mooreMode = true;

//float noiseDx = 0.005*scale;
//float noiseDy = 0.005*scale;
//float noiseMu = 1;

//TwoDTotallistic cells;

//void setup(){
//  //size(600,600);
//  fullScreen();
//  cells = new TwoDTotallistic(width/scale,height/scale,true);
//  cells.binaryNoise(noiseMu,noiseDx,noiseDy);
//  //randomGrid();
//  frameRate(4);
  
//}

//void draw(){
//  cells.show(0,0,scale,cmap,color(100));
//  if(!paused){
//    if(mooreMode){
//      cells.stepMoore(rule,stateDependent);
//    } else {
//      cells.stepVonNeumann(rule,stateDependent);
//    }
//    if(record){saveFrame("frames2DTotallistic" + ((mooreMode)?"Moore":"VonNeumann") + ((stateDependent)?"StateDependent":"StateIndependent") + "Rule" + rule + "/frame##########.png");}
//  }
//}

//void randomGrid(){
//  cells.binaryRandomise(0.5f);
//}
//void randomRule(){
//  int maxrule = 1 << (((mooreMode)?9:5)*((stateDependent)?2:1));
//  rule = (int)random(maxrule);
//  println("Rule: ",rule);
//}

//void singleSeed(){
//  cells.clear();
//  cells.editState(1,width/scale/2,height/scale/2);
//}

//void keyPressed(){
//  if(key=='r'){
//    randomRule();
//  } else if (key=='g'){
//    randomGrid();
//  } else if (key=='o'){
//    singleSeed();
//  } else if (key=='p'){
//    paused = !paused;
//  } else if (key=='n'){
//    cells.binaryNoise(noiseMu,noiseDx,noiseDy);
//  } 
//}
