local input = io.read("*all")
local arr = {}

-- Read all lines from the input.
-- Each line is converted to a number and stored in arr.
for line in input:gmatch("[^\r\n]+") do
	arr[#arr + 1] = tonumber(line)
end

local function mergesort(arr)
	---------------------------------- start of part 1 ----------------------------------
	-- Only split if the array has more than 1 element.
	-- Arrays with 0 or 1 elements are already sorted. (because 1 element is just 1 element you can't sort 1 with 1)
	if #arr > 1 then
		-- Divides the array with integral result (discard remainder)
		local middle = math.floor(#arr / 2)

		local left = {}
		local right = {}

		-- Copy the first half of arr into left.
		for i = 1, middle do
			left[#left + 1] = arr[i]
		end

		-- Copy the second half of arr into right.
		for i = middle + 1, #arr do
			right[#right + 1] = arr[i]
		end

		-- Recursively sort the left half.
		-- If left has more than 1 element, it will be split again
		-- until each subarray has only 1 or 0 elements.
		mergesort(left)

		-- Recursively sort the right half the same way.
		mergesort(right)

		---------------------------------- end of part 1 ----------------------------------

		---------------------------------- start of part 2 ----------------------------------

		-- At this point, both halves are sorted.
		-- Now merge the two sorted halves back into arr.
		--
		-- k = position in the original array arr
		-- leftCursor = current index in left
		-- rightCursor = current index in right
		local k, leftCursor, rightCursor = 1, 1, 1

		-- Compare the current elements of left and right.
		-- Put the smaller one into arr, then move that cursor forward.
		-- Keep doing this until one side runs out of elements.
		while leftCursor <= #left and rightCursor <= #right do
			if left[leftCursor] < right[rightCursor] then
				-- left element is smaller, so place it into arr
				arr[k] = left[leftCursor]
				leftCursor = leftCursor + 1
			else
				-- right element is smaller or equal, so place it into arr
				arr[k] = right[rightCursor]
				rightCursor = rightCursor + 1
			end

			-- move to the next position in arr
			k = k + 1
		end

		-- If there are leftover elements in left, copy them into arr.
		-- They are already sorted, so we can append them directly.
		while leftCursor <= #left do
			arr[k] = left[leftCursor]
			leftCursor = leftCursor + 1
			k = k + 1
		end

		-- If there are leftover elements in right, copy them into arr.
		-- They are already sorted, so we can append them directly. (The remaining elements are already sorted and they are all greater than or equal to the elements already placed into arr)
		while rightCursor <= #right do
			arr[k] = right[rightCursor]
			rightCursor = rightCursor + 1
			k = k + 1
		end

		---------------------------------- end of part 2 ----------------------------------
	end
end

--[[
function arrayToString(arr)
	local result = {}
	for i = 1, #arr do
		result[#result + 1] = tostring(arr[i])
	end
	return table.concat(result, " ")
end
]]

local start = os.clock()
mergesort(arr)
local end_time = os.clock()
print("Mergesort algorithm ended in: " .. end_time - start .. " seconds")
-- print("algorithm ended in: " .. end_time - start .. " seconds")
-- print("Results: ", arrayToString(arr))
