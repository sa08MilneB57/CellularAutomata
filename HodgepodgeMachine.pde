class HodgepodgeMachine extends CAGrid{
  int ill,n;
  HodgepodgeMachine(int WIDTH, int HEIGHT,boolean wraparound,int _n){
    // ill means maximum state
    // infected means more than 0 but less than max;
    super(WIDTH,HEIGHT,wraparound,0);
    n = _n;
    ill = n-1;
  }
  
  void randomise(){evenRandomise(n);}
  
  void step(float k_inf,float k_ill,int g){
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int infectedN = 0; //infected neighbors
        int illN = 0; //ill neighbors
        int stateTotal = 0;
        int state = getState(x,y);
        if (state < 0 || state > ill){throw new IllegalArgumentException("Invalid state: " + state + " at (" + x + "," + y + ")");}
        if (state >= ill){//if cell is ill
          setState(0,x,y);
          continue;
        }
        for (int j=-1;j<=1;j++){
          for (int i=-1;i<=1;i++){
            int neighbor = getState(x+i,y+j);
            stateTotal += neighbor;
            //if(i==0 && j==0){continue;}
            if(neighbor == ill)   {illN++;}
            else if (neighbor > 0){infectedN++;}
          }  
        }
        if (state == 0){//if cell is healthy
          int newState = (int)(infectedN/k_inf) + (int)(illN/k_ill);
          setState(min(newState,ill), x,y);
        } else {//if cell is infected
          int newState = (int)(stateTotal/(infectedN+illN+1)) + g;
          setState(min(newState,ill),x,y);          
        }
      }
    }
    updateStates();
  }
}
