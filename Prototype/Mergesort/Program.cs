// See https://aka.ms/new-console-template for more information



void MergeSort(int[] arr)
{
    // ------------------------------ part 1 (THE SPLITTER) ------------------------------
    // Only split if the array has more than 1 element.
    // Arrays with 0 or 1 elements are already sorted.
    if (arr.Length > 1)
    {
        int middle = arr.Length / 2;

        // Split the array into a left half and a right half.
        int[] left = arr[..middle];
        int[] right = arr[middle..];


        // Recursively sort the left half.
        // If left still has more than 1 element, it will be split again
        // until the subarrays contain only 1 or 0 elements.
        MergeSort(left);

        // this will automatically return and not even process
        // Recursively sort the right half the same way.
        MergeSort(right);

        // Example: if this call becomes MergeSort([8, 3]),
        // it splits into left = [8] and right = [3].
        //
        // MergeSort([8]) which is "MergeSort(left)"  does not split any further,
        // because arr.Length > 1 is false, so that call returns immediately.
        //
        // Control then goes back to the previous call: MergeSort([8, 3]).
        // That call now continues to its next line, which is MergeSort(right),
        // so it then calls MergeSort([3]).
        //
        // MergeSort([3]) also does not split any further,
        // because arr.Length > 1 is false, so that call returns immediately.
        //
        // After both [8] and [3] return, the MergeSort([8, 3]) call starts part 2.


        // ------------------------------ end part 1 ------------------------------
        /* At this point, both halves are sorted.
         Now merge the two sorted halves back into arr.

        i = current position in arr
         leftCursor = current index in left
         rightCursor = current index in right
        */

        // ------------------------------ part 2 (THE MERGER)------------------------------
        int i = 0, leftCursor = 0, rightCursor = 0;



        // Compare the current elements of left and right.
        // Copy the smaller one into arr, then move that cursor forward.
        // Keep doing this until one side has no elements left.
        while (leftCursor < left.Length && rightCursor < right.Length)
        {
            if (left[leftCursor] < right[rightCursor])
            {
                // The left element is smaller, so copy it into arr.
                arr[i] = left[leftCursor];
                leftCursor++;
            }
            else
            {
                // The right element is smaller or equal, so copy it into arr.
                arr[i] = right[rightCursor];
                rightCursor++;
            }

            // Move to the next position in arr.
            i++;

        }


        // Copy any remaining elements from left into arr.
        // They are already sorted, so they can be added directly.
        while (leftCursor < left.Length)
        {
            arr[i] = left[leftCursor];
            leftCursor++;
            i++;
        }


        // Copy any remaining elements from right into arr.
        // They are already sorted, so they can be added directly.
        while (rightCursor < right.Length)
        {
            arr[i] = right[rightCursor];
            rightCursor++;
            i++;
        }

        // ------------------------------ end of part 2
    }

}

int[] arr = { 55, 45, 13, 42, 16, 214, 5, 2, 1551, 5, 23, 3, 35, 35, 5, 6, 3, 36, 3, 52, 5, 25, 235, 25, 325, 32 };

Console.WriteLine("Orginal layout of array {0} \n\n", string.Join(" ", arr));



MergeSort(arr);
Console.WriteLine("\n\nSorted array is {0}", string.Join(" ", arr));
Console.ReadLine();

/*
Example: arr = [8, 3, 5, 1]

First call:
MergeSort([8, 3, 5, 1])

This splits into:
left = [8, 3]
right = [5, 1]

The function always calls MergeSort(left) first.
But that left side also splits again into its own left and right arrays.

LEFT SIDE:
MergeSort([8, 3]) becomes:
left = [8]
right = [3]

Now MergeSort([8]) stops immediately, because arr.Length > 1 is false.
Then MergeSort([3]) also stops immediately,  because arr.Length > 1 is false.

Since the recursive calls for [8] and [3] are now finished, the MergeSort([8, 3]) call can start part 2. The single element arrays did not run part 2, because arr.Length > 1 was false:
it merges [8] and [3] into [3, 8].

Only after the whole left side is completely done
does the previous call continue with MergeSort(right),
which in the first call means MergeSort([5, 1]).

So the left side of the original call is now sorted:
left = [3, 8]

------------------------------------------------

RIGHT SIDE:
MergeSort([5, 1]) becomes:
left = [5]
right = [1]

Now MergeSort([5]) 'MergeSort(left)' stops immediately, because arr.Length > 1 is false.
Then MergeSort([1], 'MergeSort(right)' also stops immediately, because arr.Length > 1 is false.

Since both sides of [5, 1] are now finished, that call can start part 2:
it merges [5] and [1] into [1, 5].

So the right side of the original call is now sorted:
right = [1, 5]

ORIGINAL CALL:
MergeSort([8, 3, 5, 1])

Now the original call has:
left = [3, 8]
right = [1, 5]

Since both sides are now finished, the original call finally starts part 2:
it merges [3, 8] and [1, 5] into [1, 3, 5, 8].

So the function works like this:
1. Split into left and right
2. Fully sort the left side
3. Fully sort the right side
4. Merge both sorted sides

Important:
Part 2 does not start for the current call
until both MergeSort(left) and MergeSort(right) are finished.

But deeper calls on the left side can already do their own merges
before the parent call ever reaches MergeSort(right).
*/