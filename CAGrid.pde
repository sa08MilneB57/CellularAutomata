class CAGrid{
  int[] states;
  int[] nextStates;
  int w,h,defaultState;
  boolean periodic;
  CAGrid(int WIDTH, int HEIGHT,boolean wraparound,int _defaultState){
    w = WIDTH;
    h = HEIGHT;
    periodic = wraparound;
    defaultState = _defaultState;
    states = new int[w*h];
    nextStates = new int[w*h];
    for(int i=0;i<w*h;i++){
      states[i] = defaultState;
      nextStates[i] = defaultState;
    }
  }
  
  void editAll(int state){
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        editState(state,x,y);
      }
    }
  }
  
  void clear(){editAll(defaultState);}
  
  void binaryRandomise(float oneChance,int seed){randomSeed(seed);binaryRandomise(oneChance);}
  void binaryRandomise(float oneChance){
    if(oneChance > 1 || oneChance < 0){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int state = (random(1f)<=oneChance)?1:0;
        editState(state,x,y);
      }
    }
  }
  
  void balancedRandomise(float oneChance,int seed){randomSeed(seed);balancedRandomise(oneChance);}
  void balancedRandomise(float oneChance){
    if(oneChance > 1 || oneChance < 0){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int state = (random(1f)<=oneChance)?1:0;
        state *= (random(1f)<0.5)?1:-1;
        editState(state,x,y);
      }
    }
  }
  
  void binaryNoise(float dx,float dy){binaryNoise(1f,dx,dy,random(10000),random(10000));}
  void binaryNoise(float maxchance, float dx,float dy){binaryNoise(maxchance,dx,dy,random(10000),random(10000));}
  void binaryNoise(float dx,float dy,float seedx,float seedy){binaryNoise(1f,dx,dy,seedx,seedy);}
  void binaryNoise(float maxchance, float dx,float dy,float seedx,float seedy){
    if(maxchance > 1 || maxchance < -1){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
    float p = abs(maxchance);
    boolean flipped = maxchance<0;
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        float chance = p*noise(seedx + x*dx,seedy + y*dy);
        float roll = (flipped)?1f-random(1f):random(1f);
        int state = (roll<=chance)?1:0;
        editState(state,x,y);
      }
    }
  }
  void evenRandomise(int n){//random states in the range 0<=state<n
    if(n < 1){throw new IllegalArgumentException("There must be more than one possible cell state.");}
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int state = (int)random(n);
        editState(state,x,y);
      }
    }
  }
  
  void evenNoise(int n,float dx,float dy){evenNoise(n,dx,dy,random(10000),random(10000));}
  void evenNoise(int n,float dx,float dy,float seedx,float seedy){
    if(n < 1){throw new IllegalArgumentException("There must be more than one possible cell state.");}
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int state = (int)(n*noise(seedx + x*dx,seedy + y*dy));
        editState(state,x,y);
      }
    }
  }
  
  void setCenter(int value){
    editState(value,w/2,h/2);
  }
  
  //void fullRandomise(float... chances){
  //  float nonZeroProb = 0;
  //  for(float chance : chances){nonZeroProb += chance;}
  //  if(nonZeroProb > 1 || nonZeroProb < 0){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
  //  for (int y=0;y<h;y++){
  //    for (int x=0;x<w;x++){
  //      int state = (random(1f)<=nonZeroProb)?1:0;
  //      editState(state,x,y);
  //    }
  //  }
  //}
  
  int makeIndex(int x, int y){
    if(periodic){
      if (x>=w || x<0){ x= ((x%w)+ w)%w;}
      if (y>=h || y<0){ y= ((y%h)+ h)%h;}
    } else if (x>=w || x<0 || y>=h || y<0){return -1;}
    return y*w + x;
  }
  
  int getState(int x, int y){
    int index = makeIndex(x,y);
    return (index==-1)?defaultState:states[index];
  }
  
  
  void editState(int state,int x, int y){
    //this is for setup only, it allow interactive  (or otherwise) setting of board
    int i = makeIndex(x,y);
    states[i] = state;
    nextStates[i] = state;
  }
  
  void setState(int state, int x, int y){
    //this is for setting the state during an update
    nextStates[makeIndex(x,y)] = state;
  }
    
  void updateStates(){
    for (int i=0; i<w*h;i++){
      states[i] = nextStates[i];
    }
  }
  
  //void show(float scale,IntegerColorMap cmap){show(0,0,scale,cmap,color(255));}
  //void show(float scale,IntegerColorMap cmap,color gridcolor){show(0,0,scale,cmap,gridcolor);}
  //void show(IntegerColorMap cmap){show(0,0,1f,cmap,color(255));}
  //void show(IntegerColorMap cmap,color gridcolor){show(0,0,1f,cmap,gridcolor);}
  //void show(float west,float north,float scale,IntegerColorMap cmap){show(west,north,scale,cmap,color(255));}
  //void show(float west,float north,IntegerColorMap cmap){show(west,north,1f,cmap,color(255));}
  //void show(float west,float north,IntegerColorMap cmap,color gridcolor){show(west,north,1f,cmap,gridcolor);}
  void show(float west,float north,float scale,IntegerColorMap cmap,Integer gridcolor){
    if(scale==1){
      image(makeImage(cmap),west,north);
      return;
    }
    pushStyle();
      if(scale==1){
        noStroke();
      } else {
        if(gridcolor == null){
          noStroke();
        } else {         
          stroke(gridcolor);
          strokeWeight(min(1,scale/5)); 
        }
      }
      for (int y=0;y<h;y++){
        for (int x=0;x<w;x++){
          fill(cmap.map(getState(x,y)));
          rect(west + x*scale, north+y*scale,scale,scale);
        } 
      }
    popStyle();
  }
  
  PImage makeImage(IntegerColorMap cmap){
    PImage imgOut = createImage(w,h,ARGB);
    imgOut.loadPixels();
    for (int i=0;i<w*h;i++){
      imgOut.pixels[i] = cmap.map(states[i]);
    }
    imgOut.updatePixels();
    return imgOut;
  }
}
