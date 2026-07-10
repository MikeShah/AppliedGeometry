/// Mathematical utilities
module util;

// Phobos Library dependencies
import std.math, std.conv;


/// Note: Here's a little trick to try to make it easier
///       reuse a type, but give some information to the user
///       about the intent. Use the 'using' keyword 
///       (Can also use at global scope if needed everywhere)
alias Point2f = Vector2f;
alias Edge2f  = LineSegment2f;

// Standard form of a linear equation
// The form is assumed to be: "Ax + By = C" (as opposed to Ax+By+C =0)
struct StandardForm{
  float A;
  float B;
  float C;

  /// Populates A,B,C from two points
  this(Point2f a, Point2f b){
    float deltaX = b.x - a.x;
    float deltaY = b.y - a.y;

    A = deltaY;
    B = -deltaX;
    C = A * a.x + B * a.y;
  }

  /// Creates a perpendicular line at 'p' from the current Standard Form.
  ///   
  StandardForm GetPerpendicularLineAt(Point2f p){
    StandardForm perpendicularLine;
    // Flip and take the reciprocal
    perpendicularLine.A = -B;
    perpendicularLine.B = A;
    perpendicularLine.C = perpendicularLine.A * p.x + perpendicularLine.B * p.y;

    return perpendicularLine;
  }

  /// Given an x, plug into the 'slope-intercept form' (y=mx+b)
  /// and return the y value.
  /// The result is stored in the 'y' value (Point2f.y) and the 'x'
  /// value is otherwise stored in x.
  /// TODO: Need to unit test this
  Point2f SolveY(float x){
    Point2f result;
    result.x = x;   // Whatever is given
    
    float m = -A/B; // slope
    float yintercept = C/B;

    result.y = m*x + yintercept;
    return result;
  }

  /// Print a nice version of the standard form
  string toString(){
    string result; 
    result = "Ax + By = C ==> ";
    result ~= i"$(A) + $(B) = $(C)".text;
    return result; 
  }
}

struct LineSegment2f{
  Point2f start;
  Point2f end;
  this(ref LineSegment2f rhs){
    this.start = rhs.start;
    this.end   = rhs.end;
  }
}


/// Data structure for a circle
struct Circle{
  Point2f center;    // center of circle
  float   radius; // radius of circle

  this(ref Circle c){
    this.center = c.center;
    this.radius = c.radius;
  }
}



/// Vector2f for floating point in D
/// Note: In D, floats initial values are NaN -- so we make sure to initialize them.
struct Vector2f{
        
    float x=0.0f;
    float y=0.0f;

    /// Two argument constructor
    this(float _x, float _y){
        x = _x;
        y = _y;
    }

    /// Copy Constructor
    /// Not truly needed, but in general I like to implement copy constructor explicitly so you know that copies are indeed allowed
    this(ref return scope Vector2f rhs){
        x = rhs.x;
        y = rhs.y;
	}

    void Print(string text){
        import std.stdio;
        writeln(text, ": ", x, ",", y);
    }

    /// Copy assignment operator
    void opAssign(Vector2f rhs){
        if(this is rhs){
            return;
        }
        x = rhs.x;
        y = rhs.y;
    }
    /// Unary Negation operator flips sign of vector.
    void opUnary(string op)(){
		x = -x;
		y = -y;	
    }

	/// Handle cases like "+", "-", etc. doing a 
	/// member-wise operation and returning a new vector.
	Vector2f opBinary(string op)(Vector2f rhs)
	{	
    static if(op=="+" || op =="-"){
		  Vector2f result;
 		  mixin("result.x = x"~op~"rhs.x;"); 
 		  mixin("result.y = y"~op~"rhs.y;"); 
      return result;
    }
    assert(false, "illegal operator for opBinary");
	}
	/// Handle cases like "*", "/", etc. doing a 
	/// member-wise operation and returning a new Point.
	Point2f opBinary(string op)(float scalar)
	{	
    static if(op=="*" || op =="/"){
		  Vector2f result;
 		  mixin("result.x = x"~op~"scalar;"); 
 		  mixin("result.y = y"~op~"scalar;"); 
      return result;
    }
    assert(false, "illegal operator for opBinary");
	}

	/// Handle cases like "+=", "-=", etc. doing a 
	/// member-wise operation.
	void opOpAssign(string op)(Vector2F rhs)
	{
 		mixin("x "~op~"= rhs.x;"); 
 		mixin("y "~op~"= rhs.y;"); 
	}

    // Normalize
    void Normalize(){
        float len = Magnitude();
        assert(len != 0.0f && "We actually found a float that is 0 (or maybe close), uh oh!");
        x = x / len;
        y = y / len;
    }

    // Magnitude or "Length"
    float Magnitude(){
        return sqrt(x*x + y*y);	
    }
}

/// Produce a new normalized vector
/// NOTE: Since this produces a new vector,
///       the naming is 'NormalizedRetrieve'.
Vector2f NormalizedRetrieve(Vector2f v){
			Vector2f result;
			float len = v.Magnitude();
			result.x = v.x / len;
			result.y = v.y / len;

			return result;
}

/// Dot product of two Vector2's
float Dot(const ref Vector2f a, const ref Vector2f b){
    return (a.x * b.x) + (a.y * b.y);
}

