//Brandon Pugnet, Trang Le, Chirag Nijjer
//Lab 6

//imports
import processing.sound.*;
import processing.video.*;

//video class
Capture video;

//Sound variables
SoundFile edgebounce;
SoundFile paddlebounce;
SoundFile victory;
SoundFile pointscored;

//state of each frame
int state = 0;

//Paddle-related variables
float xPaddle1; //x position of paddle1 at start
float yPaddle1; //y position of paddle 1 at start
float xPaddle2;
float yPaddle2;
float pW1; //width of paddle
float pW2;
float pLen1; //length of paddle 1
float pLen2; //length of paddle 2
int pSpeed = 5; //paddle speed

//Player naming variable;
String player1 = "";
String player2 = "";


//Object-related variables
float size; //dimension of the objects
float xO; //x position of object
float yO; //y positions of object
float xSpeed = 3; //horizontal movement increment
float ySpeed = 3; //vertical movement increment


//Background-related variables
int r = 50;//initial shade of red

//Score-related variables
int score1 = 0;
int score2 = 0; //score1 counter
int miss1 = 0;
int miss2 = 0; //miss counter


//Video-related Variables
color yTarget;
color bTarget;
float threshold = 50; 

float P2Y = 0;
float P1Y = 0;

//Stuff for the highscore board
//String [] alph = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
//int numstate = 1;
//int letstate = 1;
int playcounter = 5; //number of times played
int [] timearray = new int [100]; //array of the time played
int [] timearray2 = new int [100]; // a copy of the array
String [] playernameArray = new String [100]; //array of player names
String [] playernameArray2 = new String [100]; //copy of the array
int t1;//starting minute
int t2;//starting second
int t3;//ending minute
int t4;//ending second
int t5;//minute subtract
int t6;//second subtract
int ttot;//total time

int moveshift;//changes the side the object goes after a point
int record;//1 if recording is on, 0 if it is off



void setup () {
  size(640, 480);

  //fullScreen();
  //set length of paddles
  pLen1 = pLen2 = height*0.2; 
  //set width of paddles
  pW1 = pW2 = 15;
  //set default midpoint of paddles
  //set corner of the paddles
  xPaddle1 = width/20;
  yPaddle1 = height*0.3;
  xPaddle2 = 19*width/20;
  yPaddle2 = height*0.3;


  //initial x position of the object
  xO = width/2;
  //randomize the starting y position of the object
  yO =  random(height/15+size/2, height-size/2);
  size = width/25; // set the size of objects

  //Load the audio files
  edgebounce = new SoundFile(this, "edgebounce.mp3");
  paddlebounce = new SoundFile(this, "paddlebounce.mp3");
  victory = new SoundFile(this, "victory.mp3");
  pointscored = new SoundFile(this, "pointscored.mp3");
 
  //Video 
  video = new Capture(this, 640, 480);
  video.start(); 
  bTarget = color(0, 0, 100);
  yTarget = color(200, 200, 0);
  
  //time array initial conditions
  timearray[0] = 1000;
  timearray[1] = 2000;
  timearray[2] = 3000;
  timearray[3] = 4000;
  timearray[4] = 5000;
  timearray2[0] = 1000;
  timearray2[1] = 2000;
  timearray2[2] = 3000;
  timearray2[3] = 4000;
  timearray2[4] = 5000;
  
  //player name array initial conditions
  playernameArray[0] = "---";
  playernameArray[1] = "---";
  playernameArray[2] = "---";
  playernameArray[3] = "---";
  playernameArray[4] = "---";
  playernameArray2[0] = "---";
  playernameArray2[1] = "---";
  playernameArray2[2] = "---";
  playernameArray2[3] = "---";
  playernameArray2[4] = "---";
}

void captureEvent(Capture video) {
  video.read();
}

