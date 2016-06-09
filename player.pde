
import ddf.minim.*;
Minim minim;
AudioPlayer player;
CircularP c;
boolean rec;

void setup() {
  size(1200, 700, P3D);
  minim = new Minim(this);
  c = new CircularP();  
  player = minim.loadFile("myeggs.mp3");
}

void draw() {  
  background(22);
  stroke(255);
  translate(width/2, height/2);
  c.show();
  if ( player.isPlaying() ) {
    //saveFrame("Player_####.png");
    rect(10-width/2, 20-height/2, 4, 10);
    rect(16-width/2, 20-height/2, 4, 10);
  } else
  {
    beginShape();
    vertex(10-width/2, 20-height/2);
    vertex(10-width/2, 28-height/2);
    vertex(18-width/2, 24-height/2);
    endShape();
  }
  float sprog = map(player.position(), 0, player.length(), -width/2, width/2);
  stroke(360, 255, 255);
  strokeWeight(5);
  line(sprog, -height/2, sprog, 20-height/2);
}

void mousePressed() {
  int position = int( map( mouseX, 0, width, 0, player.length() ) );
  player.cue( position );
}

class CircularP {
  float mag;
  float st;
  Starf [] starf;
  CircularP() {
    starf = new Starf[600];
    for (int w = 0; w < starf.length; w++ ) {
      starf[w] = new Starf();
    }
  }
  void show() {
    showVel();
    for (int i = 0; i < starf.length; i++) {
      starf[i].show();
      starf[i].update(st);
    }
    for (int i = 0; i < player.bufferSize() - 1; i++) {    
      float i2 = i;
      PVector pos1 = new PVector(sin(i2/12), cos(i2/12));      
      PVector pos2 = new PVector(sin((i2+1)/12), cos((i2+1)/12));
      pos1.add(circ(i, pos1));
      pos2.add(circ((i+1), pos2));
      float hu =  map(moneitor(i), 0, 250, 0, 255);
      float alph = map(moneitor(i), 0, 250, 70, 255);
      colorMode(HSB, 255);
      stroke(hu, 255, 255, alph);
      float sw = map(moneitor(i), 0, 250, 0.1, 6.5);
      strokeWeight(sw);
      line( pos1.x, pos1.y, pos2.x, pos2.y  );
    }
  }
  PVector circ(int i, PVector pos) {
    PVector center = new PVector (0, 0);
    pos.sub(center);
    pos.normalize();
    pos.setMag(moneitor(i));
    return pos;
  }
  float moneitor(int i) {
    float l = player.left.get(i);
    float r = player.right.get(i);
    return ((l+r)/2)*(150+mag)+35;
  }
  void showVel() {  
    float prom = 0;
    for (int i = 0; i < player.bufferSize() - 1; i++) { 
      prom += ((player.left.get(i) + player.right.get(i))/2)*100;
    }
    prom = prom/player.bufferSize();
    st = abs(prom)*9.5;
    mag = abs(prom)*6;
  }
}
class Starf {
  float x;
  float y;
  float z;
  float pz;
  float sw;

  Starf() {
    x = random(-width/2, width/2);
    y = random(-height/2, height/2);
    z = random(width);
  }
  void update(float sp) {
    sw = sp;
    z = z - (9+sp);
    if (z < 1) {
      z =random(width);
      x = random(-width/2, width/2);
      y = random(-height, height);
      pz = z;
    }
  }
  void show() {

    float sx = map(x/z, 0, 1, 0, width);
    float sy = map(y/z, 0, 1, 0, height);
    float st = map(z, 0, width, 4, 0)+ map(sw, 10, 60, -.5, .9);
    float px = map(x/pz, 0, 1, 0, width);
    float py = map(y/pz, 0, 1, 0, height);
    pz = z;
    stroke(255);    
    strokeWeight(st);    

    line(px, py, sx, sy);
  }
}
void keyPressed()
{
  if ( player.isPlaying() )
  {
    player.pause();
    rec = false;
  }
  // if the player is at the end of the file,
  // we have to rewind it before telling it to play again
  else if ( player.position() == player.length() )
  {
    player.rewind();
    player.play();
  } else
  {
    player.play();
    rec = true;
  }
}