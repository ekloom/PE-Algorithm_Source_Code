import time
import sys

data = sys.stdin.read()

# Read all input lines and convert each line to an integer.
arr = [int(line) for line in data.splitlines()]

def mergesort(arr):
    # ---------------------------------- start of part 1 ----------------------------------
    # Only split if the array has more than 1 element.
    # Arrays with 0 or 1 elements are already sorted. (because 1 element is just 1 element you can't sort 1 with 1)
    if len(arr) > 1:

        # Divides the array with integral result (discard remainder)
        middle = len(arr) // 2

        # Split arr into a left half and a right half.
        left = arr[:middle]
        right = arr[middle:]
        


        # Recursively sort the left half.
        # If left has more than 1 element, it will be split again
        # until the subarrays contain only 1 or 0 elements.
        mergesort(left)

        # Recursively sort the right half the same way.
        mergesort(right)

        # ---------------------------------- end of part 1 ----------------------------------


		# ---------------------------------- start of part 2 ----------------------------------

        # At this point, both halves are sorted.
        # Now merge the two sorted halves back into arr.

        # k = current position in arr
        # left_cursor = current index in left
        # right_cursor = current index in right
        k = 0
        left_cursor = 0
        right_cursor = 0
        


        # Compare the current elements of left and right.
        # Place the smaller one into arr, then move that cursor forward.
        # Keep doing this until one side has no elements left.
        while left_cursor < len(left) and right_cursor < len(right):
            if left[left_cursor] < right[right_cursor]:
                 # The left element is smaller, so copy it into arr.
                arr[k] = left[left_cursor]
                left_cursor += 1
            else:
                 # The right element is smaller or equal, so copy it into arr.
                arr[k] = right[right_cursor]
                right_cursor += 1
            # Move to the next position in arr.
            k +=1
            
        # Copy any remaining elements from left into arr.
        # They are already sorted, so they can be added directly.
        while left_cursor < len(left):
            arr[k] = left[left_cursor]
            left_cursor += 1
            k +=1
        
        # Copy any remaining elements from right into arr.
        # They are already sorted, so they can be added directly.
        while right_cursor < len(right):
            arr[k] = right[right_cursor]
            right_cursor += 1
            k +=1

        # ---------------------------------- end of part 2 ---------------------------------


# print(len(arr))
# Meting start hier

start = time.perf_counter()
mergesort(arr)
end = time.perf_counter()

print("Mergesort algorithm ended in: {0} seconds".format(end - start))
# print(f"results: {' '.join(map(str,arr))}")