void draw () {

  //game modes to choose on instruction screen
  if (mousePressed) { 
    //click "SINGLE PLAYER" button to enter single player mode or "TWO PLAYERS" button to enter two player modes
    if (state == 0) {
      if (mouseX > width/4 && mouseX < width/4+width/6 && mouseY> 3.75*height/5 && mouseY < 3.75*height/5+height/15) {
        state = 1;
      }
      if (mouseX > 3*width/4-width/6 && mouseX < 3*width/4 && mouseY > 3.75*height/5 && mouseY < 3.75*height/5+height/15) {
        state = 2;
      }
    }
    //click "START" button to start the game in two players mode or click "BACK" to return to the instruction screen
    if (state == 2) {
      if (mouseX > width/4 && mouseX < width/4+width/6 && mouseY> 3*height/5 && mouseY < 3*height/5+height/15) {
        state = 0;
      }
      if (mouseX > 3*width/4-width/6 && mouseX < 3*width/4 && mouseY > 3*height/5 && mouseY < 3*height/5+height/15) {
        state = 3;
      }
    }
  }

  //INSTRUCTIONS display
  if (state == 0) {
    background(r, 0, 0);
    
    //Textual instructions
    textAlign(CENTER, CENTER);
    stroke (255);
    String s = "INSTRUCTIONS";
    String i = "This is a renovated version of the classic Pong game."
      + " To play the game, you will use a colored dice as the paddle controller by moving it vertically."
      + " Your webcam needs to be accessible for the computer to read the dice position." 
      + " In Single Player mode, you will play against the computer using the blue dice." 
      + " In the Two Players mode, Player 1 will control the left paddle using the yellow dice, and Player 2 will control the right paddle using the blue dice.";
    textSize(width/40);
    text (s, width/2.7, height/40, width/4, height/4);
    textAlign(BASELINE);
    textSize(width/45);
    text(i, width/4, height/5, width/2, height/2);
    text("Should this be recorded? If yes press BACKSPACE, If not press DELETE", width/4, 4.25*height/5);
    text("For 1 Player click the button or press ENTER", width/4, 4.5*height/5);
    text("For 2 Player click the button or press TAB", width/4, 4.75*height/5);
    

    //Mode buttons
    
    //single player button
    textAlign(CENTER, CENTER);
    fill(150);
    stroke(0);
    rect(width/4, 3.75*height/5, width/6, height/15);
    fill(255);
    text("SINGLE PLAYER", width/4+width/12, 3.75*height/5+height/30);
    
    //two players button
    fill(150);
    stroke(0);
    rect(3*width/4-width/6, 3.75*height/5, width/6, height/15);
    fill(255);
    text("TWO PLAYERS", 3*width/4-width/6+width/12, 3.75*height/5+height/30);
    
    //records time before play
    t1 = minute();
    t2 = second();
  }



  //SINGLE PLAYER MODE
  if (state == 1) {
    background (r, 0, 0);
    //scoreboard zone
    stroke(0);
    fill(0);
    rect(0, 0, width, height/10);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(width/35);
    player1 = "COMPUTER";
    text(player1 + ": " + score1, width/9, height/20);
    text("PLAYER: " + score2, 8*width/9, height/20);

    //SINGLE PLAYER display functions
    drawPaddle1();
    movePaddle1Automatically();
    drawPaddle2();
    findDice();
    movePaddle2();
    drawObject();
    ObjectMovementAndScoreIncrement();
    //scoreIncrement();
    playInGameSoundEffect();
    
    //records tims affter play
    t3 = minute();
    t4 = second();
    
    //saves the frames to a new directory called vid so it can be put into movie maker to make a video
    //The game does slow down a bit if this is uncommented due to the large amount of data processed
    if(record == 1){
      saveFrame("vid/pong_#######.png");
    }
  }

  if (state == 2) {

    //Naming space
    background(0);
    textAlign(LEFT, CENTER);
    textSize(width/35);
    text("Enter name for PLAYER 1: " + player1, width/3, 2*height/5);
    text("Enter name for PLAYER 2: " + player2, width/3, 2.5*height/5);
    text("Place your mouse in front of the semi-colon and type your name.", width/12, 1.5*height/5);
    text("Press the Start button or click ENTER to proceed.", width/8, 4*height/5);
    text("Press the Back button or click DELETE go back to the start screen.", width/25, 4.5*height/5);
 
    
    
    ////Update name for PLAYER 1
    ////textAlign(TOP);
    //fill(255);
    //stroke(0);
    //rect(width/2, 2*height/5, width/3, 42);
    //fill(0);
    //text(player1, width/2, 2*height/5, width/3, 42);
    ////Update name for PLAYER 2
    //fill(255);
    //stroke(0);
    //rect(width/2, 2.5*height/5, width/3, 42);
    //text(player2, width/2, 2.5*height/5, width/3, 42);
    //start button
    
    //Back and start buttons
    textAlign(CENTER, CENTER);
    fill(150);
    stroke(0);
    rect(width/4, 3*height/5, width/6, height/15);
    fill(255);
    text("BACK", width/4, 3*height/5, width/6, height/15);
    fill(150);
    stroke(0);
    rect(3*width/4-width/6, 3*height/5, width/6, height/15);
    fill(255);
    text("START", 3*width/4-width/6+width/12, 3*height/5+height/30);
    
    //records start time
    t1 = minute();
    t2 = second();
  }

  //TWO PLAYERS MODE
  if (state == 3) {
    background(r, 0, 0);
    
    //scoreboard zone
    stroke(0);
    fill(0);
    rect(0, 0, width, height/10);
    
    //scores display
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(width/35);
    
    //Players' names display
    if (player1 == "") {
      text("PLAYER 1: " + score1, width/9, height/20);
      player1 = "PLAYER 1";
    } else text(player1 + ": " + score1, width/9, height/20);
    if (player2 == "") {
      text("PLAYER 2: " + score2, 8*width/9, height/20);
      player2 = "PLAYER 2";
    } else text(player2 + ": " + score2, 8*width/9, height/20);

    //TWO PLAYERS display
    drawPaddle1();
    drawPaddle2();
    movePaddle1();
    movePaddle2();
    findDice();
    drawObject();
    println(P2Y);
    ObjectMovementAndScoreIncrement();
    //scoreIncrement();
    playInGameSoundEffect();
    
    //records ending time
    t3 = minute();
    t4 = second();
    
    //saves the frames to a new directory called vid so it can be put into movie maker to make a video
    //The game does slow down a bit due to the large amount of data processed
    if (record == 1){
      saveFrame("vid/pong_#######.png");
    }
  }

  //VICTORY screen
  if (state == 4) {
    //finds the total seconds
    t5 = (t3-t1)*60;
    t6 = t4-t2;
    if (t6 < 0){
      t6 = 60 + t6;
    }
    ttot = t5+t6;
    timearray[playcounter] = ttot;
    timearray2[playcounter] = ttot;
    
    //plays the sound and displays who won
    playVictorySoundEffect();
    background(50, 0, 50);
    
    //rectangle for button to go to see highscores
    fill(255,0,0);
    rect(.7*width,0,.3*width,.3*height);
    fill(255);
    text("See", .8*width,.1*height);
    text("Highscores", .8*width, .2*height);
    text("Click the button or hit TAB to see the Highscores.", 300,9*height/10);
    
    //all the conditions for who won and their placement in the array
    if (score1 == 21) {
      if (player1 == "") {
        text("PLAYER 1 won!", width/2, height/2);
        playernameArray[playcounter] = "Player 1";
        playernameArray2[playcounter] = "Player 1";
      } else if (player1.equals("COMPUTER"))
      {
        text("COMPUTER won!", width/2, height/2);
        playernameArray[playcounter] = "Computer";
        playernameArray2[playcounter] = "Computer";
      } else text(player1 + " won!", width/2, height/2);
        playernameArray[playcounter] = player1;
        playernameArray2[playcounter] = player1;
    } 
    if (score2 == 21) {
      if (player2 == "") {
        text("PLAYER 2 won!", width/2, height/2);
        playernameArray[playcounter] = "Player 2";
        playernameArray2[playcounter] = "Player 2";
      } else text(player2 + " won!", width/2, height/2);
        playernameArray[playcounter] = player2;
        playernameArray2[playcounter] = player2;
    }
    if(mousePressed == true && pmouseX >= .7*width && pmouseX <= width && pmouseY >= 0 && pmouseY <= .3*height){
      state = 5;
    }
  }
  
  if(state == 5){
    background(0);
    //Sorted arrays based on lowest time first
    int[] s = TimeOrder(playernameArray, timearray);
    String[] n = NamesOrder(playernameArray2, timearray2);
    //s = sort(s);
    fill(255);
    
    //Displays the top five scores
    text("Best times completed (seconds):", 350, 100);
    //text(playernameArray[playcounter] + " ", 400, 400);
    text(s[0], 200, 180);
    text(n[0], 300, 180);
    text(s[1], 200, 240);
    text(n[1], 300, 240);
    text(s[2], 200, 300);
    text(n[2], 300, 300);
    text(s[3], 200, 360);
    text(n[3], 300, 360);
    text(s[4], 200, 420);
    text(n[4], 300, 420);
    fill(255,0,0);
    rect(.7*width,.7*height,.3*width,.3*height);
    fill(255);
    text("Play", .8*width, .8*height);
    text("Again", .8*width, .9*height);
    text("Click the button or press ENTER to go back to the start menu.", 300, 20);
    
    //button to go back to the beginning
    if(mousePressed == true && pmouseX >= .7*width && pmouseX <= width && pmouseY >= .7*height && pmouseY <= height){
      score1 = 0;
      score2 = 0;
      playcounter++;//appends the playcounter to move to the next slot in the array
      state = 0;
    }
  }
}




