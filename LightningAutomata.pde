class LightningAutomata extends CAGrid {
  int maxFeeder = 5;
  double[] permittivity;
  PImage permittivityImage;
  double[] electricField;
  PImage electricFieldImage;
  LightningAutomata(int w, int h) {
    super(w, h, false, 0);
    randomisePermittivity();
    randomiseField();
  }
  
  void seedLightning(float seedChance){seedLightning(seedChance,false);}
  void seedLightning(float seedChance,boolean justPositive){
    for (int y=0; y<h; y++) {
      for (int x=0; x<w; x++) {
        double e = electricField[x + w*y];
        if (random(1f) < seedChance*Math.abs(e)){
          int newstate = (justPositive)?1:(int)Math.signum(e);
          editState(newstate,x,y);
        }
      } 
    }
  }
    
  void seedLightningTopAndBottom(float seedChance){seedLightningTopAndBottom(seedChance,false);}
  void seedLightningTopAndBottom(float seedChance,boolean justPositive){
    for(int i=0;i<w;i++){
      if (random(1f) < seedChance*electricField[i]){
        editState(1,i,0);
      }
      if (random(1f) < -seedChance*electricField[i + (h-1)*w]){
        editState(((justPositive)?1:-1),i,h-1);
      }
      
    }
  }
  
  void randomiseField() {
    float seedx = random(210481);
    float seedy = random(210481);
    electricField = new double[w*h];
    electricFieldImage = createImage(w, h, ARGB);
    electricFieldImage.loadPixels();
    for (int y=0; y<h; y++) {
      double averageField = -2*((double)y / (double)h - 0.5);
      for (int x=0; x<w; x++) {
        double p = averageField + (noise(x*0.02 + seedx, y*0.01 + seedy) - 0.5);
        electricField[x + y*w] = p;
        electricFieldImage.pixels[x + y*w] = color((float)Math.max(0,255*p),0,(float)Math.max(0,-255*p),50*(float)Math.abs(p));
      }
    }
    electricFieldImage.updatePixels();
  }

  void randomisePermittivity() {
    double seedx = random(210481);
    double seedy = random(210481);
    permittivity = new double[w*h];
    permittivityImage = createImage(w, h, ARGB);
    permittivityImage.loadPixels();
    for (int y=0; y<h; y++) {
      for (int x=0; x<w; x++) {
        double p = noise((float)(x*0.05 + seedx), (float)(y*0.025 + seedy),(float)((x-y)*0.001));
        permittivity[x + y*w] = Math.max(0.01d, p*p*p);
        permittivityImage.pixels[x + y*w] = color(0,255,0, (float)(50*permittivity[x + y*w]));
      }
    }
    permittivityImage.updatePixels();
  }
  
  double[] mooreVoltages(int x, int y){
    double[] voltages = new double[9];
    int vi = 0;
    double self = electricField[makeIndex(x,y)];
    double maxAbsV = 0;
    //get voltages
    for (int j=-1; j<=1; j++) {
      for (int i=-1; i<=1; i++) {
        int index = makeIndex(x+i,y+j);
        if (index == -1){index = makeIndex(x,y);}
        voltages[vi] = electricField[index] - self;
        maxAbsV = Math.max(maxAbsV, Math.abs(voltages[vi]));
        vi++;
      }
    }
    for (vi=0; vi<9; vi++){
      voltages[vi] /= maxAbsV;
    }
    return voltages;
  }
  
  double[] vonNeumannVoltages(int x, int y){
    double[] voltages = new double[4];
    int vi = 0;
    double self = electricField[makeIndex(x,y)];
    double maxAbsV = 0;
    int index;
    //get voltages
    
    index = makeIndex(x,y-1);//north
    if (index == -1){index = makeIndex(x,y);}
    voltages[vi] = electricField[index] - self;
    maxAbsV = Math.max(maxAbsV, Math.abs(voltages[vi]));
    vi++;
    
    
    index = makeIndex(x+1,y);//east
    if (index == -1){index = makeIndex(x,y);}
    voltages[vi] = electricField[index] - self;
    maxAbsV = Math.max(maxAbsV, Math.abs(voltages[vi]));
    vi++;
    
    
    index = makeIndex(x,y+1);//south
    if (index == -1){index = makeIndex(x,y);}
    voltages[vi] = electricField[index] - self;
    maxAbsV = Math.max(maxAbsV, Math.abs(voltages[vi]));
    vi++;
    
    
    index = makeIndex(x-1,y);//west
    if (index == -1){index = makeIndex(x,y);}
    voltages[vi] = electricField[index] - self;
    maxAbsV = Math.max(maxAbsV, Math.abs(voltages[vi]));
    vi++;
    
    for (vi=0; vi<4; vi++){
      voltages[vi] /= maxAbsV;
    }
    return voltages;
  }
  
  int[] mooreMinMax(int x, int y) {
    int max = 0;
    int min = 0;
    for (int j=-1; j<=1; j++) {
      for (int i=-1; i<=1; i++) {
        max = max(getState(x+i, y+j), max);
        min = min(getState(x+i, y+j), min);
      }
    }
    int[] out = {min,max};
    return out;
  }
  int[] vonNeumannMinMax(int x, int y) {
    int max = 0;
    int min = 0;
    max = max(max, getState(x+1, y));
    max = max(max, getState(x-1, y));
    max = max(max, getState(x, y+1));
    max = max(max, getState(x, y-1));
    
    min = min(min, getState(x+1, y));
    min = min(min, getState(x-1, y));
    min = min(min, getState(x, y+1));
    min = min(min, getState(x, y-1));
    
    int[] out = {min,max};
    return out;
  }

  void step(boolean mooreMode,double decayChance,int backFlowRate) {
    maxFeeder = 5;
    for (int y=0; y<h; y++) {
      for (int x=0; x<w; x++) {
        int currentState = getState(x, y);
        int[] minMax = (mooreMode)?mooreMinMax(x, y):vonNeumannMinMax(x,y);
        double roll = random(1f);
        if (currentState == 0) {
          if (roll > permittivity[x + w*y]) {
            continue;
          }
          if (minMax[0] == 0 && minMax[1] == 0) {
            continue;
          } else if (abs(minMax[1]) > abs(minMax[0])){
            setState(minMax[1] + 1, x, y);
          } else {
            setState(minMax[0] - 1, x, y);
          }
        } else if (currentState > 0 && minMax[0] < 0) {//I am positive with negative neighbors
           setState(-(currentState + ((roll < permittivity[x + w*y])?backFlowRate:0)),x,y);
        } else if (currentState < 0 && minMax[1] > 0) {//I am negative with positive neighbors
           setState(-(currentState - ((roll < permittivity[x + w*y])?backFlowRate:0)),x,y);
        } else if (roll < decayChance && currentState>0) {
          setState(max(0, currentState - 1), x, y);
        } else if (roll < decayChance && currentState<0) {
          setState(min(0, currentState + 1), x, y);
        }
        maxFeeder = max(maxFeeder, currentState);
        maxFeeder = max(maxFeeder, -currentState);
      }
    }
    updateStates();
  }
}
