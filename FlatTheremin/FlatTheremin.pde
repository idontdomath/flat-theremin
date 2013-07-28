//flat.theremin
//Apache License Version 2.0, January 2004 (MIT) - see LICENSE for details

//Copyright (c) 2013 Martin Ramos Mejia
//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies for the Maxim Library.
//Processing.js is licensed under the MIT License, see LICENSE.

//Resources:
//sinewave900hz.wav sample from freesound.org (http://www.freesound.org/people/mjscox/sounds/174407/)
//sine wave example from processing 2+ documentation

Maxim maxim;
AudioPlayer player;
boolean  started;

void setup()
{
  size(640, 480);
  maxim = new Maxim(this);
  
  //once the player is started it will loop and generate different sounds
  //based on the changes of speed and volume.
  player = maxim.loadFile("sinewave900hz.wav");
  player.setLooping(true);

  //we will the display the title scene when the program starts
  started = false;
  
  //white background
  background(255,255,255);

}

/**
 * Draws a sine wave formed by vertical lines from an starting position
 * x,y and with parameters that manage the amplitude and period.
 */
void drawSineWave(float x, float y, float period, float amplitude) {

  float arc = 0.0;
  float inc = TWO_PI / (period * 25);
  
  for(int i=x; i < width; i=i+4) {
    line(i, y, i, y + sin(arc) * (amplitude * 50));
    arc = arc + inc;
  }
  
}

/**
 * Draws the title scene, with instructions to start.
 */
void titleScene() {
    
    //we fill the background each frame to update the alpha value
    //of the text
    background(255,255,255);
    
    textSize(18);
    //alpha ratio to make a minimal effect on the text opacity
    //based on the mouse position
    alphaFactor = (mouseX*10/mouseY*10+1)+50;
    
    String s = "flat.theremin.v.0.1. click on the screen to start.";
    
    fill(102,102,108,alphaFactor);
    text(s, 10, height-20);

}

/*
 * Draws to sine wave supperposed on x to gain a moebius strip effect
 * starting position x,y, color, opacity and period and amplitude can be customized.
 */
void drawTranslatedSineWave(float x, float y, int r, int g, int b, float alpha, float period, float amplitude) {
  
  pushMatrix();
  
  stroke(r,g,b,alpha);
  drawSineWave(x, y, period, amplitude);
  translate(20, 0);
  drawSineWave(x, y, period, amplitude);
  
  popMatrix();

}

/**
 * Main interaction loop
 * updates audio values and sine waves based on the mouse position.
 */
void mainLoop() {
  
  //we update the speed and volume values based on the mouse position
  float speedRatio = (float) mouseX / (float) width;
  float volumeRatio = (float) mouseY / (float) height;
  speedRatio *= 2;
  volumeRatio *= 2;
    
  player.speed(speedRatio);
  player.volume(volumeRatio);
  
  //we fill the background each frame to update based on the interaction
  background(255,255,255);
  
  //green wave
  drawTranslatedSineWave(0, height/4, 100, 146, 37, 80, speedRatio*2, volumeRatio);
  //brown wave
  drawTranslatedSineWave(0, height/2, 100, 46, 37, 90, speedRatio*2, volumeRatio);
  //red wave
  drawTranslatedSineWave(0, 3 * height/4, 230, 46, 37, 90, speedRatio*2, volumeRatio);
}

void draw() {
  
  if (!started) {
    //draw the title scene, with start instructions
    titleScene();
  }
  else {
    //run the mainloop of the flat theremin
    mainLoop();
  }
  
}

void mousePressed() {

  //start loop playback
  player.cue(0);
  player.play();
  
  //change flag for interaction start
  started = true;
  
}

