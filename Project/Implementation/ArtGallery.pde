/**
 **********************************************************************************************************************
 * @file       ArtGallery.pde
 * @author     Ghazaleh Shahin
 * @version    V1.0.0
 * @date       05-March-2024
 * @brief      Showing different art textures
 **********************************************************************************************************************
 * @attention
 *
 *
 **********************************************************************************************************************
 */



/* library imports *****************************************************************************************************/ 
import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;
import java.util.*;
import java.util.Random;
import java.awt.image.BufferedImage;

import java.io.BufferedReader;
import java.io.FileReader;

import java.util.Arrays;
import java.util.Scanner;

/* end library imports *************************************************************************************************/  



/* scheduler definition ************************************************************************************************/ 
private final ScheduledExecutorService scheduler      = Executors.newScheduledThreadPool(1);
/* end scheduler definition ********************************************************************************************/ 



/* device block definitions ********************************************************************************************/
Board             haplyBoard;
Device            widgetOne;
Mechanisms        pantograph;

byte              widgetOneID                         = 5;
int               CW                                  = 0;
int               CCW                                 = 1;
boolean           renderingForce                     = false;
/* end device block definition *****************************************************************************************/



/* framerate definition ************************************************************************************************/
long              baseFrameRate                       = 120;
/* end framerate definition ********************************************************************************************/ 



/* elements definition *************************************************************************************************/

/* Screen and world setup parameters */
float             pixelsPerCentimeter                 = 40.0;

/* generic data for a 2DOF device */
/* joint space */
PVector           angles                              = new PVector(0, 0);
PVector           torques                             = new PVector(0, 0);

/* task space */
PVector           posEE                               = new PVector(0, 0);
PVector           fEE                                 = new PVector(0, 0); 

/* World boundaries */
FWorld            world;
float             worldWidth                          = 25.0;  
float             worldHeight                         = 25.0; 

float             edgeTopLeftX                        = 0.0; 
float             edgeTopLeftY                        = 0.0; 
float             edgeBottomRightX                    = worldWidth; 
float             edgeBottomRightY                    = worldHeight;

float             gravityAcceleration                 = 980; //cm/s2
/* Initialization of virtual tool */
HVirtualCoupling  s;


/* Controll variables */
int               k                                   =0;

/* Texture variables */
FBody             element;
Texture           texture                             = new Texture();

List<FBody>       elements                            = new ArrayList<FBody>();

/* text font */
PFont             f;

/* end elements definition *********************************************************************************************/  



