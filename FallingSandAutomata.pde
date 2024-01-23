class FallingSand extends CAGrid{
  
  FallingSand(int WIDTH, int HEIGHT,boolean wrap){
    super(WIDTH,HEIGHT,wrap,0);
  }  
  
  void step(){
    for (int y=0;y<h-1;y++){
      for (int x=0;x<w;x++){
        int state = getState(x,y);
        if(state==0){continue;}//if no sand in cell, move to next cell
        int state_below = getState(x,y+1);
        if(state_below==0){//if space below then allow delete this cell's state and copy it to the cell below
          setState(0,x,y);
          setState(state,x,y+1);
        } else {
          int state_left = (x==0)?-1:getState(x-1,y+1);
          int state_right = (x==w-1)?-1:getState(x+1,y+1);
          if (state_left==0 && state_right==0){
            int dir = (random(512)<256)?-1:1;
            setState(0,x,y);
            setState(state,x + dir,y+1);
          } else if (state_left == 0){
            setState(0,x,y);
            setState(state,x - 1,y+1);            
          } else if(state_right == 0){
            setState(0,x,y);
            setState(state,x + 1,y+1);            
          }
        }
      
      }
    }
    updateStates();
  }
  
}
