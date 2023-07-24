PImage sprite;
PImage spriteKnow;
PImage spriteBad;
PImage spriteMoney;
PImage spriteBook;
final float SPEED = 10;
final float CAR_X = 100; //fixed x
float carY = 250;
final float TRACK_TOP = 100;
final float TRACK_BTM = 400;
float [] knowX = {850, 850, 850, 850, 850}; //default x position of knowledges
float [] knowY = new float[5];
float [] badX = {850, 850, 850}; //default x position of bads
float [] badY = new float[3];
float knowDist;
float badDist;
float moneyDist ;
float HealthDist ;
int lapTimer = 0;
int lapCount = 1;
int knowCount = 0;
int badCount = 0;
int timePerLap = 900;//15 seconds
int knowledge = 0;
int Wealth = 0;
int Health = 0 ;
int timePerLapRem = timePerLap ;

float [] moneyX = {850, 850, 850, 850, 850}; //default x position of knowledges
float [] moneyY = new float[5];
float [] HealthX = {950, 950, 950, 950, 950}; 
float [] HealthY = new float[5];
boolean gameStart = false;


void setup() {
  size(800, 500);
  noStroke();
  sprite = loadImage("sprite.png");
  spriteKnow = loadImage("spriteknow.png");
  spriteBad = loadImage("spritebad.png");
  spriteMoney = loadImage("spriteMoney.png");
  spriteBook = loadImage("spriteBook.png");
  
}

void draw() {
  background(0);
   if (gameStart == false) {
    openGame();
  }
    else{
  lapUpdate(); //ONLY USE THIS AFTER THE TITLE SCREEN OR ELSE THE TIMER WILL GO BEFORE THE GAME STARTS, counts laps and times them
  drawTrack(); //draws the road
  moveCar(); //moves car up or down with W and S
  restrictCar(); //keeps car on track
  drawCar(); //represents car with sprite
  moveKnow(); //moves the knowledges and gives them random positions every lap
  moveBad(); //moves the bads and gives them random positions every lap
  carCheckKnowledge(); //allows car to pick up goodies and adds to score
  carCheckBad(); //allows car to be attacked by bads and possibly decreases score
  showKnowledge(); //displays knowledge score
   moveMoney(); //Draws the money, moves the money and gives them random positions every lap
   carCheckMoney() ;
   showWealth() ; //displays the wealth score
   moveHealth(); //Draws the health, moves the health and gives them random positions every lap
   carCheckHealth() ;
   showHealth() ;
   showLapCount() ;
   levelRequirement() ;
   levelReqCheer() ;
    }
}

void openGame(){
  background(200, 0, 0);
  textSize(95);
  text("SEMESTER SPEED",15,100);
  
  textSize(50);
  text("Welcome to Semester Speed!", 40, 150);
  textSize(30);
  text("HOW TO PLAY:",20, 235);
  text("There are 15 laps, each lap equals a week",20, 270) ;
  text("Use the W and S keys to move your car up", 20, 300);
  text("and down to collect goodies and avoid baddies", 20, 335);
  text("you need to maintain a 95 knowledge and health",20,370) ;
  text("and have a wealth of not less than $400 to win",20, 400);
   text("Press Enter to start", 20, 450);
   if (key == ENTER){
   gameStart = true; 
  }
}

void lapUpdate() {
  if (lapTimer>=timePerLap) { //a lap is 15 seconds
    lapTimer=0;
    lapCount++;
  }
  lapTimer++; //program runs at 60 fps, so when this hits 60 that's one full second
}

void drawTrack() {
  fill(100);
  rect(0, TRACK_TOP, width, 300);
  fill(255);
  rect(-80, 250, 200, 10);
  rect(170, 250, 200, 10);
  rect(420, 250, 200, 10);
  rect(670, 250, 200, 10);
}

void moveCar() {
  if (keyPressed) {
    if  (key == 'w') {
      carY -= SPEED;
    } else if (key == 's') {
      carY += SPEED;
    }
  }
}

void restrictCar() { //prevents car from going off track
  if (carY < TRACK_TOP+10) {
    carY = TRACK_TOP+10;
  }

  if (carY > TRACK_BTM-25) {
    carY = TRACK_BTM-25;
  }
}

