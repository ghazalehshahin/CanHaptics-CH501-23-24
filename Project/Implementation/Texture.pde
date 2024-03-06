class Texture{
  
  public Texture(){
  }
  
  public FBox createBoxElement(float width, float height, float xCoord, float yCoord, float red, float green, float blue,
  float alpha, float density, float rotation, boolean hasStaticBody, boolean isStatic, boolean isSensor, String name){
    
    FBox elBox = new FBox (width, height);
    
    //Setting x and y
    elBox.setPosition(xCoord, yCoord);    
    
    //Setting color
    elBox.setFill(red, green, blue, alpha);
    
    //Setting density of the object
    elBox.setDensity(density);
    
    //Setting rotation
    elBox.setRotation(rotation);
    
    //If the object is static itself or has a static body
    elBox.setStaticBody(hasStaticBody);
    elBox.setStatic(isStatic);
    
    //If the object is sensor
    elBox.setSensor(isSensor);
    
    //Disabling stroke
    elBox.setNoStroke();
    
    //Setting name for the box
    elBox.setName(name);
   
    
    world.add(elBox);
    return elBox;
  }  
  
  public FCircle createCircleElement(float radius, float xCoord, float yCoord, float red, float green, float blue, float alpha, float density, float restitution, boolean hasStaticBody, boolean isStatic, boolean isSensor, String name){
    
    FCircle elCircle = new FCircle (radius);
    
    //Setting x and y
    elCircle.setPosition(xCoord, yCoord);    
    
    //Setting color
    elCircle.setFill(red, green, blue, alpha);
    
    //Setting density
    elCircle.setDensity(density);
    
    //Setting restitution (For bumpy objects)
    elCircle.setRestitution(restitution);
    
    //If the object is static
    elCircle.setStatic(isStatic);
    elCircle.setStaticBody(hasStaticBody);

    //If the object is sensor
    elCircle.setSensor(isSensor);
    
    //Disabling stroke
    elCircle.setNoStroke();
    
    //Setting name for the circle
    elCircle.setName(name);
   
    
    world.add(elCircle);
    return elCircle;
  } 
  
  public FLine createLineElement(float xStart, float yStart, float xEnd, float yEnd, float density, boolean hasStaticBody, boolean isStatic, boolean isSensor, String name ){
    FLine elLine = new FLine(xStart, yStart, xEnd, yEnd);
    
    elLine.setDensity(density);
    
    elLine.setStatic(isStatic);
    elLine.setStaticBody(hasStaticBody);

    elLine.setSensor(isSensor);
    
    elLine.setName(name);
    
    elLine.setFriction(200);

    world.add(elLine);
    return elLine;
  }

  
  //Function to write in the future based on our need for texture rendering
  //public FBlob createBlobElement(){}
  //public FCompound createCompoundElement(){}
  //public FPoly createPloyElement(){}
  
  
  public FBox createFauxTexture(float w, float h, float x, float y, float red, float green, float blue, float alpha, float density, float rotation){
    return this.createBoxElement(w, h, x, y, red, blue, green, alpha, density, rotation, false, true, false, "faux");
  }
  
  public FCircle createStippledTexture(float radius, float x, float y, float red, float green, float blue, float alpha, float density){
    return this.createCircleElement(radius, x, y, red, blue, green, alpha, density, 0.2, true, false, false, "stippled");
  }
  
  public FBox createGrittyTexture(float w, float h, float x, float y, float red, float green, float blue, float alpha, float density, float rotation){
    return this.createBoxElement(w, h, x, y, red, blue, green, alpha, density, rotation, false, true, true, "gritty");
  }
  
  public FLine createCanvasTexture(float xStart, float yStart, float xEnd, float yEnd, float density){
    return this.createLineElement(xStart, yStart, xEnd, yEnd, density, false, true, false, "canvas");
  }
  
  //Write functions for creating other functions here

}
