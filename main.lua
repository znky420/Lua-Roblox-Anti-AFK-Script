local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Z I N K | Anti AFK Script",
   LoadingTitle = "starten...",
   LoadingSubtitle = "by zink",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "zink_Scripts", 
      FileName = "AntiAFK_Config"
   },
   KeySystem = true,
   KeySettings = {
      Title = "zink Access",
      Subtitle = "Key System",
      Note = "Join Whatsapp Group for Key: https://whatsapp.com/channel/0029Vb8U5jv8aKvRl4Pp1D0P",
      FileName = "zinkKey", 
      SaveKey = true, 
      GrabKeyFromSite = false,
      Key = {"meow"} 
   }
})

-- Variablen für die Logik
local Layers = {
    AntiIdled = false,
    InputSim = false,
    Jitter = false
}

-- Tabs
local TabMain = Window:CreateTab("Protections", 4483362458)
local TabServer = Window:CreateTab("Server", 4483362458)
local TabSettings = Window:CreateTab("Einstellungen", 4483362458)

-----------------------------------------
-- TAB: PROTECTION
-----------------------------------------

TabMain:CreateSection("Anti-AFK Layer")

-- Layer 1: Standard Idled Connection
TabMain:CreateToggle({
   Name = "Layer 1: Anti-Idled (Basic)",
   CurrentValue = false,
   Flag = "AFK_L1",
   Callback = function(Value)
      Layers.AntiIdled = Value
      if Value then
          game:GetService("Players").LocalPlayer.Idled:Connect(function()
              if Layers.AntiIdled then
                  game:GetService("VirtualUser"):CaptureController()
                  game:GetService("VirtualUser"):ClickButton2(Vector2.new())
              end
          end)
      end
   end,
})

-- Layer 2: Virtuelle Eingabe-Simulation
TabMain:CreateToggle({
   Name = "Layer 2: Input Simulation (Advanced)",
   CurrentValue = false,
   Flag = "AFK_L2",
   Callback = function(Value)
      Layers.InputSim = Value
      task.spawn(function()
          while Layers.InputSim do
              -- Simuliert alle 20 Sekunden einen Klick in die Spielwelt
              game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
              task.wait(1)
              game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
              task.wait(19)
          end
      end)
   end,
})

-- Layer 3: Physics Jitter
TabMain:CreateToggle({
   Name = "Layer 3: Character Jitter (Physics)",
   CurrentValue = false,
   Flag = "AFK_L3",
   Callback = function(Value)
      Layers.Jitter = Value
      task.spawn(function()
          while Layers.Jitter do
              local lp = game.Players.LocalPlayer
              if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                  lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.05, 0)
                  task.wait(0.1)
                  lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0, -0.05, 0)
              end
              task.wait(10)
          end
      end)
   end,
})

--------------------------------------
-- TAB: SERVER
---------------------------------

TabServer:CreateSection("Server Steuerung")

TabServer:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
       game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
   end,
})

TabServer:CreateButton({
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


-- TAB: EINSTELLUNGEN


TabSettings:CreateSection("Info")

TabSettings:CreateLabel("https://whatsapp.com/channel/0029Vb8U5jv8aKvRl4Pp1D0P")

TabSettings:CreateSection("Menü")

TabSettings:CreateButton({
   Name = "Script schließen",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- Start-Notification
Rayfield:Notify({
   Title = "Z I N K geladen",
   Content = "Gestartet"
   Duration = 5,
})