void drawCar() {
  image(sprite, CAR_X-25, carY-25);
}

/*fixed, the idea is that there are 5 knowledges
 and each one will start moving left at different points in time during the lap.
 The X positions of all of them should reset every time the lap count goes up.
 The Y positions are randomly generated each lap*/

void moveKnow() {
  for (int i = 0; i < 5; i++){
   image (spriteBook, knowX[i]-8, knowY[i]-8);
   spriteBook.resize(0,50);
  }
  //randomly assigns Y positions for each lap  

   if (lapTimer == 60){
     for (int i = 0; i < 5; i++){
       knowY[i] = random(TRACK_TOP, TRACK_BTM);
     }
     for (int i = 0; i < 5; i++){
       knowX[i] = 850;
     }
   }
  if (lapTimer > 180){ //first knowledge starts moving after 3 seconds
    knowX[0]-=SPEED; 
  }
  
  if (lapTimer > 360){ //second knowledge starts moving after 6 seconds
    knowX[1]-=SPEED; 
  }
  
  if (lapTimer > 480){ //3rd knowledge starts moving after 8 seconds
    knowX[2]-=SPEED; 
  }
  
  if (lapTimer > 540){ //4th knowledge starts moving after 9 seconds
    knowX[3]-=SPEED; 
  }
  
  if (lapTimer > 720){ //5th knowledge starts moving after 12 seconds
    knowX[4]-=SPEED; 
  }
}

void moveBad() {
  for (int i = 0; i < 3; i++){
   image(spriteBad, badX[i]-8, badY[i]-8);
  }
  //randomly assigns Y positions for each lap  

   if (lapTimer == 60){
     for (int i = 0; i < 3; i++){
       badY[i] = random(TRACK_TOP, TRACK_BTM);
     }
     for (int i = 0; i < 3; i++){
       badX[i] = 850;
     }
   }
  if (lapTimer > 270){ //first bad starts moving after 4.5 seconds
    badX[0]-=SPEED; 
  }
  
  if (lapTimer > 420){ //second bad starts moving after 7 seconds
    badX[1]-=SPEED; 
  }
  
  if (lapTimer > 600){ //3rd bad starts moving after 10 seconds
    badX[2]-=SPEED; 
  }
}

void carCheckKnowledge(){ //checks distance away from knowledge
  for (int i = 0; i < 5; i++){
    knowDist = sqrt((knowX[i] - CAR_X) * (knowX[i] - CAR_X) + (knowY [i] - carY) * (knowY [i] - carY));
    if (knowDist <= 75){
      knowX[i] = -100;
      knowY[i] = -100;
      knowledge = knowledge + 10;
    }
    if(knowledge <= 0){
       knowledge = 0 ;
    }
     if(knowledge >= 100){
       knowledge = 100 ;
    }
  }
}

void carCheckBad(){
  for (int i = 0; i < 3; i++){
    badDist = sqrt((badX[i] - CAR_X) * (badX[i] - CAR_X) + (badY [i] - carY) * (badY [i] - carY));
    if (badDist <= 75){
      badX[i] = -100;
      badY[i] = -100;
      knowledge = knowledge - 5;
      Wealth = Wealth - 5;               //reduces your wealth,Health,Knowledge
      Health = Health - 5 ; 
    }
  }
}


void showKnowledge(){
  textSize(20);
  fill(255,0,255) ;
  text("KNOWLEDGE: " + knowledge,620,25);
}

void moveMoney() {
    for (int i = 0; i < 5; i++){
  image (spriteMoney, moneyX[i]-8, moneyY[i]-8);
  spriteMoney.resize(0,50);
  }

if (lapTimer == 60){
     for (int i = 0; i < 5; i++){
       moneyY[i] = random(TRACK_TOP, TRACK_BTM);
     }
     for (int i = 0; i < 5; i++){
       moneyX[i] = 850;
     }
   }
  if (lapTimer > 250 ){ //first money starts moving after 4 seconds
    moneyX[0]-=SPEED; 
  }
  
  if (lapTimer > 380){ //second money starts moving after 6.5 seconds
    moneyX[1]-=SPEED; 
  }
  
  if (lapTimer > 540){ //3rd money starts moving after 9 seconds
    moneyX[2]-=SPEED; 
  }
  
  if (lapTimer > 600){ //4th money starts moving after 10 seconds
    moneyX[3]-=SPEED; 
  }
  
  if (lapTimer > 720){ //5th money starts moving after 12 seconds
    moneyX[4]-=SPEED; 
  }
}

