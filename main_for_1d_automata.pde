//boolean paused;
//final int scale = 1;
//final int traffic = 184;
//final int universal = 110;
//final int XOR = 90;
//int RULE = universal;
//int CAsize;
//int gridSeed = 0;
//OneDBinaryAutomata cells;
//IntegerColorMap cmap = new BinaryColorMap();
//PFont font;

//void setup() {
//  //size(1202, 600);
//  fullScreen(2);
//  CAsize = ((width-2)/2)/scale;
//  rerandomise();
//  font = createFont("Courier New Bold", 14);
//  textFont(font);
//}

//void rerandomise(){
//  gridSeed++;
//  cells = new OneDBinaryAutomata(width/scale, height/scale, true, 0);
//  cells.binaryRandomise(0.4,gridSeed);
//  paused = false;
//}

//void draw() {
//  cells.show(0,0,scale,cmap,color(100));
//  noStroke();
  
//  fill(HSL(TAU*cells.currentLine/cells.h, 1, 0.5, 1));
//  rect(0, scale*(cells.currentLine + 1), width, scale);
  
//  //fill(255);
//  //textAlign(CENTER);
//  //text("Rule:" + rules, width/4f, height-10);
//  //text("With Wraparound", width*3f/4f, height-10);

//  //saveFrame("frames/InvertedOneSeed########.png");

//  if (!paused) {
//    paused = cells.step(RULE); //pauses when stepping is finished
//  }
//}

//void keyPressed() {
//  if (key == 'p') {
//    paused = !paused;
//  } else if (key == 'n'){
//    RULE++;
//    if (RULE==256){RULE=0;}
//  } else if (key == 'r'){
//    rerandomise();
//  }
//}
