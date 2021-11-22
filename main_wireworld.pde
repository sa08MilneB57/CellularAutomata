//WireWorldAutomata wires;
//final int scale = 10;
//IntegerColorMap cmap = new WireWorldColorMap();
//boolean running = false;
//boolean waitingForMouseUp = false;
//int paintState = 3;

//void setup(){
//  size(600,600);
//  //fullScreen();
//  wires = new WireWorldAutomata(width/scale,height/scale);
//  frameRate(10);
//}

//void draw(){
//  wires.show(0,0,scale,cmap);
//  if(running){
//    wires.step();
//  } else {
//    editor();
//  }
//}

//boolean mouseInWindow(){
//  return (mouseX > 0 && mouseY > 0 && mouseX < width && mouseY < height);
//}

//void editor(){
//  if(mousePressed && mouseInWindow()){
//    int cellX = (int)mouseX/scale;
//    int cellY = (int)mouseY/scale;
//    wires.editState(paintState,cellX,cellY);
//    waitingForMouseUp = true;
//  }
//}

//void keyPressed(){
//  if (Character.isDigit(key)){
//    int num = key - '0';
//    if (num<4){paintState = num;}
//  } else if (key == 'r'){
//    running = !running;
//  }
//}

//void mouseReleased(){
//  waitingForMouseUp = false;
//}
