package com.fortym2.hw3;

public class Main {

    static final int MUL = -1;
    static final int ADD = -2;
    static final int SUB = -3;
    static final int POW = -4;
    static final int EMPTY = -666;

    static final String OPEN_BRACKET = "(";
    static final String CLOSE_BRACKET = ")";

    static int n;
    static int[] v;

    public static void main(String[] args) {
        n = 15;
        v = new int[] {15,-1,-2,-3,3,-1,7,-3,-666,-666,5,8,-666,-666,6,9};

        printExpression(1);
        System.out.println();

        while (!(v[2] == EMPTY && v[3] == EMPTY)) {
            nextStep(1);
            printExpression(1);
            System.out.println();
        }

        System.out.println();
    }

    static void printExpression(int index) {
        System.out.print(OPEN_BRACKET);
        if (isLeaf(index)) {
            System.out.print(v[index] + CLOSE_BRACKET);
            return;
        }

        int left = getLeftChildIndex(index);
        int right = getRightChildIndex(index);

        printExpression(left);
        printOperation(index);
        printExpression(right);

        System.out.print(CLOSE_BRACKET);
    }

    static void nextStep(int index) {
        int left = getLeftChildIndex(index);
        int right = getRightChildIndex(index);

        if (left <= n && right <= n) {
            if (isLeaf(left) && isLeaf(right)) {
                doOperation(index, left, right);
                return;
            }
        }

        nextStep(left);
        nextStep(right);
    }

    static int getLeftChildIndex(int index) {
        return 2*index;
    }

    static int getLeftChild(int index) {
        int i = getLeftChildIndex(index);
        return i >= n ? EMPTY : v[i];
    }

    static int getRightChildIndex(int index) {
        return getLeftChildIndex(index)+1;
    }

    static int getRightChild(int index) {
        int i = getRightChildIndex(index);
        return i >= n ? EMPTY : v[i];
    }

    static boolean isLeaf(int index) {
        boolean emptyChildren = getLeftChild(index) == EMPTY && getRightChild(index) == EMPTY;
        boolean noChildren = getLeftChildIndex(index) > n || getRightChildIndex(index) > n;
        return emptyChildren || noChildren;
    }

    static void printOperation(int index) {
        int op = v[index];
        char prettyOp = ' ';
        switch (op) {
            case MUL:
                prettyOp = '*';
                break;
            case ADD:
                prettyOp = '+';
                break;
            case SUB:
                prettyOp = '-';
                break;
            case POW:
                prettyOp = '^';
                break;
        }
        System.out.print(prettyOp);
    }

    static void doOperation(int opIndex, int n1Index, int n2Index) {
        switch (v[opIndex]) {
            case MUL:
                v[opIndex] = v[n1Index] * v[n2Index];
                break;
            case ADD:
                v[opIndex] = v[n1Index] + v[n2Index];
                break;
            case SUB:
                v[opIndex] = v[n1Index] - v[n2Index];
                break;
            case POW:
                v[opIndex] = v[n1Index] ^ v[n2Index];
                break;
        }
        v[n1Index] = EMPTY;
        v[n2Index] = EMPTY;
    }
}
