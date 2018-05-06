# Homework 3

This thing is about evaluating an arithmetic expression stored in a binary tree.

The evaluation should be done with recursive functions, because the focus of this homework is recursion.

## Requirements

Our tree is implemented as a vector, where the first half contains the intermediate nodes, and the second half the leaves.

The tree has these requirements:

- The 1st node is the length-1 of the array;
- The **root** is at index `1`;
- For each node at position `i`:
  - The left child is at index `2i`;
  - The right child is at index `2i+1`.
- Every **null** node contains `-666`;
- **Operations** are encoded in **intermediate nodes** as this:
  - **\***: `-1`;
  - **+**: `-2`;
  - **-**:  `-3`;
  - **^**: `-4`;
- Note that values of operations can appear in leaves.

It is worth to note that if the height is `h`, the leaves at level `i < h` have **two empty children**.

So, a node is a **leave** if:

- Its children don't exist;
- Its children have value `-666`.

```
        *
      /   \
    +      -
   / \    /  \
 3    *  7    -
    /  \     / \
   5    8   6   9
```

So, in this case we would have this vector:

`15,*,+,-,3,*,7,-,NULL,NULL,5,8,NULL,NULL,6,9`.

That more specifically is:

`15,-1,-2,-3,3,-1,7,-3,-666,-666,5,8,-666,-666,6,9.`

So, if we want to be tedious, this should be our low-level tree:

```
          -1
      /       \
    -2         -3
   / \        /  \
 3    -1     7   -3
/ \  / \    / \  / \
n n  5  8   n n  6  9
```

For graphical reasons, let's pretend that `n = -666`.

---

## Function 1: print the expression

Given the vector's address, it should print the arithmetic expression, following these rules:

- Each value is surrounded with brackets;
- After the expression there is a line return `\n`.

As an example, if the tree is the one we have just seen, the function should print:

`(((3)+((5)*(8)))*((7)-((6)-(9))))`.

### Algorithm idea

A simple tree traversal should do the trick:

1. Open a parentheses whenever we go down the tree;
2. If we find a leave, print its value and close its parentheses;
3. After a backtract to an intermediate node, decide whether to close the parentheses:
   - If the right child has **not been visited** --> don't close;
   - If every child has already been **visited **--> close.

## Function 2: resolve a step and modify the tree

Given the vector's address, it should resolve **one step** of the expression, following these rules:

- Replace the operators that have numeric children, with the result of that operation;
- Mark the evaluated children with `-666`.

For example, after a call our tree should become:

```
          -1
      /       \
    -2         -3
   / \        /  \
 3   40     7    -3
/ \  / \    / \  / \
n n  n  n   n n  n  n
```

`15,-1,-2,-3,3,40,7,-3,-666,-666,-666,-666,-666,-666,-666,-666`

### Algorithm idea

Maybe a modified traversal:

1. For each node that is not a leaf, traverse into it;
2. If both children are leaves:
   1. Compute the operation;
   2. Write the result to the parent;
   3. Set the leaves to `-666`;
   4. Return.

---

## What to do

Write a MIPS program that:

- Defines the two recursive functions;
- Defines the `main` procedure, that:
  1. Reads the number of items `N`; 
  2. Stores it in `vector[0]`;
  3. Reads the next `N` items and stores them in the vector;
  4. Prints the output of the function 1;
  5. While the tree is not reduced to a single numeric node:
     1. Call function 2;
     2. Print output of function 1.
  6. Exit.

## Example

Given this input:

```
15               # N, numero di elementi dell'albero da leggere
-1               # operatore *, radice dell'albero
-2               # operatore +
-3               # operatore -
3                # valore foglia 3
-1               # operatore *
7                # valore foglia 7
-3               # operatore -
-666             # nodo vuoto
-666             # nodo vuoto
5                # valore foglia 5
8                # valore foglia 8
-666             # nodo vuoto
-666             # nodo vuoto
6                # valore foglia 6
9                # valore foglia 9
```

The output should be:

```
(((3)+((5)*(8)))*((7)-((6)-(9))))
(((3)+(40))*((7)-(-3)))
((43)*(10))
(430)
```