/// 2D cross product (wedge product/bivector)
/// If you are in a left-handed or right-handed 
/// the resulting 'float' (being positive or negative) changes!
float Cross(const ref Vector2f a, const ref Vector2f b){
    float result = (a.x * b.y) - (a.y * b.x);
    return result; 
}

/// Linear interpoloation between a point, where 't' is a value between 0.0 and 1.0.
Point2f Lerp(Point2f a, Point2f b, float t){
  assert(t>=0 && t <= 1.0, "t should be between [0.0,1.0]");
  return a + b*t; 
}


/// Create a new midpoint from two vectors
Point2f CreateMidpoint(const ref Point2f a, const ref Point2f b){
		Point2f result;
		result.x = (a.x+b.x)/2;
		result.y = (a.y+b.y)/2;
	return result;
}

/// Compute if a point 'p2' is to the left of the segment
/// formed by a and b
int isLeft(const ref Vector2f a, const ref Vector2f b, const ref Vector2f P2 )
{
    return cast(int)( (b.x - a.x) * (P2.y - a.y) - (P2.x - a.x) * (b.y - a.y) );
}

/// Point in Triangle another strategy
bool PointInTriangle2(const ref Vector2f v, const ref Vector2f a, const ref Vector2f b, const ref Vector2f c){
	int first  = isLeft(a,b,v);	
	int second = isLeft(b,c,v);	
	int third  = isLeft(c,a,v);	

	return (first>0 && second>0 && third>0);
}

/// Point in Circle
/// Tests if a point falls within a circle.
/// Usees distance formula and radius of circle
bool PointInCircle(Circle c, Point2f p){
  return Distance(c.center, p) < c.radius;
}

/// Find the intersection of two lines
Point2f GetIntersection(StandardForm l1, StandardForm l2){
  float A1 = l1.A;
  float A2 = l2.A;
  float B1 = l1.B;
  float B2 = l2.B;
  float C1 = l1.C;
  float C2 = l2.C;

  // Cramer's Rule
  float Determinant = A1 * B2 - A2 * B1;
  float DeterminantX = C1 * B2 - C2 * B1;
  float DeterminantY = A1 * C2 - A2 * C1;

  float x = DeterminantX / Determinant;
  float y = DeterminantY / Determinant;

  return Point2f(x,y);
}

/// Takes three points, and computes their perpendicular bisectors
/// Given three points, we 'bisect' twice
LineSegment2f[] GetBisectorsOf3Points(Point2f a, Point2f b, Point2f c){
  // Compute the lines
  StandardForm lineAB = StandardForm(a,b);
  StandardForm lineAC = StandardForm(a,c);
  StandardForm lineBC = StandardForm(b,c);

  // Compute midpoints of the lines
  Point2f midpointAB = CreateMidpoint(a,b);
  Point2f midpointAC = CreateMidpoint(a,c);
  Point2f midpointBC = CreateMidpoint(b,c);

  // Get Perpendicular bisectors
  StandardForm perpendicularBisectorAB = lineAB.GetPerpendicularLineAt(midpointAB);
  StandardForm perpendicularBisectorAC = lineAC.GetPerpendicularLineAt(midpointAC);
  StandardForm perpendicularBisectorBC = lineBC.GetPerpendicularLineAt(midpointBC);

  // Figure out the radius of the circumcricle for the bisectors
  Circle cir = ComputeCircumCircle(a,b,c);

  LineSegment2f[] lineSegments;

  lineSegments ~= LineSegment2f(cir.center, midpointAB);
  lineSegments ~= LineSegment2f(cir.center, midpointAC);
  lineSegments ~= LineSegment2f(cir.center, midpointBC);

  return lineSegments; 
}



/// Given 3 points, computes the circumcircle
Circle ComputeCircumCircle(Point2f a, Point2f b, Point2f c){
  Circle result;

  // Compute the lines
  StandardForm lineAB = StandardForm(a,b);
  StandardForm lineAC = StandardForm(a,c);

  // Compute midpoints of the lines
  Point2f midpointAB = CreateMidpoint(a,b);
  Point2f midpointAC = CreateMidpoint(a,c);

  // Then create perpendicular bisector of the two lines from the midpoint
  result.center = GetIntersection(lineAB.GetPerpendicularLineAt(midpointAB), lineAC.GetPerpendicularLineAt(midpointAC));
  result.radius = Distance(result.center, a);

  return result;
}






/// Computes distance between two points
double Distance(const ref Point2f p1, const ref Point2f p2){
  return sqrt( (p1.x - p2.x)*(p1.x-p2.x) + (p1.y - p2.y)*(p1.y-p2.y));
}
/// Computes distance between two locations 
double Distance(float x1, float y1, float x2, float y2){
  return sqrt( (x1 - x2)*(x1-x2) + (y1 - y2)*(y1-y2));
}








unittest{
    Vector2f v1;
    v1.x = 1;
    v1.y = 7;
    assert(v1.x == 1 && v1.y == 7);
    
    Vector2f v2;
    v2.x = 2;
    v2.y = 2;

    v1 = v2;
    assert(v1.x == 2 && v1.y == 2);

    v1.Normalize();
}

unittest{
  Point2f p1 = Point2f(-1,3);
  Point2f p2 = Point2f(4,-2);

  StandardForm s = StandardForm(p1,p2);
  import std.stdio;
  writeln(s);

}
