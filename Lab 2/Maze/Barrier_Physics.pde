class Barrier{
  /**
  * Creates an Actuator using motor port position 1
  */  
  int wallNumber = 17;
  FBox[][] wall = new FBox[wallNumber][wallNumber];
  
  public Barrier(){
    
  }
  
  public void add(FWorld world){
  int[][] wallLocations = {
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}, 
  {1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1},
  {1,0,1,1,1,0,1,0,1,0,1,0,1,0,1,0,1},
  {1,0,1,0,1,1,1,0,1,0,1,0,1,0,1,0,1},
  {1,0,0,0,0,0,1,0,1,0,1,1,1,0,1,0,1},
  {1,1,1,1,1,0,1,0,1,0,1,0,0,0,1,0,1},
  {1,0,0,0,1,0,1,0,1,0,1,0,1,1,1,0,1},
  {1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,1},
  {0,0,1,1,1,0,1,0,1,0,1,0,1,0,1,0,0},
  {1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1},
  {1,0,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1},
  {1,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,1},
  {1,0,1,0,1,1,0,1,1,0,1,0,0,0,0,0,1},
  {1,0,1,0,0,1,0,1,0,0,1,1,1,0,1,0,1},
  {1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,0,1},
  {1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
  };
  float x = 0;
  float y = 0;
  for(int i = 0; i < wallLocations.length; ++i) {
    if(i <= 8){
      y = edgeTopLeftY + worldHeight/2.0 - (8 - i);
    }
    else{
      y = edgeTopLeftY + worldHeight/2.0 + (i - 8); 
    }
      for(int j = 0; j < wallLocations[i].length; ++j) {
        if(j <= 8){
          x = edgeTopLeftX + worldWidth/2.0 - (8 - j);
        }
        else{
          x = edgeTopLeftX + worldWidth/2.0 + (j - 8); 
        }
        
        if(wallLocations[i][j] == 1){
            wall[i][j] = new FBox(1.0, 1.0);
            wall[i][j].setPosition(x, y);
            wall[i][j].setFill(255, 255, 255, 0);
            wall[i][j].setNoStroke();
            wall[i][j].setStaticBody(true);
            //wall[i][j].setSensor(true);
            world.add(wall[i][j]);
        }
        else{
            wall[i][j] = new FBox(0.0, 0.0);
            wall[i][j].setHaptic(true, 100, 0);
            wall[i][j].setSensor(true);
            wall[i][j].setHapticStiffness(100);
            wall[i][j].setFriction(1000);

        }
       }
  }
}
  
  public void showWalls(){
    for (int i = 0; i < wall.length; i++) {
      for (int j = 0; j < wall[i].length; j++) {
        if (wall[i][j].getHeight() == 1.0){
            wall[i][j].setFill(255, 255, 255, 0);
        }
      }
    }
  }
}
