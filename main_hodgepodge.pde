//HodgepodgeMachine cells;
//final int scale = 1;
//IntegerColorMap cmap;
//boolean paused = true;
//final float noisedx = 0.01;
//final float noisedy = 0.01;

//final int N = 200;
//int k1 = 3;//1, 5, 1, 3,
//int k2 = 5;//1, 1, 5, 5,
//int g = 27;//30,47,28,27,

//void setup(){
//  //size(500,500);
//  fullScreen();
//  cells = new HodgepodgeMachine(width/scale,height/scale,true,N);
//  //cells.randomise();
//  cells.evenNoise(N,noisedx,noisedy);
//  //cells.binaryRandomise(0.1);
  
//  //redblue = new LerpRGBMap(N,color(200,20,0),color(50,100,200));
//  cmap = new GradientFromFile("misc/nipy_spectral",N);
//}

//void draw(){
//  cells.show(0,0,scale,cmap,color(0));
//  if(!paused){cells.step(k1,k2,g);}
//}

//void randomRule(){
//  k1 = (int)random(5) + 1;
//  k2 = (int)random(5) + 1;
//   g = (int)random(10) + 25;
//  println(k1,k2,g);
//}

//void keyPressed(){
//  if(key=='r'){
//    randomRule();
//  } else if (key=='g'){
//    cells.randomise();
//  } else if (key=='o'){
//    cells.clear();
//    cells.editState(1,width/scale/2,height/scale/2);
//  } else if (key=='p'){
//    paused = !paused;
//  } else if (key=='n'){
//    cells.evenNoise(N,noisedx,noisedy);
//  }
//}
