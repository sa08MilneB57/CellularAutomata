class OneDBinaryAutomata extends CAGrid{
  int currentLine;
  
  OneDBinaryAutomata(int WIDTH,int HEIGHT,int[] lineOne,boolean wraparound,int defaultState){
    super(WIDTH,HEIGHT,wraparound,defaultState);
    if(lineOne.length != WIDTH){throw new IllegalArgumentException("First Line must be 'WIDTH' long");}
    currentLine = 0;
    for(int x=0; x<w; x++){
      if (!(lineOne[x]==0 || lineOne[x]==1)){throw new IllegalArgumentException("First Line must be 0s and 1s only");}
      states[x] = lineOne[x];
      nextStates[x] = lineOne[x];
    }
  }
  OneDBinaryAutomata(int WIDTH,int HEIGHT,boolean wraparound,int defaultState){
    super(WIDTH,HEIGHT,wraparound,defaultState);
    currentLine = 0;
  }
  
  @Override
  void binaryRandomise(float oneChance){
    if(oneChance > 1 || oneChance < 0){throw new IllegalArgumentException("Probabilities must be between 0 and 1, dumb-dumb.");}
    for (int x=0;x<w;x++){
      int state = (random(1f)<=oneChance)?1:0;
      editState(state,x,0);
    }
  }
  
  int inputState(int x, int y){
    return 4*getState(x-1,y-1) + 2*getState(x,y-1) + getState(x+1,y-1);
  }
  
  int outputState(int input,int rule){
    int mask = 1<<input;
    return ((rule & mask) == 0)?0:1;
  }
  
  boolean step(int rule){
    if(rule < 0 || rule > 256){throw new IllegalArgumentException("Rule required for 1D Automata must be between 0 and 255 (inclusive)");}
    if(currentLine == h-1){return true;}
    currentLine++;
    for (int x=0;x<w;x++){
      int in = inputState(x,currentLine);
      int newState = outputState(in,rule);
      setState(newState,x,currentLine);
    }
    updateStates();
    return false;
  }
  
}
