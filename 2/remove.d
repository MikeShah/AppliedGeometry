// remove.d
import std.algorithm;
import std.stdio;

void main(){
    
    // Create a new array
    auto arr = [10,20,30,40,50];
    
    // Remove the '3rd' index (i.e. '40')
    auto newThing = arr.remove(3);

    // Observe 'arr' looks like garbage
    writeln(arr);
    // Instead, we allocate in the 'newThing' array
    // which holds the properly sized array
    writeln(newThing);

    // Why this strange behavior?
    // Remove is trying to be optimal
}