void keyPressed() {
  //allow players to enter name in TWO PLAYERS mode
  //Allows player to set the recording settings
  
  if (state == 2) {
    if (mouseX > width/2 && mouseX <= width/2+width/3 && mouseY >= 2*height/5-20 && mouseY <= 2*height/5+20) {
      //hitting "delete"/"backspace" erases the latest character
      if ((key == DELETE || key == BACKSPACE) && player1.length() > 0) {
        player1 = player1.substring(0, player1.length()-1);
      } else player1 = player1 + key;
    } 
    if (mouseX > width/2 && mouseX <= width/2+width/3 && mouseY >= 2.5*height/5-20 && mouseY <= 2.5*height/5+20) {
      if ((key == DELETE || key == BACKSPACE) && player2.length() > 0) {
        player2 = player2.substring(0, player2.length()-1);
      } else player2 = player2 + key;
    }
    
    if(key == ENTER){
      state = 3;
    }
    if (key == DELETE){
      state = 0;
    }
  }
  
  //From instructions to the player settings
  if(state == 0){
    if (key == ENTER){
      state = 1;
    }
    if(key == TAB){
      state = 2;
    }
    if(key == BACKSPACE){
      record = 1;
    }
    if(key == DELETE){
      record = 0;
    }
  }
  
  if(state == 4){
    if(key == TAB){
      state = 5;
    }
  }
  
  if(state == 5){
    if(key == ENTER){
      score1 = 0;
      score2 = 0;
      playcounter++;
      state = 0;
    }
  }
      
}



