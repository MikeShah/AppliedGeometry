#include <SDL2/SDL.h>
#include <iostream>

int main(int argc, char* argv[]){

    if(SDL_Init(SDL_INIT_VIDEO) !=0){
        std::cout << "Failed to start sdl!\n";
        return 1;
    }

    SDL_Window* window=nullptr;
    window = SDL_CreateWindow("title",
                              20,20,
                              640,480,
                              SDL_WINDOW_SHOWN);

    SDL_Renderer* renderer=nullptr;
    renderer = SDL_CreateRenderer(window,-1,0);

    // Infinite loop    
    bool isRunning=true;
    while(isRunning){
        SDL_Event e;
        // Event handling loop
        while(SDL_PollEvent(&e)){
            // Handle any keyboard/mouse/etc.
            if(e.type == SDL_QUIT){
                isRunning = false;
            }
        }
        
        // Clear our renderer to a black background
        SDL_SetRenderDrawColor(renderer,0,0,0,SDL_ALPHA_OPAQUE);
        SDL_RenderClear(renderer);

        // Draw a point
        SDL_SetRenderDrawColor(renderer,255,0,0,SDL_ALPHA_OPAQUE);
        for(int x = 50; x < 100; x++){
            SDL_RenderDrawPoint(renderer, x,50);
        }

    
        // Clearing the render of our graphics
        SDL_RenderPresent(renderer);
    }

    SDL_Quit();

    return 0;
}
