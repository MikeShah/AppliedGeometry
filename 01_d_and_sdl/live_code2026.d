import std.stdio;

struct Point{
  float x,y;
}

void main(){

  Point p1 = Point(1.0,2.0);
  Point p2 = Point(3.0,2.0);

  Point[] convex_set = [p1,p2, Point(4,5)]; 

  writeln(p1);

  writeln(convex_set);

  // unordered map ("Associative Arrays") / dictionary, hash table
  Point[string] PointMap;

  PointMap["p1"] = p1;
  PointMap["p2"] = p2;
  
  writeln(PointMap);
  writeln(PointMap.keys);



}
