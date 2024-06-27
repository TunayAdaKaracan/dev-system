--[[pod_format="raw",created="2024-06-27 12:09:12",modified="2024-06-27 14:37:30",revision=23]]
print("Warning, this might take a while. Please do not exit while in process")

local function log(source, target)
	?("%s -> %s"):format(source, target)
end

local source = "/system"
local target = "/systems/dev"

local function get_name(filepath)
	local parts = split(filepath, "/")
	return parts[#parts]
end

local function is_same(file1, file2)
	local filename1 = "/applytemp/"..get_name(file1)
	local filename2 = "/applytemp/"..get_name(file2)
	cp(file1, filename1, true)
	cp(file2, filename2, true)
	local same = fetch(filename1) == fetch(filename2)
	rm(filename1)
	rm(filename2)
	return same
end

local function delete(path)
	local source_ = source .. (path or "")
	local target_ = target .. (path or "")
	local src_file = fstat(source_)
	local target_file = fstat(target_)
	if not src_file and target_file and target != "/system/boot.lua" then
		rm(target_)
		?"Deleting "..target_
	elseif target_file == "folder" then
		local l = ls(target_)
		for _, fn in pairs(l) do
			delete(path .. "/" .. fn)
		end
	end
end

local function copy(path)
	local source_ = source .. path
	local target_ = target .. path
	
	local src_file = fstat(source_)
	local target_file = fstat(target_)
	
	-- Create file/folder if not exists
	if (src_file and not target_file) then
		if source_ == "/system/boot.lua" then
			return
		end
		cp(source_, target_)
		log(source_, target_)
	elseif src_file == "folder" then
		mkdir(target_)
		local l = ls(source_)
		add(l, ".info.pod")
		for _, fn in pairs(l) do
			copy(path .. "/" .. fn)
		end
	end
end

-- Delete any deleted system file on /systems/dev
delete("")
copy("")