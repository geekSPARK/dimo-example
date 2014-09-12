// All Examples Written by Casey Reas and Ben Fry

// unless otherwise stated.

// center point

float centerX = 0, centerY = 0;



float radius = 45, rotAngle = -90;

float accelX, accelY;

float springing = .0085, damping = .90;



//corner nodes

int nodes = 5;

float nodeStartX[] = new float[nodes];

float nodeStartY[] = new float[nodes];

float[]nodeX = new float[nodes];

float[]nodeY = new float[nodes];

float[]angle = new float[nodes];

float[]frequency = new float[nodes];



// soft-body dynamics

float organicConstant = 1;

int clrR =Math.random()*11;
int clrG =Math.random()*101;
int clrB =Math.random()*201;

void setup() {

  size(1680, 1050);

  //center shape in window

  centerX = width/2;

  centerY = height/2;

  // iniitalize frequencies for corner nodes

  for (int i=0; i<nodes; i++){

    frequency[i] = random(5, 12);

  }

  noStroke();

  smooth();

  frameRate(30);

}



void draw() {

  //fade background

  fill(0, 100);

  rect(0,0,width, height);

  rgb = poll();
  area = abs(rgb.red.x*(rgb.blue.y - rgb.green.y) +rgb.blue.x*(rgb.green.y - rgb.red.y) + rgb.green.x*(rgb.red.y - rgb.blue.y))/2;

  drawShape(area);
  moveShape(rgb);

}


void drawShape(area) {

  //  calculate node  starting locations

  for (int i=0; i<nodes; i++){

    nodeStartX[i] = centerX+cos(radians(rotAngle))*(sqrt(area));

    nodeStartY[i] = centerY+sin(radians(rotAngle))*(sqrt(area));

    rotAngle += 360.0/nodes;

  }

  // draw polygon

  curveTightness(organicConstant);

  clrR = (clrR + 1.51) % 255;
  clrG = (clrG + 1.51) % 255;
  clrB = (clrB + 1.51) % 255;

  fill(clrR, clrG, clrB, 190);

  beginShape();

  for (int i=0; i<nodes; i++){

    curveVertex(nodeX[i], nodeY[i]);

  }

  for (int i=0; i<nodes-1; i++){

    curveVertex(nodeX[i], nodeY[i]);

  }

  endShape(CLOSE);

}



void moveShape(rgb) {

  //move center point

  mx = (rgb.red.x + rgb.blue.x + rgb.green.x )/3;
  my = (rgb.red.y + rgb.blue.y + rgb.green.y )/3;

  float deltaX = mx-centerX;

  float deltaY = my-centerY;

  // create springing effect

  deltaX *= springing;

  deltaY *= springing;

  accelX += deltaX;

  accelY += deltaY;

  // move predator's center

  centerX += accelX;

  centerY += accelY;

  // slow down springing

  accelX *= damping;

  accelY *= damping;

  // change curve tightness

  organicConstant = 1-((abs(accelX)+abs(accelY))*.1);

  //move nodes

  for (int i=0; i<nodes; i++){

    nodeX[i] = nodeStartX[i]+sin(radians(angle[i]))*(accelX*2);

    nodeY[i] = nodeStartY[i]+sin(radians(angle[i]))*(accelY*2);

    angle[i]+=frequency[i];

  }

}
