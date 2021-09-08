-- require "lualibs"
-- local json = require "cjson"
local json = dofile("gostex-732/json.lua")
local scripts = {}

function scripts.setListMargins(listDepth)
    for i = 1, listDepth do
        leftmargin = 0
        if i > 1 then
            leftmargin = 1
        end
        tex.sprint("\\setlist["..i.."]{leftmargin="..leftmargin.."\\parindent, labelindent="..(leftmargin + 1).."\\parindent}")
    end
end

function scripts.readFile(filePath, mode)
    mode = mode or '*a'
    local file, err = io.open(filePath, 'rb')
    if err then
        error(err)
    end
    local content = file:read(mode)
    file:close()
    return content
end

function scripts.writeFile(filePath, content, mode)
    mode = mode or 'w'
    local file, err = io.open(filePath, mode)
    if err then
        error(err)
    end
    file:write(content)
    file:close()
end

function scripts.copyFile(sourcePath, destinationPath)
    local content = scripts.readFile(sourcePath)
    scripts.writeFile(destinationPath, content)
end

function scripts.loadJSON(filePath)
    return json:decode(scripts.readFile(filePath))
end

-- Special path means you access table fields
-- by chaining names like a file path:
-- specialPath = "foo/bar/baz"
-- yields table["foo"]["bar"]["baz"] 
function scripts.getTableFields(myTable, specialPath)
    local nextTable = myTable
    for token in string.gmatch(specialPath, "[^/]+") do
        nextTable = nextTable[token]
    end
    return nextTable
end

function scripts.readJSONField(filePath, tableField)
    return scripts.getTableFields(scripts.loadJSON(filePath), tableField)
end

return scripts