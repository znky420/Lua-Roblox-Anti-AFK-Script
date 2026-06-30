local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ZINK Anti AFK Script",
   LoadingTitle = "wird geladen...",
   LoadingSubtitle = "by zink",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "zink_Scripts", 
      FileName = "AntiAFK_Simple"
   },
   KeySystem = true,
   KeySettings = {
      Title = "ZINK Access",
      Subtitle = "Key System",
      Note = "Join Whatsapp Group for Key: https://whatsapp.com/channel/0029Vb8U5jv8aKvRl4Pp1D0P",
      FileName = "zinkKey", 
      SaveKey = true, 
      GrabKeyFromSite = false,
      Key = {"meow"} 
   }
})

local AntiAFKActive = false
local StartTime = os.time()

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

local TabMain = Window:CreateTab("Main", 4483362458)
local TabSettings = Window:CreateTab("Settings", 4483362458)

local TimerLabel = TabMain:CreateLabel("AFK Zeit: 00:00:00")

TabMain:CreateToggle({
   Name = "Anti AFK aktivieren",
   CurrentValue = false,
   Flag = "MasterAFK",
   Callback = function(Value)
      AntiAFKActive = Value
      if Value then
          StartTime = os.time()
          Rayfield:Notify({Title = "ZINK", Content = "Anti AFK Aktiv", Duration = 3})
      end
   end,
})

task.spawn(function()
    while task.wait(1) do
        if AntiAFKActive then
            local duration = os.time() - StartTime
            TimerLabel:Set("AFK Zeit: " .. formatTime(duration))
            
            local p = game:GetService("Players").LocalPlayer
            local vu = game:GetService("VirtualUser")
            
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
            
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.01, 0)
                task.wait(0.1)
                p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, -0.01, 0)
            end
        else
            TimerLabel:Set("AFK Zeit: System Inaktiv")
        end
    end
end)

TabSettings:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value)
      pcall(function()
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end)
   end,
})

TabSettings:CreateButton({
   Name = "FPS Booster",
   Callback = function()
       settings().Rendering.QualityLevel = 1
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("Part") or v:IsA("UnionOperation") then
               v.Material = Enum.Material.SmoothPlastic
           elseif v:IsA("Decal") then
               v.Transparency = 1
           end
       end
       Rayfield:Notify({Title = "ZINK", Content = "Grafik optimiert", Duration = 2})
   end,
})

TabSettings:CreateButton({
   Name = "Server Rejoin",
   Callback = function()
       game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
   end,
})

TabSettings:CreateButton({
   Name = "Server Hop",
   Callback = function()
       local Http = game:GetService("HttpService")
       local TPS = game:GetService("TeleportService")
       local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
       local _Servers = Http:JSONDecode(game:HttpGet(Api))
       for i,v in pairs(_Servers.data) do
           if v.playing < v.maxPlayers and v.id ~= game.JobId then
               TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
               break
           end
       end
   end,
})

TabSettings:CreateSection("ZINK Info")
TabSettings:CreateLabel("WhatsApp: https://whatsapp.com/channel/0029Vb8U5jv8aKvRl4Pp1D0P")

Rayfield:Notify({
   Title = "ZINK geladen",
   Content = "Script geladen",
   Duration = 5,
})