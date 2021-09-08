local scripts = dofile("gostex-732/scripts.lua")
local configDir = "../"
local releaseDir = "../"
local outputDir = "../.aux/"
local settingsPath = configDir .. "settings.json"

local jobName = scripts.readJSONField(settingsPath, "path/mainFileName")
local releaseName = scripts.readJSONField(settingsPath, "release/name")
local author = scripts.readJSONField(settingsPath, "textFields/student")
local group = scripts.readJSONField(settingsPath, "textFields/group")
releaseName = string.gsub(releaseName .. " " .. author .. " " .. group, ' ', '_')

local sourcePath = outputDir .. jobName .. ".pdf"
local destinationPath  = releaseDir .. releaseName .. ".pdf"

scripts.copyFile(sourcePath, destinationPath)