//Make Paddle 1 automatic in single player mode
void movePaddle1Automatically() {
  if (yO < yPaddle1+pLen1/2) {
    yPaddle1 -= pSpeed;
  } else if (yO > yPaddle1+pLen1/2) {
    yPaddle1 += pSpeed;
  }
}

//Draw paddles in two-player mode
void drawPaddle1() { 
  stroke(255);
  fill(255);
  rect(xPaddle1, yPaddle1, pW1, pLen1);
}

void drawPaddle2() { 
  stroke(255);
  fill(255);
  rect(xPaddle2, yPaddle2, pW2, pLen2);
}

//Move paddles in two-player mode
void movePaddle1() {
  if (P1Y < yPaddle1+pLen1/2) {
    yPaddle1 -= pSpeed;
  } else if (P1Y > yPaddle1+pLen1/2) {
    yPaddle1 += pSpeed;
  }
}
void movePaddle2() {
  if (P2Y < yPaddle2+pLen2/2) {
    yPaddle2 -= pSpeed;
  } else if (P2Y > yPaddle2+pLen2/2) {
    yPaddle2 += pSpeed;
  }
}


//Draw object
void drawObject() {
  stroke(255);
  fill(255);
  ellipse (xO, yO, size, size);
} 

//Move object
void ObjectMovementAndScoreIncrement() {
  
  //initial move to the right
  if(score1 == 0 && score2 == 0){
    xO += xSpeed;
    yO += ySpeed;
  }
  
  //changes where the object moves depending on who scored the point
  if(moveshift == 1){
    xO += xSpeed;
    yO += ySpeed;
  }
  if(moveshift == 2){
    xO -= xSpeed;
    yO += ySpeed;
  }
  
  //ends the game after 21
  if (score1 == 21 || score2 == 21) {
    state = 4;
  }
  
  //Paddle bounce
  if ((xO <= xPaddle1+pW1+size/2 && yO>= yPaddle1 && yO<= yPaddle1+pLen1) || (xO >= xPaddle2-size/2 && yO >= yPaddle2 && yO <= yPaddle2+pLen2)) {
    if (xSpeed > 0){
      xSpeed = (xSpeed + 0.3)*(-1);
    } else if (xSpeed < 0) {
      xSpeed = abs(xSpeed) + 0.3;
    }
    ySpeed += 0.3;
  } 
  
  //Edge bounce
  if ((yO > height-size/2) || (yO < height/10+size/2)) {
    ySpeed *= -1;
  }
  
  //Reposition and score increment
  if (xO > xPaddle2){
    xO = width/2;
    yO = random(height/15+size/2+30, height-size/2-30);
    score1++;
    xSpeed = 3;
    ySpeed = 3;
    pointscored.play();
    moveshift = 1;
  }
  if (xO < xPaddle1+pW1) {
    xO = width/2;
    yO = random(height/15+size/2+30, height-size/2-30);
    score2++;
    xSpeed = 3;
    ySpeed = 3;
    pointscored.play();
    moveshift = 2;
  }
}