/* setup section *******************************************************************************************************/
void setup(){
  /* put setup code here, run once: */
  
  /* screen size definition */
  size(1000, 1000);  
  
  /* Images of art pieces*/
  //PImage            fauxArt                             = loadImage("/img/test3.png");
  //PImage            stippledArt                         = loadImage("");
  //PImage            grittyArt                           = loadImage("");
  
  //BufferedImage     fauxArtImage                        = (BufferedImage) fauxArt.getNative();
  //int[][]           fauxArtMatrix                       = getMatrixOfImage (fauxArtImage);
  
  //BufferedImage     stippledArtImage                        = (BufferedImage) stippledArt.getNative();
  //int[][]           stippledArtMatrix                       = getMatrixOfImage (stippledArtImage);
  
  //BufferedImage     grittyArtImage                        = (BufferedImage) grittyArt.getNative();
  //int[][]           grittyArtMatrix                       = getMatrixOfImage (grittyArtImage);
  
  
  /*Reading matrix files*/
  int[][] stippledArtMatrix = {{0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1}, 
                              {0,0,0,0,1,1,0,1,1,1,1,1,1,1,1,1,0},
                              {0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1},
                              {0,0,0,0,0,1,1,1,1,1,1,0,1,1,1,1,1},
                              {0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1},
                              {0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,2},
                              {0,0,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1},
                              {0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                              {1,1,1,1,1,1,0,1,1,1,1,1,2,1,1,1,1}, 
                              {1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2},
                              {1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1},
                              {1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2},
                              {1,1,1,1,1,1,1,1,2,1,1,2,2,1,1,2,2},
                              {1,1,1,1,1,1,1,2,1,1,2,1,2,1,2,2,2},
                              {1,1,1,1,1,2,1,1,1,1,2,1,1,2,2,2,2},
                              {1,1,1,1,1,1,2,1,1,1,2,1,2,2,2,2,2},
                              {1,1,1,1,1,2,1,1,2,1,2,2,2,2,2,2,2}};
  
  
  /* set font type and size */
  f                   = createFont("Arial", 16, true);

  /* device setup */
  
  /**  
   * The board declaration needs to be changed depending on which USB serial port the Haply board is connected.
   * In the base example, a connection is setup to the first detected serial device, this parameter can be changed
   * to explicitly state the serial port will look like the following for different OS:
   *
   *      windows:      haplyBoard = new Board(this, "COM10", 0);
   *      linux:        haplyBoard = new Board(this, "/dev/ttyUSB0", 0);
   *      mac:          haplyBoard = new Board(this, "/dev/cu.usbmodem1411", 0);
   */
   
  haplyBoard          = new Board(this, Serial.list()[1], 0);
  widgetOne           = new Device(widgetOneID, haplyBoard);
  pantograph          = new Pantograph();
  
  widgetOne.set_mechanism(pantograph);

  widgetOne.add_actuator(1, CCW, 2);
  widgetOne.add_actuator(2, CW, 1);
 
  widgetOne.add_encoder(1, CCW, 241, 10752, 2);
  widgetOne.add_encoder(2, CW, -61, 10752, 1);
  
  
  widgetOne.device_set_parameters();
  
  
  /* 2D physics scaling and world creation */
  hAPI_Fisica.init(this); 
  hAPI_Fisica.setScale(pixelsPerCentimeter); 
  world               = new FWorld();
  
  /* Set faux textures */
  elements = addTexture(stippledArtMatrix);
  println(elements);
  //k = 1;
  
  //  /* Setup the Virtual Coupling Contact Rendering Technique */
  s                   = new HVirtualCoupling((0.75)); 
  s.h_avatar.setDensity(4); 
  s.h_avatar.setFill(255,255,255,255); 
  s.h_avatar.setSensor(false);

  s.init(world, edgeTopLeftX+worldWidth/2, edgeTopLeftY+2); 
  
  /* World conditions setup */
  world.setGravity((0.0), gravityAcceleration); //1000 cm/(s^2)
  world.setEdges((edgeTopLeftX), (edgeTopLeftY), (edgeBottomRightX), (edgeBottomRightY)); 
  world.setEdgesRestitution(.4);
  world.setEdgesFriction(0.5);
 
  world.draw();
  
  /* setup framerate speed */
  frameRate(baseFrameRate);
  
  /* setup simulation thread to run at 1kHz */
  SimulationThread st = new SimulationThread();
  scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
}
/* end setup section ***************************************************************************************************/



/* draw section ********************************************************************************************************/
void draw(){
   if (renderingForce == false) {
    background(255);
    world.draw();
  }
}
/* end draw section ****************************************************************************************************/



/* simulation section **************************************************************************************************/
class SimulationThread implements Runnable{
  
  public void run(){
    /* put haptic simulation code here, runs repeatedly at 1kHz as defined in setup */
    
    renderingForce = true;
    
    if(haplyBoard.data_available()){
      /* GET END-EFFECTOR STATE (TASK SPACE) */
      widgetOne.device_read_data();
    
      angles.set(widgetOne.get_device_angles()); 
      posEE.set(widgetOne.get_device_position(angles.array()));
      posEE.set(posEE.copy().mult(200));  
    }
    
    s.setToolPosition(edgeTopLeftX+worldWidth/2-(posEE).x, edgeTopLeftY+(posEE).y-7); 
    s.updateCouplingForce();
 
 
    fEE.set(-s.getVirtualCouplingForceX(), s.getVirtualCouplingForceY());
    fEE.div(100000); //dynes to newtons
    
    
    torques.set(widgetOne.set_device_torques(fEE.array()));
    widgetOne.device_write_torques();
    
    for (int i = 0; i < elements.size(); ++i)
    {
      if (s.h_avatar.isTouchingBody(elements.get(i)) && elements.get(i).getName().equals("stippled")){
        s.h_avatar.setDamping(900);
        s.h_avatar.setSensor(true);
        break;
      } 
      else {
        s.h_avatar.setDamping(4);
      }   
    }

    
    
    world.step(1.0f/1000.0f);
  
    renderingForce = false;
  }
}
/* end simulation section **********************************************************************************************/



/* helper functions section, place helper functions here ***************************************************************/

List<FBody> addTexture (int [][] elements){
  List<FBody> elementsList  = new ArrayList<FBody>();
  FBody element;
  float x = 0;
  float y = 0;
  int side = elements.length / 2;
  for(int i = 0; i < elements.length; ++i) {
    if(i <= side){
      y = edgeTopLeftY + worldHeight/2.0 - (side - i);
    }
    else{
      y = edgeTopLeftY + worldHeight/2.0 + (i - side); 
    }
      for(int j = 0; j < elements[i].length; ++j) {
        if(j <= side){
          x = edgeTopLeftX + worldWidth/2.0 - (side - j);
        }
        else{
          x = edgeTopLeftX + worldWidth/2.0 + (j - side); 
        }
        
        if(elements[i][j] == 2){
          //println("x, y, in case 2: " + x + " " + y);
          element = texture.createStippledTexture(0.3 ,x, y, 10, 10, 10, 255, 800);
          elementsList.add(element);
        }
        else if(elements[i][j] == 1){
          //println("x, y, in case 1: " + x + " " + y);
          element = texture.createStippledTexture(0.1 ,x, y, 10, 10, 10, 255, 800);
          elementsList.add(element); 
        }
         if(elements[i][j] == 0){
           //println("x, y, in case 0: " + x + " " + y);
          element = texture.createStippledTexture(0, x, y, 255, 255 ,255, 0, 0);
          elementsList.add(element);             
        }
       }
  }
  //world.draw();  

  return elementsList;
}

int[][] getMatrixOfImage(BufferedImage bufferedImage) {
    int width = bufferedImage.getWidth(null);
    System.out.println(width);
    int height = bufferedImage.getHeight(null);
    System.out.println(height);
    int[][] pixels = new int[width][height];
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            pixels[i][j] = bufferedImage.getRGB(i, j);
            if(pixels[i][j] == -1){
              pixels[i][j] = 1;
            }else{
              pixels[i][j] = 0;
            }
            System.out.println(pixels[i][j]);
        }
    }
    
    return pixels;
}

