// On linux compile with:
// g++ -std=c++17 main.cpp -o prog -lSDL2 -ldl
// On windows compile with (if using mingw)
// g++ main.cpp -o prog.exe -lmingw32 -lSDL2main -lSDL2
// On Mac compile with:
// clang++ main.cpp -I/Library/Frameworks/SDL2.framework/Headers -F/Library/Frameworks -framework SDL2

// C++ Standard Libraries
#include <iostream>
// Third Party
#if defined(LINUX) || defined(MINGW)
    #include <SDL2/SDL.h>
#else // This works for Mac
    #include <SDL.h>
#endif

#include <fstream>
#include <vector>
#include <string>

#include "Math.hpp"

// Note: Here's a little trick to try to make it easier
//       reuse a type, but give some information to the user
//       about the intent. Use the 'using' keyword 
//       (Can also use at global scope if needed everywhere)
using Point = Vector2f;

// Intersection equation
Point intersectLine(Point p0, Point p1,
                    Point p2, Point p3){

    float A1 = p1.y - p0.y;
    float B1 = p0.x - p1.x;
    float C1 = A1 * p0.x + B1*p0.y;

    float A2 = p3.y - p2.y;
    float B2 = p2.x - p3.x;
    float C2 = A2 * p2.x + B2*p2.y;

    float denominator = A1 * B2 - A2 *B1;

    if(denominator == 0){
        return Point(0,0);
    }

    float x = (B2*C1 - B1 * C2) / denominator;
    float y = (A1 * C2 - A2 * C1) / denominator;
    
    Point result(x,y);

    return result;
}


int main(int argc, char* argv[]){
    // Create a window data type
    // This pointer will point to the 
    // window that is allocated from SDL_CreateWindow
    SDL_Window* window=nullptr;

    // Initialize the video subsystem.
    // iF it returns less than 1, then an
    // error code will be received.
    if(SDL_Init(SDL_INIT_VIDEO) < 0){
        std::cout << "SDL could not be initialized: " <<
                  SDL_GetError();
    }else{
        std::cout << "SDL video system is ready to go\n";
    }
    // Request a window to be created for our platform
    // The parameters are for the title, x and y position,
    // and the width and height of the window.
    window = SDL_CreateWindow("Line Intersection",20, 20, 640,480,SDL_WINDOW_SHOWN);

    SDL_Renderer* renderer = nullptr;
    renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);
     
    // Infinite loop for our application
    bool gameIsRunning = true;

    // Main application loop
    while(gameIsRunning){
        SDL_Event event;

        // (1) Handle Input
        // Start our event loop
        while(SDL_PollEvent(&event)){
            // Handle each specific event
            if(event.type == SDL_QUIT){
                gameIsRunning= false;
            }
        }
        // (2) Handle Updates
        
        // (3) Clear and Draw the Screen
        // Gives us a clear "canvas"
        SDL_SetRenderDrawColor(renderer,0,0,0,SDL_ALPHA_OPAQUE);
        SDL_RenderClear(renderer);

        // Check if mouse is outside of any of our '3' vertices
        // in this demo.
		// Retrieve and store the mouse position in SDL
        int mousex,mousey;
        SDL_GetMouseState(&mousex,&mousey);

        Point a(mousex,mousey);
        Point b(200,100);
        Point c(400,320);
        Point d(200,350);
        Vector2f line1 = b - a;
        Vector2f line2 = d - c;
        
        SDL_SetRenderDrawColor(renderer,0,255,0,SDL_ALPHA_OPAQUE);
        SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);

        // Draw the line segment
        // Segment 1 (ab)
        SDL_RenderDrawLine(renderer,a.x,a.y,b.x,b.y);
        // Segment 2 (cd)
        SDL_RenderDrawLine(renderer,c.x,c.y,d.x,d.y);

        // Compute the intersection
        Point intersection = intersectLine(a,b,c,d);
        // Display the intersection
        SDL_Rect r;
        r.x = intersection.x;
        r.y = intersection.y;
        r.w = 10;
        r.h = 10;
        SDL_SetRenderDrawColor(renderer,255,0,0,SDL_ALPHA_OPAQUE);
        SDL_RenderDrawRect(renderer, &r);         

        // Small hack to slow down SDL
        SDL_Delay(50);
        // Finally show what we've drawn
        SDL_RenderPresent(renderer);
    }

    // We destroy our window. We are passing in the pointer
    // that points to the memory allocated by the 
    // 'SDL_CreateWindow' function. Remember, this is
    // a 'C-style' API, we don't have destructors.
    SDL_DestroyWindow(window);
    
    // our program.
    SDL_Quit();
    return 0;
}
