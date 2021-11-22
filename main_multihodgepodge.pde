//HodgepodgeMachine cellsR,cellsG;//,cellsB;
//final int N = 200;
//final int scale = 1;
//IntegerColorMap emptyRed,emptyGreen;//,emptyBlue;


//int k1 = 3;// 5,
//int k2 = 3;// 1,
//int g = 28;//47,

//void setup(){
//  size(800,608);
//  //fullScreen();
//  cellsR = new HodgepodgeMachine(width/scale,height/scale,true,N);
//  cellsR.randomise();
//  cellsG = new HodgepodgeMachine(width/scale,height/scale,true,N);
//  cellsG.randomise();
//  //cellsB = new HodgepodgeMachine(width/scale,height/scale,true,N);
//  //cellsB.randomise();
//  //cells.binaryRandomise(0.1);
  
//  emptyRed   = new LerpHSLMap(N,color(0,200,200,50),color(200,0,0));
//  emptyGreen = new LerpHSLMap(N,color(0,200,0,50),color(200,0,200));
//  //emptyBlue  = new LerpRGBMap(N,color(0,0,0,0),color(0,0,200));
  
//  blendMode(ADD);
//}

//void draw(){
//  clear();
//  cellsR.show(0,0,scale,emptyRed,color(0));
//  cellsR.step(k1,k2,g);
//  cellsG.show(0,0,scale,emptyGreen,color(0));
//  cellsG.step(k1,k2,g);
//  //cellsB.show(0,0,scale,emptyBlue,color(0));
//  //cellsB.step(k1,k2,g);
  
//  //saveFrame("hodgepodge/frames#######.png");
//}

//void randomRule(){
//  k1 = (int)random(10) + 1;
//  k2 = (int)random(10) + 1;
//   g = (int)random(50) + 1;
//  println(k1,k2,g);
//}

//void keyPressed(){
//  if(key=='r'){
//    randomRule();
//  } else if (key=='g'){
//    cellsR.randomise();
//    cellsG.randomise();
//    //cellsB.randomise();
//  }
//}
