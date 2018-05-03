#include <stdio.h>
#include <malloc.h>
#include <stdbool.h>

#define MUL (-1)
#define ADD (-2)
#define SUB (-3)
#define POW (-4)
#define EMPTY (-666)

int main() {
    int n;
    printf("How many items?");
    scanf("%d", &n);
    int v[n];
    v[0] = n;

    // Populate the array
    for (int i=1; i<n; i++) {
        printf("Next integer: ");
        scanf("%d", &v[i]);
    }

    return 0;
}

void printExpression(int* v) {

}

int getLeftChildIndex(int index) {
    return 2*index;
}

int getLeftChild(int* v, int index) {
    return v[getLeftChildIndex(index)];
}

int getRightChildIndex(int index) {
    return getLeftChildIndex(index)+1;
}

int getRightChild(int* v, int index) {
    return v[getRightChildIndex(index)];
}

bool isLeaf(int* v, int index) {
    return v[getLeftChild(v, index)] == EMPTY && v[getRightChild(v, index)] == EMPTY;
}