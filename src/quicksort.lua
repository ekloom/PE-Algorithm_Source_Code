local input = io.read("*all")
local arr = {}

for line in input:gmatch("[^\r\n]+") do
	arr[#arr + 1] = tonumber(line)
end


local function medianOfThree(arr, low, high)
	local mid = math.floor((low + high) / 2)

	local a = arr[low]
	local b = arr[mid]
	local c = arr[high]

	if (a <= b and b <= c) or (c <= b and b <= a) then
		return mid
	elseif (b <= a and a <= c) or (c <= a and a <= b) then
		return low
	else
		return high
	end
end

local function partition(arr, low, high)
	local pivotIndex = medianOfThree(arr, low, high)
	arr[pivotIndex], arr[high] = arr[high], arr[pivotIndex]

	local pivot = arr[high]
	local i = low - 1

	for j = low, high - 1 do
		if arr[j] < pivot then
			i = i + 1
			arr[i], arr[j] = arr[j], arr[i]
		end
	end

	i = i + 1
	arr[i], arr[high] = arr[high], arr[i]
	return i
end


local function quicksort(arr, low, high)
	if low < high then
		local partitionIndex = partition(arr, low, high)
		
		quicksort(arr, low, partitionIndex - 1)
		quicksort(arr, partitionIndex + 1, high)
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
quicksort(arr, 1, #arr)
local end_time = os.clock()
print("Quicksort algorithm ended in: " .. end_time - start .. " seconds")
-- print("Results: ", arrayToString(arr))
