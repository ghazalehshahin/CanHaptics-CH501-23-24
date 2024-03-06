import java.util.Random;

class Utility{

  public Utility(){
  }
  
  public int[][] makeRandomMatrix(int width, int height, int n){
    int[][] matrix = new int[width][height];
    Random rand = new Random();
    
    for (int i = 0; i < width; i++){
      for (int j = 0; j < height; j++){
         matrix[i][j] = rand.nextInt(n);
      }
    }
    
    return matrix;
  }
  
  public int[][] makeLineMatrix(int width, int height){
    int[][] matrix = new int[width][height];
    
    for (int i = 0; i < width; i++){
      for (int j = 0; j < height; j++){
         if (i == 0 || j == 0){
           matrix [i][j] = 1;
         } else{
           matrix [i][j] = 0;
         }
      }
    }
    
    return matrix;
  }
  
  public int[][] makeStaticMatrix(int width, int height, int n){
    int[][] matrix = new int[width][height];
    
    for (int i = 0; i < width; i++){
      for (int j = 0; j < height; j++){
         matrix[i][j] = n;
      }
    }
    
    return matrix;
  }
}
