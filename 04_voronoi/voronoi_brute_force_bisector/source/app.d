/// Run with: 'dub'

// Import D standard libraries
import std.stdio, std.string, std.math, std.random;

// From the 'common library in the root of this repository
import util;

// Load the SDL library
import bindbc.sdl;
import sdl_abstraction;

struct Graph{
 Vertex[]   vertices;
 Edge[]     edges; 
}

struct Vertex{
  float x,y;
}

struct Edge{
  ulong startIndex;
  ulong endIndex;
}

struct VoronoiGraph{
  VoronoiVertex[] voronoiVertices;
  VoronoiEdge[]   voronoiEdges;
}

struct VoronoiVertex{
  float x,y;
}
struct VoronoiEdge{
  // TODO
}

struct VoronoiSite{
  int x,y;
  ubyte r,g,b;
}


// Visual representation of a 'graph'
void DrawGraph(SDL_Renderer* renderer, Graph g){
  foreach(e ; g.edges){
      // Retrieve the vertex index from the edge structure
      Vertex a = g.vertices[e.startIndex];
      Vertex b = g.vertices[e.endIndex];

      SDL_SetRenderDrawColor(renderer, 0xFF, 0x00, 0x00 , 0xFF);
      SDL_RenderLine(renderer, a.x, a.y, b.x, b.y);
  }

  // Note I draw some adjacent points to make them 'larger
  foreach(v ; g.vertices){
      SDL_SetRenderDrawColor(renderer, 0xFF, 0xFF, 0xFF , 0xFF);
      SDL_RenderPoint(renderer, v.x,v.y);
      SDL_RenderPoint(renderer, v.x+1,v.y);
      SDL_RenderPoint(renderer, v.x+1,v.y+1);
      SDL_RenderPoint(renderer, v.x,v.y+1);
  }
}


/// Draw circumcircle and also generates a new 'Voronoi Graph' with the resulting edges and voronoi vertices
VoronoiGraph DrawCircumCircles(SDL_Renderer* renderer, Graph g){
  VoronoiGraph result;

  for(int i=0; i < g.vertices.length; i++){
    for(int j=0; j < g.vertices.length; j++){
      for(int k=0; k < g.vertices.length; k++){
        if(i==j || i==k || j== k){ continue; }
        Point2f a = Point2f(g.vertices[i].x, g.vertices[i].y);
        Point2f b = Point2f(g.vertices[j].x, g.vertices[j].y);
        Point2f c = Point2f(g.vertices[k].x, g.vertices[k].y);

        Circle cir = ComputeCircumCircle(a,b,c);

        // Now one more inner loop to see if any points fall within the 'unique circle'
        bool uniqueCircle = true;
        Point2f testVert;
        // Test to make sure we have a unique circle
        for(int m = 0; m < g.vertices.length; m++){
          if(m == i || m == j || m == k){ continue;  }
          
          // Abort if we find any other points that fall in our circle that make up the triangle
          testVert = Point2f(g.vertices[m].x, g.vertices[m].y);
          if(PointInCircle(cir,testVert)){ 
            uniqueCircle = false;  
            break;
          }  
        }
        // If we do have a unique circle, add the 'center' as a voronoi vertex
        // Then also 
        if(uniqueCircle){
            // Add the voronoi vertex
            result.voronoiVertices~= VoronoiVertex(cir.center.x, cir.center.y);
            // Render the voronoi vertex
            RenderCircle(renderer, Circle(cir.center,4),18, 0xFF, 0x00,0x00);

            // Render the circumcircles
            RenderCircle(renderer,cir, 180, 0x00, 0x00, 0xFF);
            // Render the bisectors
            LineSegment2f[] segments = GetBisectorsOf3Points(a,b,c);
            SDL_SetRenderDrawColor(renderer,0xFF,0xFF,0x00,0xFF);
            foreach(p ; segments){
              SDL_RenderLine(renderer, p.start.x,p.start.y, p.end.x, p.end.y);
            }
        }
      }
    }
  }

  return result;
}


