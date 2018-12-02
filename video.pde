void findDice()  {
    
  //image(video,width/2,height/2);
  
  loadPixels();
  video.loadPixels();
  
  threshold = 50;
  
  //int[] yellY = new int[1];
  
  int[] bluY = new int[1];
  int[] yellY = new int[1];

  //moves through all of the current pixels and compares it with the target value.  
  for(int x = 0; x < video.width; x++)  {
    for(int y = 0; y < video.height; y++)  {
    
      int loc = x + y*video.width;
      
      color current = video.pixels[loc];
      
      float r = red(current);
      float g = green(current);
      float b = blue(current);
      
      float r1 = red(bTarget);
      float g1 = green(bTarget);
      float b1 = blue(bTarget);
      
      float r2 = red(yTarget);
      float g2 = green(yTarget);
      float b2 = blue(yTarget);
      
      float bDis = dist(r,b,g,r1,b1,g1);
      float yDis = dist(r,b,g,r2,b2,g2);
      
      //creates an array of the y-coordinates of the current pixels that meet the conditions of blue or yellow, and places them in separate arrays
      if (bDis < threshold)   {
        bluY = append(bluY, y); 
      }
      
      if (yDis < threshold)   {
        yellY = append(yellY,y); 
      }
    }
  }
  
  int ySum = 0;
  int BySum = 0;
  
  //sums the y-values in these arrays
  for (int j = 0; j < yellY.length; j++)  {
    ySum = ySum + yellY[j];
  }    
  
  for (int k = 0; k < bluY.length; k++)  {
    BySum = BySum + bluY[k];
  }
  
  //divides by the length to get the average y position of that color
  int yAvg = ySum/yellY.length;
  int yBavg = BySum/bluY.length;  
  
  P2Y = yBavg;
  P1Y = yAvg;
  //println(yBavg);

}