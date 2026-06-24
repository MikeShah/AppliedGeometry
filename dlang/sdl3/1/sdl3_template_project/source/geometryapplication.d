module geometryapplication;
// Import D standard libraries
import std.stdio, std.string;

// Third-party libraries
import bindbc.sdl;

// Import our SDL Abstraction
import sdl_abstraction;
import sprite;

struct GeometryApplication{
		SDL_Window* mWindow = null;
		SDL_Renderer* mRenderer = null;
		bool mGameIsRunning = true;

		// Game Data
		Sprite[15] mySprites;

		// Constructor
		this(string title){
				// Create an SDL window
				mWindow = SDL_CreateWindow(title.toStringz, 640, 480, SDL_WINDOW_ALWAYS_ON_TOP);

				// Create a hardware accelerated mRenderer
				mRenderer = SDL_CreateRenderer(mWindow,null);
				// Load the bitmap surface

				import std.random;
				auto rnd = Random(42);
				for(size_t i=0; i < mySprites.length; ++i){
					mySprites[i] = Sprite(mRenderer,"./assets/images/test.bmp");
					auto randx = uniform(0, 620, rnd);
					auto randy = uniform(0, 460, rnd);
					mySprites[i].SetPosition(randx,randy);
				}
		}

		// Destructor
		~this(){
				// Destroy our renderer
				SDL_DestroyRenderer(mRenderer);
				// Destroy our window
				SDL_DestroyWindow(mWindow);
		}

		// Handle input
		void Input(){
				SDL_Event event;
				// Start our event loop
				while(SDL_PollEvent(&event)){
						// Handle each specific event
						if(event.type == SDL_EVENT_QUIT){
								mGameIsRunning= false;
						}
				}
			for(size_t i=0; i < mySprites.length; ++i){
				mySprites[i].Input();
			}
		}

		void Update(){
			for(size_t i=0; i < mySprites.length; ++i){
				mySprites[i].Update();
			}
		}

		void Render(){
				// Set the render draw color 
				SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(mRenderer);

				for(size_t i=0; i < mySprites.length; ++i){
					mySprites[i].Render(mRenderer);
				}

				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(mRenderer);
		}

		// Advance world one frame at a time
		void AdvanceFrame(){
        SDL_Delay(16);  // Delay 16 milliseconds to approximate a 60 FPS game loop
				Input();
				Update();
				Render();
		}

		void RunLoop(){
				// Main application loop
				while(mGameIsRunning){
						AdvanceFrame();	
				}
		}
}
