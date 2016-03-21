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
	return "{" .. table.val_to_str( k ) .. "}"
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
	return "\n{" .. table.concat( result, "," ) .. "}"
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

local function dbReset(data)
	local f, err = io.open("db.txt", "w")
	if not f then 
		return nil, err
	end
	if data then
		f:write("{" .. table.tostring(data) .. "}")
	else f:write("{\n}") 
	end
	f:close()
	return true
end


local function checkLocation()
	for k, v in ipairs(dbGet()) do
		local x,y,z = 0, 0 ,0
		if (v.x == x) and (v.y == y) and (v.z == z) then
			return v
		end

		--Проверяем на формируем запись в таблицу
	end
end


---------------------------------------
--------------ТЕСТЫ КОДА---------------
---------------------------------------
dbReset()

local f, err = io.open("db.txt", "r")
if not f then return nil, err end
print(f:read("*a"))
f:close()
print("----------------------------")
print(" ") 

dbSet({x=3, y=-2, z=14, out={1, 2}, inp={}})

local f, err = io.open("db.txt", "r")
if not f then return nil, err end
print(f:read("*a"))
f:close()
print("----------------------------")
print(" ")

dbSet({x=2, y=1, z=0, out={0, 1}, inp={{1, 1}}})

local f, err = io.open("db.txt", "r")
if not f then return nil, err end
print(f:read("*a"))
f:close()
print("----------------------------")
print(" ")


dbSet({x=0, y=0, z=0, out={0, 2, 3}, inp={{2, 0}}})

local f, err = io.open("db.txt", "r")
if not f then return nil, err end
print(f:read("*a"))
f:close()
print("----------------------------")
print(" ")


 
local t = checkLocation()
for i, v in ipairs(t) do
	print(i, v)
end

-- Структура DB
--{
--	{x=0, y=0, z=0, out={rate numbers}, inp={{id, rate_number}, {id, rate_number}, {id, rate_number}}},
--	{x=1, y=1, z=1, out={rate numbers}, inp={{id, rate_number}, {id, rate_number}, {id, rate_number}}}
--}