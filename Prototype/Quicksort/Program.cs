// See https://aka.ms/new-console-template for more information

void QuickSort(ref int[] arr, int low, int high)
{
    if (low < high)
    {
        Console.WriteLine("\nArray layout currently {0}\n", string.Join(" ", arr));

        Console.WriteLine($"New entry! index number Low:{low} ({arr[low]}), index number of High: {high} ({arr[high]})");
        int partitionIndex = Partition(ref arr, low, high);

        //Console.WriteLine($"Starting with left side of the pivot {high} which is now at the middle of the array");
        // start with the left side of the pivot
        QuickSort(ref arr, low, partitionIndex - 1);

        //Console.WriteLine($"Starting with right side of the pivot {high} which is now at the middle of the array");
        // End with the right side of the pivor
        QuickSort(ref arr, partitionIndex + 1, high);
        return;
    }

    if (low == high)
    {
        Console.WriteLine($"index number Low: {low} is equal with index number high: {high}\n");

    }
    else
    {
        Console.WriteLine($"index number Low: {low} is higher than index number high: {high}\n");
    }

    Console.WriteLine("=====================================");

}


int MedianOfThree(ref int[] array, int low, int high)
{
    // Pick three values:
    // - the first value of the current section
    // - the middle value
    // - the last value
    //
    // Return the index of the value that lies in the middle.
    // This is used as the pivot choice, because it is often better
    // than always picking the first or last element.

    int mid = (low + high) / 2;

    int a = array[low];
    int b = array[mid];
    int c = array[high];

    if ((a <= b && b <= c) || (c <= b && b <= a))
        return mid;
    else if ((b <= a && a <= c) || (c <= a && a <= b))
        return low;
    else
        return high;
}


/*
Partition rearranges the current section of the array between low and high.

It first chooses a pivot using median of three.
That pivot is swapped to the end of the current section.

Then it scans from left to right using j.

Variable i keeps track of the last position where a value smaller than the pivot
has been placed.

During the loop:
- if array[j] is smaller than the pivot, it belongs on the left side
- i is increased
- array[i] and array[j] are swapped

At the end of the loop, the pivot is swapped into index i + 1.

So after partition finishes:
- everything left of the returned index is smaller than the pivot
- the pivot is at its final sorted position
- everything right of the returned index is greater than or equal to the pivot
*/
int Partition(ref int[] array, int low, int high)
{

    // Choose a pivot using median of three.
    int pivot_index = MedianOfThree(ref array, low, high);

    // Move the chosen pivot to the end of the current section,
    // because this partition logic expects the pivot at array[high].
    (array[pivot_index], array[high]) = (array[high], array[pivot_index]);



    int pivot = array[high];
    Console.WriteLine($"Pivot value: {pivot}");


    // i marks the end of the "smaller than pivot" section.
    // It starts one position before low because we have not found
    // any smaller values yet.
    int i = low - 1;



    // j scans through the current section from left to right,
    // stopping before the pivot at high.
    for (int j = low; j < high; j++)
    {
        // If the current value is smaller than the pivot,
        // it belongs on the left side.
        if (array[j] < pivot)
        {

            // increases the 'i' value 
            i++;

            Console.WriteLine($"\n{array[j]} at index '{j}' is less than the pivot which is {pivot} so it will get swapped with {array[i]} which is at index '{i}'");
            (array[i], array[j]) = (array[j], array[i]);
            Console.WriteLine("Array layout currently {0}\n", string.Join(" ", array));
            continue;
        }
        Console.WriteLine($"{array[j]} at index '{j}' is greater than or equal to the pivot which is {pivot}");

    }



    // Since the pivot is the last number in the array 'i' won't be increased since the value of the pivot is not less/greater than itself (if (array[j] < pivot))
    // so we need to increment i + 1 since the current value at the index of 'i' is a number which is less than the pivot 
    // we will swap the number at 'i++' with the pivot since the number at that position is greater than the pivit meaning that it belongs to the right side

    // Put the pivot directly after the last smaller element.
    // That becomes the pivot's final sorted position.
    i++;
    (array[i], array[high]) = (array[high], array[i]);
    Console.WriteLine("\nArray layout currently {0}\n", string.Join(" ", array));

    Console.WriteLine("Parition ended!\n");
    return i;

}

int[] arr = { 55, 45, 13, 42, 16, 214, 5, 2, 1551, 5, 23, 3, 35, 35, 5, 6, 3, 36, 3, 52, 5, 25, 235, 25, 325, 32 };

Console.WriteLine("Orginal layout of array {0} \n\n", string.Join(" ", arr));

QuickSort(ref arr, 0, arr.Length - 1);
Console.WriteLine("\n\nSorted array is {0}", string.Join(" ", arr));
Console.ReadLine();

/*
Example: [8, 3, 5, 1]

Suppose the pivot chosen is 5.

Partition rearranges the array so values smaller than 5 go left,
and values greater than or equal to 5 go right.

After partition, the array might look like:
[3, 1, 5, 8]

Now 5 is in its final sorted position.

QuickSort then runs on:
- left side of pivot: [3, 1]
- right side of pivot: [8]

Then the same process repeats on the left and right sections
until all sections are size 1 or empty.
*/