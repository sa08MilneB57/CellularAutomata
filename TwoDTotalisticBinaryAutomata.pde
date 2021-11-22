class TwoDTotallistic extends CAGrid{
  TwoDTotallistic(int WIDTH, int HEIGHT,boolean wrap){
    super(WIDTH,HEIGHT,wrap,0);
  }
  
  int vonNeumannTotal(int x,int y,boolean countSelf){
    int out = 0;
    if(countSelf){out += getState(x,y);}
    out += getState(x-1,y);
    out += getState(x+1,y);
    out += getState(x,y-1);
    out += getState(x,y+1);
    return out;
    
  }
  int mooreTotal(int x,int y,boolean countSelf){
    int out = 0;
    for(int j=-1;j<=1;j++){
      for(int i=-1;i<=1;i++){
        if(!countSelf && i==0 && j==0){continue;}
        out += getState(x+i,y+j);
      }
    }
    return out;  
  }
  
  void stepVonNeumann(int rule,boolean stateDependent){
    int maxRule = (stateDependent)?1<<10:1<<5;
    if(rule > maxRule){throw new IllegalArgumentException("Rule must be less than " + maxRule + " for von Neumann neighborhood.");}
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int total = vonNeumannTotal(x,y,!stateDependent);
        int mask;
        if(stateDependent){
          mask = 1<<2*total + getState(x,y);
        } else {
          mask = 1<<total;
        }
        if((rule & mask) == 0){
          setState(0,x,y);
        } else {
          setState(1,x,y);
        }
      }
    }
    updateStates();
  }
  void stepMoore(int rule,boolean stateDependent){
    int maxRule = (stateDependent)?1<<18:1<<9;
    if(rule > maxRule){throw new IllegalArgumentException("Rule must be less than " + maxRule + " for Moore neighborhood.");}
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int total = mooreTotal(x,y,!stateDependent);
        int mask;
        if(stateDependent){
          mask = 1<<2*total + getState(x,y);
        } else {
          mask = 1<<total;
        }
        if((rule & mask) == 0){
          setState(0,x,y);
        } else {
          setState(1,x,y);
        }
      }
    }
    updateStates();
  }
  
}
