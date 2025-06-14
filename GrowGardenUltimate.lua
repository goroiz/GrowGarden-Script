-- Grow Garden Ultimate Script (v1.0)
-- Fitur: Auto Farm, Duplikasi Tanaman, GUI Premium
return function()
    -- Library UI
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    local Window = Rayfield:CreateWindow({
        Name = "Grow Garden Ultimate",
        LoadingTitle = "Loading Premium Script...",
        LoadingSubtitle = "by YourName",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "GrowGardenConfig",
            FileName = "Settings.json"
        },
        Discord = {
            Enabled = true,
            Invite = "discord.gg/xxxxx",
            RememberJoins = true
        }
    })

    -- Variabel utama
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    getgenv().AutoFarm = false
    getgenv().Duplication = false
    getgenv().AutoRebirth = false

    -- Fungsi utama
    local function teleport(position)
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            Char.HumanoidRootPart.CFrame = CFrame.new(position)
        end
    end

    local function firePrompt(objName)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == objName and obj:FindFirstChild("ProximityPrompt") then
                fireproximityprompt(obj.ProximityPrompt)
                return true
            end
        end
        return false
    end

    -- Fitur duplikasi tanaman
    local function duplicatePlants()
        if not getgenv().Duplication then return end
        
        -- Cari tanaman yang sudah matang
        for _, plant in ipairs(workspace:GetChildren()) do
            if plant.Name:find("Ready") and plant:FindFirstChild("HarvestPrompt") then
                -- Simpan posisi asli
                local originalPos = plant.Position
                
                -- Duplikasi dengan mengubah posisi
                for i = 1, 5 do
                    teleport(originalPos + Vector3.new(i*2, 0, 0))
                    task.wait(0.1)
                    fireproximityprompt(plant.HarvestPrompt)
                end
                
                -- Kembali ke posisi awal
                teleport(originalPos)
            end
        end
    end

    -- Auto farm system
    local function autoFarm()
        while getgenv().AutoFarm and task.wait(1) do
            -- Auto plant
            teleport(Vector3.new(-30, 3, 0))
            firePrompt("Planter")
            task.wait(0.5)
            
            -- Duplikasi tanaman
            if getgenv().Duplication then
                duplicatePlants()
            end
            
            -- Auto water
            teleport(Vector3.new(-15, 3, 10))
            firePrompt("WateringCan")
            task.wait(0.5)
            
            -- Auto harvest
            teleport(Vector3.new(20, 3, -5))
            for i = 1, 5 do
                firePrompt("Harvest")
                task.wait(0.2)
            end
            
            -- Auto sell
            teleport(Vector3.new(40, 3, 25))
            firePrompt("SellBox")
            task.wait(1)
            
            -- Auto rebirth
            if getgenv().AutoRebirth and LocalPlayer.leaderstats.Coins.Value > 5000 then
                teleport(Vector3.new(0, 3, 50))
                firePrompt("RebirthMachine")
                task.wait(2)
            end
        end
    end

    -- Tab Utama
    local MainTab = Window:CreateTab("Main Features", 4483362458)
    
    -- Section Auto Farm
    local FarmSection = MainTab:CreateSection("Auto Farming")
    
    FarmSection:CreateToggle({
        Name = "Enable Auto Farm",
        CurrentValue = false,
        Flag = "AutoFarmToggle",
        Callback = function(Value)
            getgenv().AutoFarm = Value
            if Value then
                Rayfield:Notify({
                    Title = "Auto Farm Diaktifkan",
                    Content = "Mulai farming otomatis!",
                    Duration = 3
                })
                coroutine.wrap(autoFarm)()
            end
        end,
    })

    FarmSection:CreateToggle({
        Name = "Plant Duplication",
        CurrentValue = false,
        Flag = "DuplicationToggle",
        Callback = function(Value)
            getgenv().Duplication = Value
            Rayfield:Notify({
                Title = "Duplikasi Tanaman",
                Content = Value and "Diaktifkan" or "Dinonaktifkan",
                Duration = 3
            })
        end,
    })

    FarmSection:CreateToggle({
        Name = "Auto Rebirth",
        CurrentValue = false,
        Flag = "RebirthToggle",
        Callback = function(Value)
            getgenv().AutoRebirth = Value
        end,
    })

    -- Section Teleport
    local TeleportSection = MainTab:CreateSection("Teleport Locations")
    
    local locations = {
        {Name = "Planting Area", Position = Vector3.new(-30, 3, 0)},
        {Name = "Watering Area", Position = Vector3.new(-15, 3, 10)},
        {Name = "Harvest Area", Position = Vector3.new(20, 3, -5)},
        {Name = "Sell Area", Position = Vector3.new(40, 3, 25)},
        {Name = "Rebirth Machine", Position = Vector3.new(0, 3, 50)}
    }
    
    for _, loc in ipairs(locations) do
        TeleportSection:CreateButton({
            Name = loc.Name,
            Callback = function()
                teleport(loc.Position)
                Rayfield:Notify({
                    Title = "Teleport Berhasil",
                    Content = "Menuju "..loc.Name,
                    Duration = 2
                })
            end,
        })
    end

    -- Settings Tab
    local SettingsTab = Window:CreateTab("Settings", 4483362458)
    SettingsTab:CreateSection("Configuration")
    
    SettingsTab:CreateInput({
        Name = "Plant Interval",
        PlaceholderText = "Detik",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            getgenv().PlantInterval = tonumber(Text) or 1
        end,
    })

    SettingsTab:CreateKeybind({
        Name = "Toggle UI Keybind",
        CurrentKeybind = "RightControl",
        HoldToInteract = false,
        Flag = "UIKeybind",
        Callback = function(Keybind)
            Rayfield:Notify({
                Title = "Keybind Diubah",
                Content = "Toggle UI: "..Keybind,
                Duration = 2
            })
        end,
    })

    SettingsTab:CreateButton({
        Name = "Save Settings",
        Callback = function()
            Rayfield:Notify({
                Title = "Settings Disimpan",
                Content = "Konfigurasi telah disimpan!",
                Duration = 3
            })
        end,
    })

    -- Init script
    Rayfield:Notify({
        Title = "Script Loaded!",
        Content = "Grow Garden Ultimate v1.0 Activated",
        Duration = 5,
        Image = 4483362458
    })
end
