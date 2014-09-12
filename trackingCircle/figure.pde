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
int x=0;
float clr=100;

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
  centroid = abs(rgb.red.x - rgb.green.x) * abs(rgb.red.x - rgb.green.x)
           + abs(rgb.red.y - rgb.green.y) * abs(rgb.red.y - rgb.green.y);

  delta = sin(sqrt( 
    abs(rgb.red.x - rgb.green.x) * abs(rgb.red.x - rgb.green.x)
    + abs(rgb.red.y - rgb.green.y) * abs(rgb.red.y - rgb.green.y)
  ) ) * 8;

  config.radius = config.radius + delta;
  // keep radius within some sane bounds
  if ( config.radius < 10 ) { config.radius = random(config.radius); }
  if ( config.radius > 200 ) { config.radius = random(config.radius); }

  // Track circle to new destination
  config.X+=(config.nX-config.X)/config.delay;
  config.Y+=(config.nY-config.Y)/config.delay;

  // Fill canvas black
  background( 0 );

  int rand = floor(random(0,55));

  r = 200+floor(rand);
  g = 200+floor(rand);
  b = 200+floor(rand);

  //if (rand==0) {
     //r = clr;
  //}
  //if (rand==1) {
    //g = clr;
  //}
  //if (rand==2) {
     //b = clr;
  //}

  drawLines(rgb, frameCount%255);

  noStroke();
  drawCircle(rgb.green, r,g,0);
  drawCircle(rgb.red, 0,g,b);
  drawCircle(rgb.blue, r,0,b);

  Poin centerpoint = calccentroid(rgb);
  drawBisectors(centerpoint, rgb, clr);
}

double distance(p1,p2) {
  float dx=p1.x - p2.x;
  float dy=p1.y - p2.y;
  dx=dx*dx;
  dy=dy*dy;
  return sqrt(dx+dy);
}

Poin midpoint(p1,p2) {
  float dx=(p1.x - p2.x)/2;
  float dy=(p1.y - p2.y)/2;
  return new Poin(p2.x + dx, p2.y + dy);
}

// double triangleArea(p1,p2,p3) { return abs( (p1.x*(p2.y - p3.y) + p2.x*(p3.y - p1.y) + p3.x*(p1.y-p2.y))/2); }
// double triangleHeight(rgb) { return 2*triangleArea(p1,p2,p3) / distance(rgb.red, rgb.blue); }

class Poin {
    float x, y;
    Poin(float x1, float y1) {
       x=x1;
       y=y1;
    }
    float X() { return x; }
    float Y() { return y; }
}

Poin calccentroid(rgb) {
  float x = (1/3)*(rgb.red.x + rgb.green.x + rgb.blue.x);
  float y = (1/3)*(rgb.red.y + rgb.green.y + rgb.blue.y);
  return new Poin( x, y );
}

void drawCircle(centerpoint, r, g, b) {

  fill(r, g, b, 250);

  ellipse( centerpoint.x, centerpoint.y, config.radius+40, config.radius+40 );
}

void drawBigCircle(Poin centerpoint, float rad, int clr) {
  noStroke();
  fill( 255-clr, clr, (128-clr)%255, 150);
  ellipse( centerpoint.x, centerpoint.y, rad, rad);
}

void drawBisectors(Poin centerpoint, rgb, int clr) {
  stroke(frameCount%255, (64+frameCount)%255, (128+frameCount)%255, 255);
  strokeWeight( noise(frameCount)*14 );
  line(rgb.red.x, rgb.red.y, centerpoint.x, centerpoint.y);
  line(rgb.blue.x, rgb.blue.y, centerpoint.x, centerpoint.y);
  line(rgb.green.x, rgb.green.y, centerpoint.x, centerpoint.y);
}

void drawLines(points, clr) {
  stroke((64+frameCount)%255, (128+frameCount)%255, frameCount%255, 255);
  strokeWeight( noise(frameCount)*14 );

  line(points.red.x, points.red.y, points.blue.x, points.blue.y);

  line(points.blue.x, points.blue.y, points.green.x, points.green.y);

  line(points.green.x, points.green.y, points.red.x, points.red.y);
}