//void scoreIncrement() {
//  if (xO >= width) {
//    score1++;
//    xSpeed++;
//    ySpeed++;
//  }
//  if (xO <= 0) {
//    score2++;
//    xSpeed++;
//    ySpeed++;
//  }
//  if (score1 == 21 || score2 == 21) {
//    state = 4;
//  }
//}

void playInGameSoundEffect() {
  //Play sound when the ball hits the paddles
  if ((xO <= xPaddle1+pW1+size/2 && yO >= yPaddle1 && yO <= yPaddle1+pLen1) || (xO >= xPaddle2-size/2 && yO >= yPaddle2 && yO <= yPaddle2+pLen2)) {
    paddlebounce.play();
  }
  //Play sound when the ball hits the edges
  if ((yO > height-size/2) || (yO < height/10+size/2)) {
    edgebounce.play();
  }
}

void playVictorySoundEffect() {
  victory.play();
  
}

//returns an ordered time array
int[] TimeOrder(String [] names, int [] time) {
  
  //it moves the names and times played in parallel based on their indices
  int[] newtime = new int[playcounter+1];
  arrayCopy(time, 0, newtime, 0, playcounter+1);
  
  boolean swapped = true;
  
  while (swapped) {
    swapped = false;
    for (int i = 0; i < playcounter; i++) {
      if(newtime[i] == newtime[i+1]){
        newtime[i] = newtime[i];
        newtime[i+1] = newtime[i+1];
      }
      if (newtime[i] < newtime[i+1]) {
        int temp = newtime[i];
        String slot = names[i];
        newtime[i] = newtime[i+1];
        newtime[i+1] = temp;
        names[i] = names[i+1];
        names[i+1] = slot;
        swapped = true;
      }
    }
  }
  println(reverse(newtime));
  return reverse(newtime);
}

//pretty much same function as above but returns the names
String[] NamesOrder(String [] names, int [] time) {
  
  //moves these in parallel based on their indices
  int[] newtime = new int[playcounter+1];
  String[] newnames = new String[playcounter+1];
  arrayCopy(time, 0, newtime, 0, playcounter+1);
  arrayCopy(names, 0, newnames, 0, playcounter+1);
  
  boolean swapped = true;
  
  while (swapped) {
    swapped = false;
    for (int i = 0; i < playcounter; i++) {
      if (newtime[i] < newtime[i+1]) {
        int temp = newtime[i];
        String slot = names[i];
        newtime[i] = newtime[i+1];
        newtime[i+1] = temp;
        newnames[i] = newnames[i+1];
        newnames[i+1] = slot;
        swapped = true;
      }
    }
  }
  println(reverse(newnames)); 
  return reverse(newnames);
}