int[][] readFile (Scanner sc, int rows, int columns){     
      int [][] myArray = new int[rows][columns];
      //while(sc.hasNextLine()) {
      //   for (int i=0; i<myArray.length; i++) {
      //      String[] line = sc.nextLine().trim().split(" ");
      //      for (int j=0; j<line.length; j++) {
      //         myArray[i][j] = Integer.parseInt(line[j]);
      //      }
      //   }
      //}
      return myArray;
   }

/* keyboard inputs ********************************************************************************************************/
//void keyPressed() {
//  System.out.println("keyPressed");
  
//  /*reset*/
//  if (key == '1') { //<>//
//    if (k == 1){
//      System.out.println("You are in the first world");
//      return;
//    } else if (k == 2){
//      removeBodyByName ("element");
//      removeBodyByName ("bouncy");
//    } else {
//      removeBodyByName ("element");
//    }
//    k = 1;
//    elements.removeAll(elements);
//    elements = addelements(elementLocations);
//  }
//  if (key == '2') {
//    if (k == 2){
//      System.out.println("You are in the second world");
//      return;
//    } else if (k == 1){
//      removeBodyByName ("element");
//      removeBodyByName ("sticky");
//    } else {
//      removeBodyByName ("element");
//    }
//    k = 2;
//    elements.removeAll(elements);
//    elements = addelements(elementLocations2);
//  }
//  if (key == '3'){
//    if (k == 3){
//      System.out.println("You are in the third world");
//      return;
//    } else if (k == 1){
//      removeBodyByName ("element");
//      removeBodyByName ("sticky");
//    } else {
//      removeBodyByName ("element");
//      removeBodyByName ("bouncy");
//    }
//    k = 3;
//    elements.removeAll(elements);
//    elements = addelements(elementLocations3);  
//  }
//}

void removeBodyByName(String bodyName) {
  ArrayList<FBody> bodies = world.getBodies();
  for (FBody b : bodies) {
    try {
      if (b.getName().equals(bodyName)) {
        world.remove(b);
      }
    } 
    catch(NullPointerException e) {
      // do nothing
    }
  }
}


/* end helper functions section ****************************************************************************************/
