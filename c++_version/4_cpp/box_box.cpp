// @file: box_box.cpp
// g++ -std=c++20 box_box.cpp -o prog
#include <iostream>

struct Point{
    Point(float _x, float _y) : x(_x), y(_y){ }
    float x,y;
};

struct Rect{
    Point p;
    float w,h;

    Rect(Point topLeft, float _w, float _h) : p(topLeft), w(_w), h(_h){ }
};

bool inRange(float value, float min, float max){
    return value >= min && value <= max;
}


// @file: box_box.cpp
// g++ -std=c++20 box_box.cpp -o prog
bool BoxBox(Rect r1, Rect r2, const char* msg){
    if(inRange(r1.p.x, r2.p.x, r1.p.x + r.w) &&
       inRange(p.y, r.p.y, r.p.y + r.h) )
    {
        std::cout << msg;
        return true;
    }

    std::cout << "no box box collision\n";
    return true;
}

int main(){

    Rect  r1(Point(2,2), 20, 10);
    Rect  r2(Point(2,10), 20, 10);
    Rect  r3(Point(12,20), 20, 10);

    BoxBox(r1,r2,"r1 and r2 intersect");
    BoxBox(r1,r3,"r1 and r3 intersect");


    return 0;
}
