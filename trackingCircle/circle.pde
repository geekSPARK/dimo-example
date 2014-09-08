/* 
  PROCESSINGJS.COM - BASIC EXAMPLE
  Delayed Mouse Tracking  
  MIT License - Hyper-Metrix.com/F1LT3R
  Native Processing compatible 
*/  

// Global variables
class Config {
  float radius;
  int X, Y, nX, nY;
  int delay;
  int backgroundRedrawFlag;
  int bgHeight, bgWidth;

  Config( r, d, h, w ) {
    radius = r;
    delay=d;
    X=0; 
    Y=0;
    nX=0;
    nY=0;
    backgroundRedrawFlag=0;
    bgHeight=h;
    bgWidth=w;
  }
}

config = new Config( 50.0, 16, 1680, 1050);
int flag=0;

/* @pjs preload="dsc_0085a.jpg"; */
PImage b;

// Setup the Processing Canvas
void setup(){
  size( 1680, 1050 );

  strokeWeight( 4 );
  frameRate( 15 );

  config.X = width / 2;
  config.Y = width / 2;
  config.nX = config.X;
  config.nY = config.Y;
  
  b = loadImage("dsc_0085a.jpg");
}

// Main draw loop
void draw(){

  if (config.backgroundRedrawFlag==0) image(b, 0, 0, config.bgHeight, config.bgWidth);
  config.backgroundRedrawFlag=1;

  rgb=poll();
  config.nX = rgb.blue.x;
  config.nY = rgb.blue.y;

  // radius = radius + sin( frameCount / 4 ); // throbbing effect
  // Smoothly change radius based on the distance between the red and green coordinates
  delta = sin(sqrt( 
    abs(rgb.red.x - rgb.green.x) * abs(rgb.red.x - rgb.green.x)
    + abs(rgb.red.y - rgb.green.y) * abs(rgb.red.y - rgb.green.y)
  ) ) * 8;

  config.radius = config.radius + delta;
  // keep radius within some sane bounds
  if ( config.radius < 0 ) { config.radius = 10; }

  // Track circle to new destination
  config.X+=(config.nX-config.X)/config.delay;
  config.Y+=(config.nY-config.Y)/config.delay;
  
  // Fill canvas grey
  // background( 100 );

  clr = frameCount % 255; // throbbing effect
  noStroke();
  fill( clr, 255-clr, (128+clr)%255, 150);
  ellipse( config.X, config.Y, config.radius+40, config.radius+40 );

  // Set fill-color to blue
  fill( 255-clr, clr, (300+clr)%255, 150);

  // Set stroke-color white
  stroke(255); 

  // Draw circle
  ellipse( config.X, config.Y, config.radius, config.radius );

  if ( config.radius > 100 ) { 
    config.radius = 100; 
    stroke(0);
    strokeWeight(2);
    fill( 255, 255, 255, 200);
    ellipse( config.X, config.Y, config.radius+20, config.radius-30 );
    noStroke();
    fill( 155, 155, 155, 200);
    ellipse( config.X, config.Y, config.radius-65, config.radius-65 );
    fill( 0, 0, 0, 200);
    ellipse( config.X, config.Y, config.radius-80, config.radius-80 );
    strokeWeight(10);
  }


}


// Set circle's next destination
void mouseMoved(){
  config.nX = mouseX;
  config.nY = mouseY;  
}
