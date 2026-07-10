/// Run with: 'dub'

// Import D standard libraries
import std.stdio, std.string, std.math, std.random;

// Load the SDL library
import bindbc.sdl;
import sdl_abstraction;

import util;


struct VoronoiSite{
  int x,y;
  ubyte r,g,b;
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
  SDL_Window* window= SDL_CreateWindow("D Voronoi Diagram", 640, 480,  SDL_WINDOW_ALWAYS_ON_TOP);
  // Create and associate renderer with window
  SDL_Renderer* renderer = SDL_CreateRenderer(window, null);

  // Flag for determing if we are running the main application loop
  bool runApplication = true;
  // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
  //                                                but not yet released)
  bool drawing = false;
  // Initialize random number generator
  auto rnd = Random(unpredictableSeed);


  VoronoiSite[] sites = [
                            VoronoiSite(10,10,255,0,0),
                            VoronoiSite(210,110,0,255,0),
                            VoronoiSite(300,300,00,0,255),
                        ];



  // Main application loop that will run until a quit event has occurred.
  // This is the 'main graphics loop'
  while(runApplication){
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
        // Initialize some random colors for the voronoi sites
        ubyte r = cast(ubyte)uniform(0,255,rnd);
        ubyte g = cast(ubyte)uniform(0,255,rnd);
        ubyte b = cast(ubyte)uniform(0,255,rnd);

        VoronoiSite v = VoronoiSite(cast(int)mouseX, cast(int)mouseY, r,g,b );
        sites ~= v;

      }else if(e.type == SDL_EVENT_MOUSE_BUTTON_UP){
        drawing=false;
      }else if(e.type == SDL_EVENT_MOUSE_MOTION && drawing){
        // retrieve the position
      }
    }

    DrawVoronoiDiagram(renderer,sites,640,480);
                        
    SDL_RenderPresent(renderer);

  }

  // Destroy our window
  SDL_DestroyWindow(window);
}
