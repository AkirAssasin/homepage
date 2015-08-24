ArrayList nodes;
float tsize = 20;

void setup() {
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    nodes = new ArrayList();
    textAlign(CENTER,CENTER);
    nodes.add(new Node("Darkrix"));
    nodes.add(new Node("NetStruction"));
    nodes.add(new Node("Bell of Souls"));
    nodes.add(new Node("Hexyl"));
    nodes.add(new Node("Floodgate Dungeon"));
    nodes.add(new Node("Faction Master"));
    nodes.add(new Node("Home"));
}

 

Number.prototype.between = function (min, max) {
    return this > min && this < max;
};




void draw() {
    background(255);
    for (int i=nodes.size()-1; i>=0; i--) {
        Particle n = (Node) nodes.get(i);
        n.update();
    }
}

void mouseClicked() {
    
}




class Node {
    float x;
    float y;
    float r;
    float orir;
    float dr;
    boolean toMove = true;
    color c;
    String t;

    Node(ot) {
        t = ot;
        orir = t.length()*tsize/2;
        r = orir;
        dr = orir;
        x = random(orir,width - orir);
        y = random(orir,height - orir);
        c = color(random(150,230),random(150,230),random(150,230));
    };

    

    void update() {
        toMove = true;
        for (int i=nodes.size()-1; i>=0; i--) {
          Particle n = (Node) nodes.get(i);
          if (dist(n.x,n.y,x,y) <= (orir + n.orir)) {
            x += (x - n.x)/100;
            y += (y - n.y)/100;
            toMove = false;
          }
        }
        if (dist(r,0,dr,0) < 1) {
            dr = random(orir/2,orir);
            if (toMove = true) {
              x += (width/2 - x)/100;
              y += (height/2 - y)/100;
            }
        } else {r += (dr - r)/10;}
        fill(c);
        stroke(c);
        ellipse(x,y,r,r);
        fill(0,0);
        ellipse(x,y,orir*3/2,orir*3/2);
        fill(255 - red(c),255 - green(c),255 - blue(c));
        textSize(tsize);
        if (dist(mouseX,mouseY,x,y) <= orir*3/2) {text(t,x,y);}
    }
}
