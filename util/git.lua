--[[pod_format="raw",created="2024-06-27 11:18:58",modified="2024-06-27 12:00:47",revision=15]]
require("json.lua")
require("basexx.lua")

if #env().argv < 1 then
	print("Example git use: git <option> <args>")
	print("- git clone ....")
	return
end

local function get_file(user, repo, path)
	local resp = fetch(("https://api.github.com/repos/%s/%s/contents/%s"):format(user, repo, path or ""))
	local wrapped = "{\"data\":"..resp.."}"
	local type = string.sub(resp, 1, 1) == "[" and "dir" or "file"
	return type, json.decode(wrapped)["data"]
end

local function clone(user, repo, path)
	local target_path
	if pwd() != "/" then
		target_path = env().path .."/".. repo .. "/" .. path
	else
		target_path = env().path .. repo .. "/" .. path
	end
	local type, filedata = get_file(user, repo, path)
	if type == "dir" then
		?target_path
		mkdir(target_path)
		for file in all(filedata) do
			clone(user, repo, file["path"])
		end
	else
		store(target_path, basexx.from_base64(filedata["content"], "\n"))
	end
end

local function clone_option(args)
	if #env().argv != 2 then
		print("Example use: git clone ....")
		return
	end
	
	local parts = split(args[2], "/")
	local user = parts[4]
	local repo = split(parts[5], ".")[1]
	clone(user, repo, "")
end

local options = {clone = clone_option}
local option = env().argv[1]

if not options[option] then
	print("Not implemented or wrong option!")
	return
end

options[option](env().argv)