void RenderCircle(SDL_Renderer* renderer, Circle c, float steps, ubyte r, ubyte g, ubyte b){
  SDL_SetRenderDrawColor(renderer,r,g,b , 0xFF);
  for(float i=0; i < steps; i+= 0.5){
    float x = c.radius * cos(i);
    float y = c.radius * sin(i);
    SDL_RenderPoint(renderer, x + c.center.x, y+c.center.y);
  }
}

/// Brute force pixel rendering of voronoi diagram
void DrawVoronoiDiagram(SDL_Renderer* renderer, VoronoiSite[] sites, int w, int h){

  for(int x=0; x < w; x++){
    for(int y=0; y < h; y++){
        
      // Of all of the sites, loop through them and find which 'point' would be closest.
      float smallestDistance = float.max;
      ulong smallestIdx;
      foreach(idx,v ; sites){
        // Compute distance between pixel and current site
        double dist = Distance(x,y, v.x, v.y);
        
        if(dist < smallestDistance){
          smallestDistance = dist;
          smallestIdx = idx;
        }
      }
      // Render the point the color of the site
      SDL_SetRenderDrawColor(renderer, sites[smallestIdx].r, sites[smallestIdx].g, sites[smallestIdx].b, 0xFF);
      SDL_RenderPoint(renderer, x,y);

    }
  }
}

// Entry point to program
void main()
{
  // Create an SDL window
  SDL_Window* window= SDL_CreateWindow("white(site)|red circle(voronoi vert)|yellow(voronoi edge)", 640, 480,  SDL_WINDOW_ALWAYS_ON_TOP);
  // Create and associate renderer with window
  SDL_Renderer* renderer = SDL_CreateRenderer(window, null);

  // Flag for determing if we are running the main application loop
  bool runApplication = true;
  // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
  //                                                but not yet released)
  bool drawing = false;
  // Initialize random number generator
  auto rnd = Random(unpredictableSeed);

  Graph g;
  VoronoiSite[] sites;  /// Mirrors the graph for visualization
  for(int i=0; i < 4; i++){
    float random_x = cast(float)uniform(0,640,rnd);
    float random_y = cast(float)uniform(0,480,rnd);

    g.vertices ~= Vertex(random_x,random_y);
    ubyte gray = cast(ubyte)uniform(32,192,rnd);
    sites ~= VoronoiSite(cast(int)random_x, cast(int)random_y, gray,gray,gray);
  }


  // Main application loop that will run until a quit event has occurred.
  // This is the 'main graphics loop'
  while(runApplication){

    SDL_SetRenderDrawColor(renderer,0x00,0x00,0x00,0xFF);
    SDL_RenderClear(renderer);

    SDL_Event e;
    // Handle events
    // Events are pushed into an 'event queue' internally in SDL, and then
    // handled one at a time within this loop for as many events have
    // been pushed into the internal SDL queue. Thus, we poll until there
    // are '0' events or a NULL event is returned.
    while(SDL_PollEvent(&e) !=0){
      if(e.type == SDL_EVENT_QUIT){
        runApplication= false;
      }
      else if(e.type == SDL_EVENT_MOUSE_BUTTON_DOWN){
        drawing=true;
        float mouseX, mouseY;
        SDL_GetMouseState(&mouseX, &mouseY);

        g.vertices ~= Vertex(mouseX,mouseY);
        ubyte gray = cast(ubyte)uniform(32,192,rnd);
        sites ~= VoronoiSite(cast(int)mouseX, cast(int)mouseY, gray,gray,gray);

        // Intentionally delay so we don't click and create too many sites in the same location
        SDL_Delay(150);
      }else if(e.type == SDL_EVENT_MOUSE_BUTTON_UP){
        drawing=false;
      }else if(e.type == SDL_EVENT_MOUSE_MOTION && drawing){
        // retrieve the position
      }
    }

    // Draws the Voronoi diagram and fills the pixels for each of the sites
    DrawVoronoiDiagram(renderer,sites, 640,480);
    // Creates the 'graph' with edges and voronoi vertices, and does more drawing.
    VoronoiGraph graph = DrawCircumCircles(renderer, g);
    // Generic function to 'draw' a graph, which would be the set of vertices/edges
    DrawGraph(renderer,g);                        

    // Present draw command and rasterize
    SDL_RenderPresent(renderer);
  }

  // Destroy our window
  SDL_DestroyWindow(window);
}
