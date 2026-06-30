import std.random;

// Third-party libraries
import bindbc.sdl;

Random rnd;
shared static this(){
	auto rnd = Random(42);
}

struct Sprite{

	SDL_Texture* mTexture;
	SDL_FRect     mRectangle;
	int xDirection=1;
	int yDirection=1;

	this(SDL_Renderer* renderer, string bitmapFilePath){
		import std.string; // for toZString
		// Create a texture
		SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
		mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
		SDL_DestroySurface(mSurface);
		// Position the rectangle 
		mRectangle.x = 50;
		mRectangle.y = 50;
		mRectangle.w = 20;
		mRectangle.h = 20;

		// Randomize initial directions
		xDirection = (uniform(-1,2,rnd) > 0) ? 1 : -1;		
		yDirection = (uniform(-1,2,rnd) > 0) ? 1 : -1;		

	}

	// Destroy anything 'heap' allocated.
	// Remember, SDL is a C library, thus heap allocated resources need
	// to be destroyed
	~this(){
		SDL_DestroyTexture(mTexture);
	}

	void Input(){}
	void Update(){
				
				if(mRectangle.x > 620){xDirection=-1;}
				if(mRectangle.x < 0){xDirection=1;}
				if(mRectangle.y > 460){yDirection=-1;}
				if(mRectangle.y < 0){yDirection=1;}
			
				mRectangle.x = mRectangle.x+ xDirection;
				mRectangle.y = mRectangle.y+ yDirection;
	}

	void Render(SDL_Renderer* renderer){
        // Color for the rectangles
        SDL_SetRenderDrawColor(renderer, 0xFF,0x00,0x00,0xFF);
        // Render the rectangle aroound our sprite
        SDL_RenderRect(renderer, &mRectangle);

				// Copy a texture (or portion of a texture) to another
				// portion of video memory (i.e. a 2D grid of texels 
				// which span the width and height of the window)
				SDL_RenderTexture(renderer,mTexture,null,&mRectangle);
	}

	void SetPosition(int x, int y){
		mRectangle.x = x;
		mRectangle.y = y;
	}
}
