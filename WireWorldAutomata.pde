class WireWorldAutomata extends CAGrid{
  //0 is empty
  //1 is electron head
  //2 is electron tail
  //3 is conductor
  
  WireWorldAutomata(int WIDTH, int HEIGHT){
    super(WIDTH,HEIGHT,false,0);
  }
  WireWorldAutomata(int WIDTH, int HEIGHT,int[] initialState){
    super(WIDTH,HEIGHT,false,0);
    if(initialState.length != w*h){throw new IllegalArgumentException("Initial state much mach size of cell grid");}
    
    arrayCopy(initialState,states);
    arrayCopy(initialState,nextStates);
  }
  
  
  void step(){
    for (int y=0;y<h;y++){
      for (int x=0;x<w;x++){
        int state = getState(x,y);
        if(state==0){//if empty
          continue;
        } else if (state==1){//if head
          setState(2,x,y);
        } else if (state==2){//if tail
          setState(3,x,y);
        } else {
          int nearbyElectronHeads = 0;
          for(int j=-1;j<=1;j++){
            for(int i=-1;i<=1;i++){
              if(j==0 && i==0){
                continue;
              } else if(getState(x+i,y+j)==1){
                nearbyElectronHeads++;
              }
            }
          }
          if(nearbyElectronHeads==1 || nearbyElectronHeads==2){
            setState(1,x,y);
          }
        }
      }
    }
    updateStates();
  }
  
  
  
  //endofclass
}
