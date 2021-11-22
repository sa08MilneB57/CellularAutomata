class VoronoiAutomata extends CAGrid{
  VoronoiAutomata(int w, int h){
    super(w,h,false,0);
  }
  
  void imageRandomise(PImage img, float drawChance){
    if(drawChance > 1 || drawChance < 0){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
    float scaleX,scaleY;
    if(img.width != w || img.height != h){
      scaleX = (float)img.width/(float)w;
      scaleY = (float)img.height/(float)h;
    } else {
      scaleX=1; scaleY=1;
    }
    img.loadPixels();
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        color c = img.pixels[(int)(scaleX*x) + (int)(scaleY*y)*img.width];
        int state = (random(1f)<=drawChance)?c:defaultState;
        editState(state,x,y);
      }
    }
    img.updatePixels();
  }
  void imageNoise(PImage img,float dx,float dy){imageNoise(img,1f,dx,dy,random(10000),random(10000));}
  void imageNoise(PImage img,float maxchance, float dx,float dy){imageNoise(img,maxchance,dx,dy,random(10000),random(10000));}
  void imageNoise(PImage img,float dx,float dy,float seedx,float seedy){imageNoise(img,1f,dx,dy,seedx,seedy);}
  void imageNoise(PImage img,float maxchance, float dx,float dy,float seedx,float seedy){
    if(maxchance > 1 || maxchance < -1){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
    float scaleX,scaleY;
    if(img.width != w || img.height != h){
      scaleX = (float)img.width/(float)w;
      scaleY = (float)img.height/(float)h;
    } else {
      scaleX=1; scaleY=1;
    }
    println(scaleX,scaleY);
    float p = abs(maxchance);
    boolean flipped = maxchance<0;
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        float chance = p*noise(seedx + x*dx,seedy + y*dy);
        float roll = (flipped)?1f-random(1f):random(1f);
        color c = img.pixels[(int)(scaleX*x) + (int)(scaleY*y)*img.width];
        int state = (roll<=chance)?c:defaultState;
        editState(state,x,y);
      }
    }
  }
  
  void YCoCgRandomise(float drawChance){
    if(drawChance > 1 || drawChance < 0){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        color c = YCoCg(random(1),((float)x/w)-0.5,((float)y/h)-0.5);
        int state = (random(1f)<=drawChance)?c:defaultState;
        editState(state,x,y);
      }
    }
  }
  
  void YCoCgNoise(float dx,float dy){YCoCgNoise(1f,dx,dy,random(10000),random(10000));}
  void YCoCgNoise(float maxchance, float dx,float dy){YCoCgNoise(maxchance,dx,dy,random(10000),random(10000));}
  void YCoCgNoise(float dx,float dy,float seedx,float seedy){YCoCgNoise(1f,dx,dy,seedx,seedy);}
  void YCoCgNoise(float maxchance, float dx,float dy,float seedx,float seedy){
    if(maxchance > 1 || maxchance < -1){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
    float p = abs(maxchance);
    boolean flipped = maxchance<0;
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        float chance = p*noise(seedx + x*dx,seedy + y*dy);
        float roll = (flipped)?1f-random(1f):random(1f);
        color c = YCoCg(roll/maxchance,((float)x/w)-0.5,((float)y/h)-0.5);
        int state = (roll<=chance)?c:defaultState;
        editState(state,x,y);
      }
    }
  }
  
  color mooreColAvg(int x,int y){
    int outR = 0;
    int outG = 0;
    int outB = 0;
    int outA = 0;
    int validNeighbors = 0;
    for(int j=-1;j<=1;j++){
      for(int i=-1;i<=1;i++){
        int neighbor = getState(x+i,y+j);
        if (neighbor == defaultState){continue;}
        outR += red(neighbor);
        outG += green(neighbor);
        outB += blue(neighbor);
        outA += alpha(neighbor);
        validNeighbors++;
      }
    }
    if(validNeighbors==0){return defaultState;}
    outR /= validNeighbors;
    outG /= validNeighbors;
    outB /= validNeighbors;
    outA /= validNeighbors;
    return color(outR,outG,outB,outA);
  }
  
  color vonNeumannColAvg(int x,int y){
    int outR = 0;
    int outG = 0;
    int outB = 0;
    int outA = 0;
    int validNeighbors = 0;
    for(int j=-1;j<=1;j++){
      for(int i=-1;i<=1;i++){
        if(abs(i)==1 && abs(j)==1){continue;}
        int neighbor = getState(x+i,y+j);
        if (neighbor == defaultState){continue;}
        outR += red(neighbor);
        outG += green(neighbor);
        outB += blue(neighbor);
        outA += alpha(neighbor);
        validNeighbors++;
      }
    }
    if(validNeighbors==0){return defaultState;}
    outR /= validNeighbors;
    outG /= validNeighbors;
    outB /= validNeighbors;
    outA /= validNeighbors;
    return color(outR,outG,outB,outA);
  }
  
  void mooreStep(){
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        if (getState(x,y) != defaultState){continue;}
        setState(mooreColAvg(x,y),x,y);
      }
    }
    updateStates();
  }
  
  void vonNeumannStep(){
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        if (getState(x,y) != defaultState){continue;}
        setState(vonNeumannColAvg(x,y),x,y);
      }
    }
    updateStates();
  }
}
