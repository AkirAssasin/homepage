/* @pjs font='fonts/font.ttf' */ 

var myfont = loadFont("fonts/font.ttf"); 

ArrayList nodes;
float sx;
float sy;
boolean se = false;
float maxs;
float mins;
float cp = 100;
color bgl = color(0);

void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    nodes = new ArrayList();
    textFont(myfont);
    strokeWeight(5);
    nodes.add(new Node(width/10,width/2,height/2,color(random(150,255),random(150,255),random(150,255))));
}

 

Number.prototype.between = function (min, max) {
    return this > min && this < max;
};




void draw() {
    background(bgl);
    fill(lerpColor(bgl,255,cp/100));
    textAlign(CENTER,CENTER);
    textSize(width/7);
    text("BALANCE " + round(cp) + "%",width/2,height/2);
    textAlign(CENTER,BOTTOM);
    textSize(width/45);
    fill(255);
    text("Drag to create cell. Left click to split. Right click to kill.",width/2,height - 10);
    maxs = 0;
    mins = height;
    for (int i=nodes.size()-1; i>=0; i--) {
        Particle n = (Node) nodes.get(i);
        n.update();
        if (n.orir < mins) {mins = n.orir;} 
        if (n.orir > maxs) {maxs = n.orir;} 
    }
    cp += (round((mins/maxs)*100) - cp)/20;
    if (se) {
      fill(0,0);
      stroke(255);
      if ((sx + dist(sx,sy,mouseX,mouseY))>width||(sx - dist(sx,sy,mouseX,mouseY))<0||(sy + dist(sx,sy,mouseX,mouseY)) > height || (sy - dist(sx,sy,mouseX,mouseY)) < 0 || dist(sx,sy,mouseX,mouseY) <= 10) {
        stroke(255,0,0);
      }
      ellipse(sx,sy,dist(sx,sy,mouseX,mouseY)*2,dist(sx,sy,mouseX,mouseY)*2);
      line(sx,sy,mouseX,mouseY);
    }
}

void mousePressed() {
    if (mouseButton == LEFT) {
      for (int i=nodes.size()-1; i>=0; i--) {
          Particle n = (Node) nodes.get(i);
          n.splitc();
      }
    } else {
      for (int i=nodes.size()-1; i>=0; i--) {
          Particle n = (Node) nodes.get(i);
          if (dist(n.x,n.y,mouseX,mouseY) <= n.orir && nodes.size() > 1) {
            nodes.remove(i);
          }
      } 
    }
}


void mouseDragged() {
    if (!se) {
      sx = mouseX;
      sy = mouseY;
      se = true;
    }
}

void mouseReleased() {
    if (se) {
      if (
          (sx + dist(sx,sy,mouseX,mouseY)) < width && 
          (sx - dist(sx,sy,mouseX,mouseY)) > 0 &&
          (sy + dist(sx,sy,mouseX,mouseY)) < height &&
          (sy - dist(sx,sy,mouseX,mouseY)) > 0 && dist(sx,sy,mouseX,mouseY) > 10) {nodes.add(new Node(0,null,null,null));}
      se = false;
    }
}


class Node {
    float x;
    float y;
    float vx;
    float vy;
    float r;
    float orir;
    float dr;
    boolean toMove = true;
    color c;

    Node(or,ox,oy,oc) {
        if (or == 0) {
          orir = dist(sx,sy,mouseX,mouseY);
          x = sx;
          y = sy;
          vx = (mouseX - x)/50;
          vy = (mouseY - y)/50;
          c = color(random(150,255),random(150,255),random(150,255));
        } else {
          orir = or;
          x = ox;
          y = oy;
          c = oc;
        }
        r = orir;
        dr = orir;
    };

    void splitc() {
        if (dist(x,y,mouseX,mouseY) <= orir && orir >= 30) {
          nodes.add(new Node(orir/2,x,y,lerpColor(c,color(255),0.5)));
          orir /= 2;
          c = lerpColor(c,color(0),0.25);
        }
    }

    void update() {
        bgl = lerpColor(bgl,color(255 - red(c),255 - green(c),255 - blue(c)),0.5);
        toMove = true;
        for (int i=nodes.size()-1; i>=0; i--) {
          Particle n = (Node) nodes.get(i);
          if (dist(n.x,n.y,x,y) <= (orir + n.orir) && dist(n.x,n.y,x,y) != 0) {
            if (n.orir > orir/4) {
              vx += (x - n.x)/1000;
              vy += (y - n.y)/1000;
              x += vx;
              y += vy;
              toMove = false;
              c = lerpColor(c,n.c,0.01);
              orir = lerp(orir,n.orir,0.01);
              dr = orir/5;
            } else {
              vx += (n.x - x)/500;
              vy += (n.y - y)/500;
              if (dist(n.x,n.y,x,y) <= orir*3/4) {
                orir += n.orir*3/4;
                c = lerpColor(c,n.c,0.33);
                x = lerp(x,n.x,0.33);
                y = lerp(y,n.y,0.33);
                nodes.remove(i);
              }
            }
          }
        }
        if (toMove) {dr = orir*3/2;}
        if (x < orir) {vx = -vx; dr = orir/5; x = orir;}
        if (y < orir) {vy = -vy; dr = orir/5; y = orir;}
        if (x > (width - orir)) {vx = -vx; dr = orir/5; x = width - orir;}
        if (y > (height - orir)) {vy = -vy; dr = orir/5; y = height - orir;}
        x += vx;
        y += vy;
        vx /= 1.0001;
        vy /= 1.0001;
        if (dist(r,0,dr,0) > 1) {r += (dr - r)/10;}
        fill(c);
        stroke(c);
        ellipse(x,y,r,r);
        fill(0,0);
        ellipse(x,y,orir*2,orir*2);
    }
}