void carCheckMoney(){
     for (int i = 0; i < 5; i++){
    moneyDist = sqrt((moneyX[i] - CAR_X) * (moneyX[i] - CAR_X) + (moneyY [i] - carY) * (moneyY [i] - carY));
    if (moneyDist <= 75){
      moneyX[i] = -100;
      moneyY[i] = -100;
      Wealth = Wealth + 10;
    }
    if(Wealth <= 0){
       Wealth = 0 ;
    }
  }
}

void showWealth(){
   textSize(20);
   fill(255,0,255) ;
  text("WEALTH : $ " + Wealth,620,45);
}

void moveHealth() {
    for (int i = 0; i < 5; i++){
    image (spriteKnow, HealthX[i]-8, HealthY[i]-8);
  }

if (lapTimer == 60){
     for (int i = 0; i < 5; i++){
       HealthY[i] = random(TRACK_TOP, TRACK_BTM);
     }
     for (int i = 0; i < 5; i++){
       HealthX[i] = 850;
     }
   }
  if (lapTimer > 180){ //first Health starts moving after 3 seconds
    HealthX[0]-=SPEED; 
  }
  
  if (lapTimer > 360){ //second Health starts moving after 6 seconds
    HealthX[1]-=SPEED; 
  }
  
  if (lapTimer > 480){ //3rd Health starts moving after 8 seconds
    HealthX[2]-=SPEED; 
  }
  
  if (lapTimer > 540){ //4th Health starts moving after 9 seconds
    HealthX[3]-=SPEED; 
  }
  
  if (lapTimer > 720){ //5th Health starts moving after 12 seconds
    HealthX[4]-=SPEED; 
  }
}

void carCheckHealth(){
    for (int i = 0; i < 5; i++){
    HealthDist = sqrt((HealthX[i] - CAR_X) * (HealthX[i] - CAR_X) + (HealthY [i] - carY) * (HealthY [i] - carY));
    if (HealthDist <= 75){
      HealthX[i] = -100;
      HealthY[i] = -100;
      Health = Health + 10;
    }
     if(Health <= 0){
       Health = 0 ;
    }
     if(Health >= 100){
       Health = 100 ;
    }
  }
}

void showHealth(){
   textSize(20);
   fill(255,0,255) ;
  text("HEALTH: " + Health,620,65);
}


void showLapCount() {
  textSize(20);
  fill(255, 0, 255);
  text("WEEK: " + lapCount,10, 25);
}

void levelRequirement() {
  if (Wealth >= 20 && knowledge >= 20 && Health >= 20 && lapTimer == timePerLap){
    //Wealth = 0;
    //knowledge = 0;
    //Health = 0;
} else if (lapTimer == timePerLap){
    lapCount = lapCount - 1;
  }
}
void levelReqCheer(){
  if (Wealth < 20 ||  knowledge < 20  || Health < 20){
  textSize(20);
  fill(255, 0, 255);
  text("NOT ENOUGH RESOURCES! GET MORE!",200, 40);
  } else {
  textSize(20);
  fill(255, 0, 255);
  text("GOOD JOB! KEEP IT UP!",250, 40);
  }


if(  lapCount > 15 && knowledge > 95  && Wealth > 400 && Health > 95){
     background(0) ;
     noLoop() ;
     textSize(20);
   fill(255,0,255) ;
   text("GAME OVER YOU PASSED",240,250);
  text ("SEMESTER SPEED", 590, 400);
   showHealth() ;
   showWealth() ;
   showKnowledge() ;
 }else if (  lapCount > 15 && knowledge < 95 && Wealth < 400 && Health < 95){
   background(0) ;
     noLoop();
     textSize(20);
   fill(255,0,255) ;
   text("GAME OVER YOU FAILED THE SEMESTER DUE TO LACK OF RESOURCES",30,200);
  text ("SEMESTER SPEED", 590, 400);
   showHealth() ;
   showWealth() ;
   showKnowledge() ;
  }
}
