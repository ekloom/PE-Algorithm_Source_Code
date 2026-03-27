import time
import sys

data = sys.stdin.read()

arr = [int(line) for line in data.splitlines()]

def median_of_three(arr, low, high):
    mid = (low + high) // 2

    a = arr[low]
    b = arr[mid]
    c = arr[high]

    if (a <= b <= c) or (c <= b <= a):
        return mid
    elif (b <= a <= c) or (c <= a <= b):
        return low
    else:
        return high


def partition(arr, low, high):
    pivot_index = median_of_three(arr, low, high)
    arr[pivot_index], arr[high] = arr[high], arr[pivot_index]

    pivot = arr[high]
    i = low - 1

    for j in range(low, high):
        if arr[j] < pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]

    i += 1
    arr[i], arr[high] = arr[high], arr[i]
    return i



def quicksort(arr, low, high):
    if low < high:
        partition_index = partition(arr, low, high)
        
        quicksort(arr, low, partition_index - 1)
        quicksort(arr, partition_index + 1, high)
        return


# print(len(arr))
# Meting start hier
start = time.perf_counter()
quicksort(arr, 0, len(arr) - 1)
end = time.perf_counter()

print("Quicksort algorithm ended in: {0} seconds".format(end - start))
# print(f"results: {' '.join(map(str,arr))}")
