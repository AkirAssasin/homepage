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
boolean valids = true;
float width;
float height;
float pwidth;
float pheight;

void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    pwidth = width;
    pheight = height;
    nodes = new ArrayList();
    textFont(myfont);
    nodes.add(new Node(min(width,height)/5,width/2,height/2,color(random(150,255),random(150,255),random(150,255))));
}

 

Number.prototype.between = function (min, max) {
    return this > min && this < max;
};




void draw() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    strokeWeight(5);
    background(bgl);
    fill(lerpColor(bgl,255,cp/100));
    textAlign(CENTER,CENTER);
    if ((height - width/46) < width/5) {textSize(height - width/46);} else {textSize(width/5);}
    text("BALANCE",width/2,height/2);
    //text("BALANCE " + round(cp) + "%",width/2,height/2);
    textAlign(CENTER,BOTTOM);
    if ((height - width/46) < width/5) {textSize(20);} else {textSize(width/45);}
    fill(255);
    text("Drag to create cell. Left click to split. Right click to kill.",width/2,height - 10);
    maxs = 0;
    mins = height;
    valids = true;
    for (int i=nodes.size()-1; i>=0; i--) {
        Particle n = (Node) nodes.get(i);
        n.update();
        if (n.orir < mins) {mins = n.orir;} 
        if (n.orir > maxs) {maxs = n.orir;} 
        if (n.orir < 1) {
          nodes.remove(i);
        }
    }
    cp += (round((mins/maxs)*100) - cp)/20;
    if (se) {
      fill(0,0);
      stroke(255);
      if ((sx + dist(sx,sy,mouseX,mouseY))>width||(sx - dist(sx,sy,mouseX,mouseY))<0||(sy + dist(sx,sy,mouseX,mouseY)) > height || (sy - dist(sx,sy,mouseX,mouseY)) < 0 || dist(sx,sy,mouseX,mouseY) <= 10 || !valids) {
        stroke(255,0,0);
      }
      ellipse(sx,sy,dist(sx,sy,mouseX,mouseY)*2,dist(sx,sy,mouseX,mouseY)*2);
      line(sx,sy,mouseX,mouseY);
    }
    pwidth = width;
    pheight = height;
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
          n.kill();
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
          (sy - dist(sx,sy,mouseX,mouseY)) > 0 && dist(sx,sy,mouseX,mouseY) > 10 && valids) {nodes.add(new Node(0,null,null,null));}
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
    boolean death = false;
    float tick = 0;
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
        if (dist(x,y,mouseX,mouseY) <= orir*3/4 && orir - dist(x,y,mouseX,mouseY) >= 15) {
          nodes.add(new Node(orir - dist(x,y,mouseX,mouseY),mouseX,mouseY,lerpColor(c,color(255),0.5)));
          orir -= orir/4 - dist(x,y,mouseX,mouseY)/4;
          c = lerpColor(c,color(0),0.25);
          tick = 0;
          vx = 0;
          vy = 0;
        }
    }

    void kill() {
        if (dist(x,y,mouseX,mouseY) <= orir && nodes.size() > 1) {
          death = true;
        }
    }

    void update() {
        if (tick < 255) {tick += 1;}
        bgl = lerpColor(bgl,color(255 - red(c),255 - green(c),255 - blue(c)),0.5);
        toMove = true;
        for (int i=nodes.size()-1; i>=0; i--) {
          Particle n = (Node) nodes.get(i);
          if (dist(n.x,n.y,x,y) <= (orir + n.orir) && dist(n.x,n.y,x,y) != 0 && !n.death && !death) {
            if (n.orir > orir/2 || n.tick < 255) {
              vx += (x - n.x)/1000;
              vy += (y - n.y)/1000;
              x += vx;
              y += vy;
              toMove = false;
              c = lerpColor(c,n.c,0.03);
              //n.c = lerpColor(n.c,c,0.03);
              orir = lerp(orir,n.orir,0.015);
              dr = orir/5;
            } else {
              vx += (n.x - x)/1000;
              vy += (n.y - y)/1000;
              if (dist(n.x,n.y,x,y) <= (r - n.orir/2)) {
                orir += n.orir*3/4;
                c = lerpColor(c,n.c,0.33);
                n.death = true;
                vx = 0;
                vy = 0;
              }
            }
          }
        }
        if (toMove) {dr = orir*3/2;}
        if (x < orir) {orir -= 1; vx = -vx; dr = orir/5; x = orir;}
        if (y < orir) {orir -= 1; vy = -vy; dr = orir/5; y = orir;}
        if (x > (width - orir)) {orir -= 1; vx = -vx; dr = orir/5; x = width - orir;}
        if (y > (height - orir)) {orir -= 1; vy = -vy; dr = orir/5; y = height - orir;}
        if (death) {
          if (dist(orir,0,0,0) > 1) {orir -= orir/10;}
          dr = 0;
          vx /= 2;
          vy /= 2;
        }
        if (dist(sx,sy,mouseX,mouseY) > dist(sx,sy,x,y)) {valids = false;}
        x += vx;
        y += vy;
        x *= width/pwidth;
        y *= height/pheight;
        vx /= 1.0001;
        vy /= 1.0001;
        orir *= width/pwidth;
        orir *= height/pheight;
        r *= width/pwidth;
        r *= height/pheight;
        dr *= width/pwidth;
        dr *= height/pheight;
        if (dist(r,0,dr,0) > 1) {r += (dr - r)/10;}
        fill(c);
        stroke(c);
        ellipse(x,y,r,r);
        fill(0,0);
        ellipse(x,y,orir*2,orir*2);
    }
}
