# HW1 - Sliding Window Sequence
Given:

- A sequence `S` which length is `n`;
- A positive integer `k`.

It is possible to obtain a derivate sequence `Y` with length `n-k`. Each item at position `i` of this sequence is the sum of the items at positions `[i:i+k]` in `S`.

For example:

- k = 4;
- S = 97, 77, 51, -96, 63, 45, -23, 26, -13, -42, -30, -95, 47, -91, -12, -44, -10, 53, -31, -71;
- Y = 129, 95, 63, -11, 111, 35, -52, -59, -180, -120, -169, -151, -100, -157, -13, -32, -59.

## Notes

- `S` can't be preallocated, because its length is not determined;
- `k` must be in the interval `(0, 21)`;
- `S` must at least contain `k` integers;
- `S` must not contain `0`.

## What is asked

A MIPS assembly program that:

1. Reads `0 < k < 21`;
2. Reads `S`:
  2.1. Each item must be in one line;
  2.2. `0` is the sequence termination integer;
  2.3. Print out the next item of `Y` when you have sufficient data.
3. Print some stats:
  3.1. `min(S)`;
  3.2. `max(S)`;
  3.3. `min(Y)`;
  3.4. `max(Y)`.

## Submitting requirements

The program should be written in `exercise01.asm`, and:

- Must:
  - Start its execution from the `main:` label;
  - Terminate with the `syscall 10`.
- Mustn't:
  - Contain prompts or prints not indicated in the requirements;
  - Preallocate ~~a shitload of~~ space to contain `S`.

## Testing

Each test set is made of an *input* and an *expected* file.
Execute `java -jar Mars4_5.jar me nc sm ic exercise01.asm < input.txt > output.txt`.
Then do `diff output.txt expected.txt`.

## Execution example

**Input:**

```text
4       # k
97
77
51
-96
63
45
-23
26
-13
-42
-30
-95
47
-91
-12
-44
-10
53
-31
-71
0       # sequence end
```

**Output:**

```text
129
95
63
-11
111
35
-52
-59
-180
-120
-169
-151
-100
-157
-13
-32
-59
-96     # min of S
97      # max of S
-180    # min of Y
129     # max of Y
```

## Solution

The idea of the algorithm is to obtain `k` and loop to obtain the integers for the sequence `S`.
We can maintain a counter to compute the window and to sum its items.
When we reach a window size of `k` we can print the sum and increment the counter.
Along these operations we can store the stats in some registers.

A bit more specifically, we need:

- An array called `window` of size `k`;
- 5 registers to store sum and statistics;
- 2 registers to handle the edge cases of:
  - 1st sequence number;
  - 1st statistic.

We don't need to loop through `window` each time we need a sum, because we can maintain it by:

- adding the current integer to the sum;
- removing the first integer of the `window` when needed.

### High-Level Implementation

```java
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);

        int k = in.nextInt();
        int[] window = new int[k];
        int i = 0;

        int sum = 0;
        int minS = 0;
        int maxS = 0;
        int minY = 0;
        int maxY = 0;

        boolean isFirstOfSequence = true;       // the current integer is the very first of the sequence
        boolean isFirstStat = true;             // the very first statistic will be calculated at the end of the current window

        while (true) {
            int currentInt = in.nextInt();
            if (currentInt == 0) break;

            window[i] = currentInt;
            int firstOfWindow = window[0];      // shorthand

            // stats time: min(S) and max(S)
            if (isFirstOfSequence) {
                minS = currentInt;
                maxS = currentInt;
                isFirstOfSequence = false;
            } else {
                if (currentInt < minS)  minS = currentInt;
                else if (currentInt > maxS) maxS = currentInt;
            }

            sum += currentInt;

            if (i == k-1) {                     // last integer of the current window
                System.out.println(sum);
                if (isFirstStat) {
                    minY = sum;
                    maxY = sum;
                    isFirstStat = false;
                } else {
                    if (sum < minY)  minY = sum;
                    else if (sum > maxY) maxY = sum;
                }
                sum -= firstOfWindow;
                shiftWindow(window);            // update the window
                i--;
            }

            i++;
        }

        // print stats
        System.out.println(minS);
        System.out.println(maxS);
        System.out.println(minY);
        System.out.println(maxY);
    }

    /**
     * Move every item of the given array to left.
     * @param s the array to perform the shift on.
     */
    static void shiftWindow(int[] s) {
        for (int i=0; i<s.length-1; i++) {
            if (s[i + 1] != 0)
                s[i] = s[i + 1];
            else
                return // no need to shift, because all the remaining integers would be 0.
        }
    }
```

## Final notes

The program is in the file `exercise01.asm`.
Due to the submitting requirements, there are no prompts or help strings; but the Java implementation and the ASM comments would compensate pretty good.
Have fun :)
