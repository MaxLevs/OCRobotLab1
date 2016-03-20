--Подключение библиотек
local component = require("component")
local computer = require("computer")
local nav = component.navigation
local fs = require("filesystem")

--Основные переменные
local x,y,z = nav.getPosition()
local facing = nav.getFacing()
local mapRange = nav.getRange()


-----------------------------
------MUST-HAVE функции------
-----------------------------

function table.val_to_str ( v )
	if "string" == type( v ) then
		v = string.gsub( v, "\n", "\\n" )
		if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
			return "'" .. v .. "'"
		end
		return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
	end
	return "table" == type( v ) and table.tostring( v ) or tostring( v )
end

function table.key_to_str ( k )
	if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
		return k
	end
	return "[" .. table.val_to_str( k ) .. "]"
end

-- Преобразование таблицы или массива в текстовое представление в соответствии с синтаксисом языка lua
function table.tostring( tbl )
	local result, done = {}, {}
	for k, v in ipairs( tbl ) do
		table.insert( result, table.val_to_str( v ) )
		done[ k ] = true
	end
	for k, v in pairs( tbl ) do
		if not done[ k ] then
			table.insert( result, table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
		end
	end
	return "{" .. table.concat( result, "," ) .. "}"
end




--Функции работы с текстовой БД
local function dbGet()
	local f, err = io.open("db.txt", "r")
	if not f then return nil, err end
	local tbl = assert(load("return " .. f:read("*a")))
	f:close()
	return tbl()
end

local function dbSet(data)
	local tbl = dbGet()
	if type(tbl) ~= "table" then tbl={} end
	table.insert(tbl, data)

	local f, err = io.open("db.txt", "w")
	if not f then return nil, err end
	f:write(table.tostring(tbl))
	f:close()
	return true
end

local function dbSet(data)
	local f, err = io.open("db.txt", "w")
	if not f then return nil, err end
	f:write(table.tostring(data))
	f:close()
	return true
end

local function logSet(x, y, z, r, ... )
	
end

--dbSet({x=0, y=0, z=0, r=0, 1, 4})

--dbSet({x=2, y=0, z=-3, r=2, 1, 4})

--dbSet({x=0, y=0, z=0, r=0, 1})

print(dbGet())