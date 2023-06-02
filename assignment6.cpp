// create a basic program that returns the old contents of x after x has been incremented by 1
#include <iostream>
using namespace std;

int main(){
    int x = 5;
    cout << x++ << endl;
    cout << x << endl;
    return 0;
}