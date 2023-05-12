#include <iostream>
#include <vector>

struct Vertex{
    float x;
    float y;
};


// Entry point into program
int main(){

//    std::vector<int> v1 = {1,2,3};
    std::vector<int> v1;
    v1.push_back(1);
    v1.push_back(2);
    v1.push_back(3);

    for(int i=0; i < v1.size(); ++i){
        // Prefer to use .at when just accessing
        // elements, so you get bounds checking
        std::cout << v1.at(i) << std::endl;
    }


    std::vector<Vertex> vertices;
    Vertex vertex1;
    vertex1.x = 5;
    vertex1.y = 6;

    vertices.push_back(vertex1);
    for(int i=0; i < vertices.size(); ++i){
        std::cout << vertices[i].x 
                  << "," 
                  << vertices[i].y
                  << std::endl;
    }



    std::cout << "hello geometry!" << std::endl;

    return 0;
}
