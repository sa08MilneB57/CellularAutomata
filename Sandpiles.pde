class Sandpile extends CAGrid{
  boolean[] incremented;
  Sandpile(int WIDTH, int HEIGHT,boolean wraparound){
    super(WIDTH,HEIGHT,wraparound,0);}
  
  void incrementState(int x, int y){incrementState(1,x,y);}
  void incrementState(int n,int x, int y){
    //this is for incrementing a state during an update
    int index = makeIndex(x,y);
    if (index==-1){return;}
    int currentState;
    if(incremented[index]){
        currentState = nextStates[index];
    } else {
      currentState = states[index];
      incremented[index] = true;
    }
    nextStates[index] =  currentState + n;
  }
  
  void step(){step(false);}
  void step(boolean mooreMode){
    int n = (mooreMode)?8:4;
    incremented = new boolean[w*h];
    for (int i=0;i<w*h;i++){incremented[i] = false;}
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int state = getState(x,y);
        //throw error on negative cells
        if(state < 0){throw new RuntimeException("Invalid Cell State Reached");}
        //skip cells that don't topple
        if(state < n){continue;}
        if (mooreMode){
          for(int j=-1;j<=1;j++){
            for(int i=-1;i<=1;i++){
              if(i==0 && j==0){continue;}
              incrementState(x+i,y+j);
            }
          }
        } else {
          incrementState(x,y+1);
          incrementState(x+1,y);
          incrementState(x,y-1);
          incrementState(x-1,y);
        }
        incrementState(-n,x,y);        
      }
    }
    updateStates();
  }
}
