--Подключение библиотек
local component = require("component")
local computer = require("computer")
local nav = component.navigation
local fs = require("filesistem")

--Основные переменные
local x,y,z = nav.getPosition()

print(x,y,z)