import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

 
import processing.serial.*; 
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import ddf.minim.*;

Minim minim;
AudioPlayer player;
PFont font;

 
Serial port;  // Create object from Serial class
int val;      // Data received from the serial port 
void setup() {
  photo =loadImage("piano.jpg");
  font = loadFont("Gabriola-48.vlw");
   minim = new Minim(this);
   player = minim.loadFile("got.mp3");
  port = new Serial(this, Serial.list()[0], 9600); 
  size(600, 800);
  pTiles = new boolean[4][725 / blockSize + 1];
  for (int i = 0; i < 725 / blockSize + 1; i++) {
    int t = int(random(0, 4));
    for (int j = 0; j < 4; j++) {
      if (j == t) {
        pTiles[j][i] = true;
      } else {
        pTiles[j][i] = false;
      }
    }
  }
}

int blockSize = 125;
boolean[][] pTiles;
int flag=0;
int score = 0;
int highScore = 0;
boolean record = false;
float time = 20;
float startTime = 0;
PImage photo;
float penalty = 0;


int status = 0;//0=not start 1=start 2=over

void draw() {
  if (0 < port.available()) {  // If data is available to read,
    val = port.read();            // read it and store it in val
  println(val);
   control();
   }
  if (flag==0)
  {
    startScreen();
    
  }
  if (flag==1){
  background(255);
  fill(255);
  rect(100, 725, 100, 25);
  rect(200, 725, 100, 25);
  rect(300, 725, 100, 25);
  rect(400, 725, 100, 25);
  textAlign(CENTER);
  textSize(14);
  fill(0);
  text("D", 150, 743);
  text("F", 250, 743);
  text("J", 350, 743);
  text("K", 450, 743);

  line(100, 0, 100, 725);
  line(200, 0, 200, 725);
  line(300, 0, 300, 725);
  line(400, 0, 400, 725);
  line(500, 0, 500, 725);

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 725/blockSize+1; j++) {
      if (pTiles[i][j]) {
        fill(128);
      } else {
        noFill();
      }
      rect(i *100 + 100, 725 - blockSize - j*blockSize, 100, blockSize);
    }
  }

  fill(0);

  textSize(18);
  text(score, 550, 750);
  if(record){
    fill(255,0,0);
  }else{
    fill(128);
  }
  text(highScore,550,725);

    //text("-10", 50, 750);
  fill(0);
  

  if(status == 0){
    text(time,50,750);
    rect(30,50,40,675);
  }else if(status == 1){
    text((startTime + time * 1000 -millis())/1000,50,750);
    rect(30,50 + 675 - 675 * ((startTime + time * 1000 -millis())/1000) / time,40,675 * ((startTime + time * 1000 -millis())/1000) / time);
    if(startTime + time * 1000 -millis() <= 0){
      status = 2;
      if(highScore < score){
        record = true;
        highScore = score;
      }
    }
  }else if(status == 2){
    text("over",50,750);
    text("please press Space Key to Reset",width / 2, height - 19);
  }
  
  }
}
void control()
{
   if(status!=2){
  if(val>20 && val<48 || val>52)//ldr
  {
     rect(100, 725, 100, 25);
      pushTile(0);
  }
  if(val==50){ //pir motion sensor
    rect(200, 725, 100, 25);
      pushTile(1);
  }
      if (val==51) {//potentiometer
      rect(300, 725, 100, 25);
      pushTile(2);
    }
    if (val == 49 ) {//push button
      rect(400, 725, 100, 25);
      pushTile(3);
    }
   }
  }


void keyPressed() {
  fill(0, 50);
  
  
  if (key == ' ') {
    reset();
   }
   if(status!=2){
   if(key == 's' || key=='S'){
     flag=1;
   }
  if ( player.isPlaying() )
  {
    player.play();
  }
  // if the player is at the end of the file,
  // we have to rewind it before telling it to play again
  else if ( player.position() == player.length() )
  {
    player.rewind();
    player.play();
  }
  else
  {
    player.play();
  }
 }
}

void pushTile(int n) {
  if (status == 0) {
    status = 1;
    startTime = millis();
  }
  if (pTiles[n][0]) {
    step();
    score++;
  } else {
    background(255, 0, 0);
    score -= 10;
    penalty = millis() + 2000;
  }
}

void step() {
  for (int i = 1; i < 725 / blockSize + 1; i++) {
    for (int j = 0; j < 4; j++) {
      pTiles[j][i-1] = pTiles[j][i];
    }
  }
  int t = int(random(0, 4));
  for (int j = 0; j < 4; j++) {
    if (j == t) {
      pTiles[j][725 / blockSize] = true;
    } else {
      pTiles[j][725 / blockSize] = false;
    }
  }
}
void startScreen(){
  
  background(80,50,120);
  fill(255);
  image(photo,0,0,600,800);
  textAlign(CENTER,TOP);
  textSize(100);
  fill(0,0,0);
  textFont(font, 130);
  text("PIANO SYNC", 300, 43);
  textSize(40);
  textAlign(CENTER, TOP);
  text("\n \n \n \n \n Press s to start",300,443);
}

void reset() {
  score = 0;
  status = 0;
  record = false;
  for (int i = 0; i < 725 / blockSize + 1; i++) {
    int t = int(random(0, 4));
    for (int j = 0; j < 4; j++) {
      if (j == t) {
        pTiles[j][i] = true;
      } else {
        pTiles[j][i] = false;
      }
    }
  }
}
