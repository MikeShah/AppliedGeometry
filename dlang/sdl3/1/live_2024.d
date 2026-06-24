// live_2024.d
import std.stdio;

struct Point{
	float x,y;

	this(float x, float y){
		this.x = x;
		this.y = y;
	}

}

void main(){

	// Hello world!
	writeln("Hello world");

	// Working with a custom data type
	writeln("===== Points =======\n");
	Point p = Point(3.1f, 2.5f);

	writeln(p);

	// A dynamic array of 'points'
	writeln("===== Dynamic Arrays =======\n");
	Point[] points;

	points ~= p;
	points ~= Point(5.6, 7.7);

	writeln(points);

	foreach(idx, point ; points){
		writeln(idx,":",point);
	}

	// Dictionaries
	// key = string
	// value = Point
	writeln("===== Dictionary =======\n");
	Point[string] namedPoints;

	namedPoints["origin"] = Point(0.0f,0.0f);	
	namedPoints["x-axis"] = Point(1.0f,0.0f);	
	namedPoints["y-axis"] = Point(0.0f,1.0f);	

	writeln(namedPoints["origin"]);

	foreach(key, value ; namedPoints){
		writeln(key);
		writeln(value);
	}


}
