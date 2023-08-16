math.randomseed(os.time())
require("json")

function main()
    save = json.decode(readSave())
    local pause = save.pause
    io.write("How many dailies you did? ")
    local completedDailies = io.read("*number")
    io.read()
    io.write("How many habits you did? ")
    local completedHabits = io.read("*number")
    io.read()
    io.write("Did any To-Dos? (y/n) ")
    local didTodo = io.read("*line")
    if didTodo=="y" or didTodo=="Y" then
        didTodo=true
    else
        didTodo=false
    end
    local totalRolls = math.floor(completedDailies/3 + completedHabits/6)
    io.write("Total rolls you get: "..totalRolls.."\n")
    for i=1,totalRolls do
        local roll = math.random(1,6)
        local bossroll = math.random(1,6)
        io.write(i.."º Roll is: "..roll.."\n")
        if roll>=save.bossdefense then
            io.write("You attacked the "..save.quest.."!\n")
            save.bosshealth=save.bosshealth-1
            bossroll=bossroll-1
        else
            io.write("You missed!\n")
        end
        io.write(i.."º Boss roll is: "..bossroll.."\n")
        if bossroll>save.defense then
            io.write("The "..save.quest.." attacked you!\n")
            save.health=save.health-1
        else
            io.write("The "..save.quest.." missed!\n")
        end
        if pause then
            io.write("Press enter to continue...")
            io.read("*line")
        end
        io.write("======\n")
    end
    if save.bosshealth<=0 then
        reward()
    end
    if save.health<=0 then
        punish()
    end
    io.write("See you tomorrow!\n")
    success = saveGame()
    if success then 
        io.write("-==Saved Game==-\n")
    else
        io.write("ERROR: Problem saving game! (This should not happen)\n")
    end
end

function reward()
    
end

function punish()
    
end

function saveGame()
    local file = io.open("save.hbt","w")
    if file then
        local obj = json.encode(save)
        file:write(obj)
        return true
    else
        return false
    end
end

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

function join(table,del)
    local obj = table[1]
    for i=2,#table do
        obj=obj..del..table[i]
    end
    return obj
end

function readSave()
    return join(lines_from("save.hbt"),"\n")
end

main()