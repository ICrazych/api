local importants = ({...})[({...})[({...})[1]]]

function revertTimeString(timeString)
    local timeItems = timeString:split(":")
    local seconds = 0
    local multipliers = {}
    local iterations = 0
    for i = #timeItems, 1 , -1 do
        multipliers[i] = (iterations == 0 and 1 or iterations == 1 and 60 or iterations == 2 and 3600 or iterations == 3 and 86400)
        iterations = iterations + 1
    end
    for i = #timeItems, 1 , -1 do
        seconds = seconds + (tonumber(timeItems[i]) * multipliers[i])
    end
    return tonumber(seconds)
end

local module = {}

function module.GetSpawner(spawnerName)
    return importants.W:WaitForChild(importants.SpawnersFolder):FindFirstChild(spawnerName)
end

function module.GetSpawnerCooldown(spawnerName)
    local spawner = module.GetSpawner(spawnerName)
    if not spawner then return math.huge end

    local TimerGui
    for i,v in pairs(spawner:GetChildren()) do
        if v.ClassName == importants.TimerAtt and v:FindFirstChild(importants.TimerHui) then
            TimerGui = v[importants.TimerHui]
            break
        end
    end
    if not TimerGui then return math.huge end

    if TimerGui:FindFirstChild(importants.TimerText) then
        if TimerGui.TimerLabel.Visible == true then
            local isConverted,timeInSeconds = pcall(function() 
                return revertTimeString((TimerGui.TimerLabel.Text:split(": "))[2])    
            end)
            return (isConverted and timeInSeconds) or math.huge
        else
            return 0
        end
    end
end

return module, print("ClientMonsterTools.lua loaded")
