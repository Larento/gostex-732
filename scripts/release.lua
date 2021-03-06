local scripts = dofile("node_modules/gostex-732/scripts/scripts.lua")
local configDir = "./"
local releaseDir = "./"
local outputDir = ".aux/"
local settingsPath = configDir .. "settings.json"

local jobName = "main"
local releaseName = scripts.readJSONField(settingsPath, "release/name")
local author = scripts.readJSONField(settingsPath, "textFields/student")
local group = scripts.readJSONField(settingsPath, "textFields/group")
releaseName = string.gsub(releaseName .. " " .. author .. " " .. group, ' ', '_')

local sourcePath = outputDir .. jobName .. ".pdf"
local destinationPath  = releaseDir .. releaseName .. ".pdf"

scripts.copyFile(sourcePath, destinationPath)