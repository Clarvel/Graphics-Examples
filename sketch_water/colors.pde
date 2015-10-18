// colors.set("str", new color(255));
// colors.get("str");
IntDict colors = new IntDict(); 

int setAlpha(int c, int a){
    if(a > 255){
        a=255;
    }else if(a < 0){
        a=0;
    }
    c = (c << 8) >> 8; // clear color's old alpha value
    a = a << 24; // move a to proper position in int
    c = a | c;
    return c;
}

color BLACK = color(  0,  0,  0);
color WHITE = color(255,255,255);
color GRAY = color(128,128,128);

color RED = color(255,0,0, 255);
color LIME = color(0,255,0);
color BLUE = color(0,0,255);

color YELLOW = color(255,255,0);
color CYAN = color(0,255,255);
color MAGENTA = color(255,0,255);

color MAROON = color(128,0,0);
color GREEN = color(0,128,0);
color NAVY = color(0,0,128);

color OLIVE = color(128,128,0);
color TEAL = color(0,128,128);
color PURPLE = color(128,0,128);

color BROWN = color(165,42,42);
color ORANGE = color(255,165,0);
color VIOLET = color(238,130,238);
color PINK = color(255,192,203);
color GOLD = color(255,215,0);
color SILVER = color(192,192,192);