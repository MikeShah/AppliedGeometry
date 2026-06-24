// @file: box_point2.cpp
// g++ -std=c++20 box_point2.cpp -o prog
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

// @file: box_point2.cpp
// g++ -std=c++20 box_point2.cpp -o prog
bool inRange(float value, float min, float max){
    return value >= min && value <= max;
}


bool PointInRectangle(Point p, Rect r, const char* msg){
    // Note: Screen space cooridnates put (0,0) in top-left.
    //       y-coordinate grows going downwards
    // o-------------->
    // |
    // |
    // |
    // |
    // |
    // v
    if(inRange(p.x, r.p.x, r.p.x + r.w) &&
       inRange(p.y, r.p.y, r.p.y + r.h) )
    {
        std::cout << msg;
        return true;
    }

    std::cout << "no point in rectangle\n";
    return true;
}

int main(){

    Point p1(5,10);
    Point p2(1,1);
    Point p3(21,11);
    Rect  r(Point(2,2), 20, 10);

    PointInRectangle(p1,r,"p1 in rectangle\n");
    PointInRectangle(p2,r,"p2 in rectangle\n");
    PointInRectangle(p3,r,"p3 in rectangle\n");

    return 0;
}
