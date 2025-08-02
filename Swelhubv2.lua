-- Gerekli servisler
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Rayfield GUI yükleniyor
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Ana pencere
local Window = Rayfield:CreateWindow({
 Name = "SwelHub GUI",
 LoadingTitle = "Yükleniyor...",
 LoadingSubtitle = "by SwelCv",
 ConfigurationSaving = {
  Enabled = true,
  FolderName = "SwelHubConfig",
  FileName = "MyGUI"
 },
 KeySystem = false,
})

---------------------------------
-- 📁 Sekme 1: Profil Bilgileri
---------------------------------
local ProfileTab = Window:CreateTab("Profil", 4483362458)

ProfileTab:CreateSection("Kullanıcı Bilgisi")

ProfileTab:CreateLabel("İsim: " .. Players.LocalPlayer.Name)
ProfileTab:CreateLabel("Görünen İsim: " .. Players.LocalPlayer.DisplayName)
ProfileTab:CreateLabel("UserID: " .. Players.LocalPlayer.UserId)

---------------------------------
-- ⚙️ Sekme 2: Araçlar & Modlar
---------------------------------
local ToolsTab = Window:CreateTab("Araçlar", 4483362458)

-- WalkSpeed
ToolsTab:CreateSlider({
 Name = "WalkSpeed",
 Range = {16, 200},
 Increment = 1,
 Suffix = "Speed",
 CurrentValue = 16,
 Callback = function(Value)
  local char = Players.LocalPlayer.Character
  if char then
   local hum = char:FindFirstChildOfClass("Humanoid")
   if hum then hum.WalkSpeed = Value end
  end
 end,
})

-- Fly
local flySpeed = 50
local flyEnabled = false

ToolsTab:CreateSlider({
 Name = "Fly Speed",
 Range = {10, 200},
 Increment = 5,
 Suffix = "Speed",
 CurrentValue = 50,
 Callback = function(Value)
  flySpeed = Value
 end,
})

ToolsTab:CreateToggle({
 Name = "Fly",
 CurrentValue = false,
 Callback = function(Value)
  flyEnabled = Value
  local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if not hrp then return end

  if flyEnabled then
   RunService:BindToRenderStep("Flying", Enum.RenderPriority.Input.Value, function()
    if flyEnabled and hrp then
     hrp.Velocity = Vector3.new(0, flySpeed, 0)
    end
   end)
  else
   RunService:UnbindFromRenderStep("Flying")
  end
 end,
})

-- Spin
local spinning = false
ToolsTab:CreateToggle({
 Name = "Spin (120 FPS)",
 CurrentValue = false,
 Callback = function(Value)
  spinning = Value
  if spinning then
   RunService:BindToRenderStep("Spin", Enum.RenderPriority.Camera.Value, function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
     char:SetPrimaryPartCFrame(char.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(10), 0))
    end
   end)
  else
   RunService:UnbindFromRenderStep("Spin")
  end
 end,
})

-- Anti-AFK
ToolsTab:CreateToggle({
 Name = "Anti-AFK",
 CurrentValue = false,
 Callback = function(Value)
  if Value then
   Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
   end)
  end
 end,
})

-- Anti-Kick
ToolsTab:CreateToggle({
 Name = "Anti-Kick",
 CurrentValue = false,
 Callback = function(Value)
  if Value then
   local mt = getrawmetatable(game)
   setreadonly(mt, false)
   local oldNamecall = mt.__namecall
   mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" then
     warn("Kick engellendi!")
     return
    end
    return oldNamecall(self, ...)
   end)
   setreadonly(mt, true)
  end
 end,
})

-- ESP
ToolsTab:CreateToggle({
 Name = "ESP (Adlar)",
 CurrentValue = false,
 Callback = function(Value)
  if Value then
   for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
     local billboard = Instance.new("BillboardGui", plr.Character.Head)
     billboard.Name = "ESP"
     billboard.Size = UDim2.new(0, 100, 0, 40)
     billboard.Adornee = plr.Character.Head
     billboard.AlwaysOnTop = true
     local text = Instance.new("TextLabel", billboard)
     text.Size = UDim2.new(1, 0, 1, 0)
     text.BackgroundTransparency = 1
     text.Text = plr.Name
     text.TextColor3 = Color3.new(1, 0, 0)
     text.TextScaled = true
    end
   end
  else
   for _, plr in pairs(Players:GetPlayers()) do
    if plr.Character and plr.Character:FindFirstChild("Head") then
     local esp = plr.Character.Head:FindFirstChild("ESP")
     if esp then esp:Destroy() end
    end
   end
  end
 end,
})

-- Server Lag (örnek dummy)
ToolsTab:CreateButton({
 Name = "Server Lag Denemesi",
 Callback = function()
  warn("Server lag çalıştırıldı (placeholder)")
 end,
})

-- Hacker Mod (Infinite Jump)
ToolsTab:CreateToggle({
 Name = "Hacker Mode (Sonsuz Zıplama)",
 CurrentValue = false,
 Callback = function(Value)
  if Value then
   UserInputService.JumpRequest:Connect(function()
    local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
   end)
  end
 end,
})

---------------------------------
-- 📣 Sekme 3: Create (Telegram)
---------------------------------
local CreateTab = Window:CreateTab("Create", 4483362458)

CreateTab:CreateButton({
 Name = "Telegram Kanalımıza Katıl 🔗",
 Callback = 
function()
  setclipboard("https://t.me/SwelHub")
  Rayfield:Notify({
   Title = "Kopyalandı!",
   Content = "Link panoya kopyalandı. Tarayıcıya yapıştırarak katılabilirsin.",
   Duration = 6,
  })
 end,
})