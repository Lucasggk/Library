# Fluent UI — Documentação Completa

Biblioteca de interface gráfica para scripts Roblox.

---

## Índice

1. [Inicialização](#1-inicialização)
2. [Criando a Janela](#2-criando-a-janela)
3. [Temas Disponíveis](#3-temas-disponíveis)
4. [Abas e Sub-abas](#4-abas-e-sub-abas)
5. [Seções](#5-seções)
6. [Elementos](#6-elementos)
   - [Toggle](#toggle)
   - [Slider](#slider)
   - [Button](#button)
   - [Dropdown](#dropdown)
   - [Keybind](#keybind)
   - [Colorpicker](#colorpicker)
   - [Input](#input)
   - [Paragraph](#paragraph)
7. [Notificações](#7-notificações)
8. [Minimizador](#8-minimizador)
9. [SaveManager](#9-savemanager)
10. [Métodos da Library](#10-métodos-da-library)
11. [Exemplo Completo](#11-exemplo-completo)

---

## 1. Inicialização

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Library/refs/heads/main/Library.lua"))()
```

---

## 2. Criando a Janela

```lua
local Window = Library:CreateWindow({
    Title                  = "Meu Script",
    SubTitle               = "v1.0",
    Theme                  = "Dark",
    Acrylic                = false,
    TabWidth               = 150,
    Size                   = UDim2.fromOffset(600, 480),
    MinimizeKey            = Enum.KeyCode.LeftControl,
    BackgroundImage        = "",
    BackgroundTransparency = 0.5,
    Icon                   = "",
    Image                  = "",
    Search                 = true,
    DropdownsOutsideWindow = false,
    UserInfo               = true,
    UserInfoTitle          = "Player Name",
    UserInfoSubtitle       = "VIP",
    UserInfoSubtitleColor  = Color3.fromRGB(255, 200, 0),
    UserInfoTop            = false,
})
```

---

## 3. Temas Disponíveis

| Nome        | Descrição               |
|-------------|-------------------------|
| `Dark`      | Cinza escuro clássico   |
| `Darker`    | Ainda mais escuro       |
| `AMOLED`    | Preto puro              |
| `Light`     | Fundo branco            |
| `Balloon`   | Tons de azul claro      |
| `SoftCream` | Tons creme/bege         |
| `Aqua`      | Verde-azulado           |
| `Amethyst`  | Roxo                    |
| `Rose`      | Rosa/vermelho           |
| `Midnight`  | Azul meia-noite         |
| `Forest`    | Verde floresta          |
| `Sunset`    | Laranja/pôr do sol      |
| `Ocean`     | Azul oceano             |
| `Emerald`   | Verde esmeralda         |
| `Sapphire`  | Azul safira             |
| `Cloud`     | Azul petróleo           |
| `Grape`     | Preto com roxo          |
| `Bloody`    | Vermelho sangue         |
| `Arctic`    | Azul gelo               |

```lua
Library:SetTheme("Midnight")
```

---

## 4. Abas e Sub-abas

```lua
local MinhaAba = Window:AddTab({
    Title = "Combat",
    Icon  = "",
})

Window:SetTab("Combat")
Window:SetTab(1)

local SubA = MinhaAba:AddSubTab("ESP")
local SubB = MinhaAba:AddSubTab("Chams")

local Secao = SubA:AddSection("Configurações de ESP")
```

---

## 5. Seções

```lua
local MinhaSecao = MinhaAba:AddSection("Título da Seção")
local SecaoComIcone = MinhaAba:AddSection("Players", "rbxassetid://...")
```

---

## 6. Elementos

### Toggle

```lua
local MeuToggle = MinhaSecao:AddToggle("IdUnico", {
    Title       = "Aimbot",
    Description = "Descrição opcional",
    Default     = false,
    Callback    = function(Value)
        print("Toggle:", Value)
    end,
})

MeuToggle:OnChanged(function(Value)
    print("Mudou para:", Value)
end)

MeuToggle:SetValue(true)
print(Library.Options["IdUnico"].Value)
```

---

### Slider

```lua
local MeuSlider = MinhaSecao:AddSlider("IdUnico", {
    Title       = "Walk Speed",
    Description = "Velocidade do personagem",
    Min         = 16,
    Max         = 500,
    Default     = 16,
    Rounding    = 0,
    Callback    = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

MeuSlider:OnChanged(function(Value) end)
MeuSlider:SetValue(100)
print(Library.Options["IdUnico"].Value)
```

---

### Button

```lua
MinhaSecao:AddButton({
    Title       = "Teleportar",
    Description = "Vai ao spawn",
    Callback    = function()
        Library:Notify({ Title = "OK", Content = "Teleportado!", Duration = 3 })
    end,
})
```

---

### Dropdown

```lua
local MeuDrop = MinhaSecao:AddDropdown("IdUnico", {
    Title       = "Target Part",
    Description = "Parte para mirar",
    Values      = { "Head", "Torso", "HumanoidRootPart" },
    Default     = "Head",
    Multi       = false,
    Search      = true,
    AllowNull   = false,
    Callback    = function(Value)
        print("Selecionado:", Value)
    end,
})

local MultiDrop = MinhaSecao:AddDropdown("IdMulti", {
    Title    = "Partes",
    Values   = { "Head", "Torso", "LeftArm", "RightArm" },
    Default  = { "Head", "Torso" },
    Multi    = true,
    Callback = function(Value)
        for parte, ativo in pairs(Value) do
            print(parte, ativo)
        end
    end,
})

MeuDrop:OnChanged(function(Value) end)
MeuDrop:SetValue("Torso")
MeuDrop:SetValues({ "Head", "Torso", "LeftLeg" })
print(Library.Options["IdUnico"].Value)
```

---

### Keybind

```lua
local MeuBind = MinhaSecao:AddKeybind("IdUnico", {
    Title           = "Aimbot Key",
    Description     = "Tecla para ativar",
    Default         = "Q",
    Mode            = "Toggle",
    Callback        = function(Value) end,
    ChangedCallback = function(NewKey)
        print("Nova tecla:", NewKey)
    end,
})

MeuBind:OnChanged(function(Key) end)
MeuBind:SetValue("E", "Hold")

if Library.Options["IdUnico"]:GetState() then end
```

**Modos:**
- `"Toggle"` — alterna entre ativo/inativo a cada pressionamento
- `"Hold"` — ativo apenas enquanto a tecla está pressionada
- `"Always"` — sempre ativo, ignora a tecla

---

### Colorpicker

```lua
local MeuColor = MinhaSecao:AddColorpicker("IdUnico", {
    Title        = "Cor do ESP",
    Description  = "Escolha a cor",
    Default      = Color3.fromRGB(255, 0, 0),
    Transparency = false,
    Callback     = function(Color)
        print("Cor:", Color)
    end,
})

MeuColor:OnChanged(function(Color) end)
MeuColor:SetValue({ 0, 1, 1 }, 0)
MeuColor:SetValueRGB(Color3.fromRGB(0, 255, 100), 0.5)

print(Library.Options["IdUnico"].Value)
print(Library.Options["IdUnico"].Transparency)
```

---

### Input

```lua
local MeuInput = MinhaSecao:AddInput("IdUnico", {
    Title       = "Player Name",
    Description = "Nome do alvo",
    Default     = "",
    Placeholder = "Digite aqui...",
    Numeric     = false,
    Finished    = false,
    MaxLength   = 50,
    Callback    = function(Value)
        print("Texto:", Value)
    end,
})

MeuInput:OnChanged(function(Value) end)
MeuInput:SetValue("NomeDoJogador")
print(Library.Options["IdUnico"].Value)
```

---

### Paragraph

```lua
MinhaSecao:AddParagraph({
    Title   = "Informações",
    Content = "Versão 1.0 | Discord: meuhub.gg\nSuporte a múltiplas linhas.",
})

MinhaSecao:AddParagraph({
    Title   = "Colorido",
    Content = "<red>Vermelho</red> | <green>Verde</green> | <gradient:#FF0000:#0000FF>Gradiente</gradient>",
})
```

---

## 7. Notificações

```lua
Library:Notify({
    Title      = "Título",
    Content    = "Mensagem principal",
    SubContent = "Detalhe adicional",
    Duration   = 5,
})

local Notif = Library:Notify({ Title = "...", Content = "..." })
Notif:Close()
```

---

## 8. Minimizador

```lua
Library:CreateMinimizer({
    Draggable    = true,
    Icon         = "rbxassetid://...",
    Size         = UDim2.fromOffset(36, 36),
    Position     = UDim2.new(0, 300, 0, 20),
    Acrylic      = false,
    Transparency = 0,
    Corner       = 14,
    Visible      = true,
})
```

---

## 9. SaveManager

```lua
local ok, err = Library.SaveManager:Save()
if not ok then print("Erro ao salvar:", err) end

local ok, err = Library.SaveManager:Load()

local SettingsTab = Window:AddTab({
    Title       = "Settings",
    SaveManager = true,
})

Library.SaveManager.Ignore["IdUnico"] = true
Library.SaveManager.Folder = "MeuScript"
```

O arquivo é salvo em `FluentSettings/<Título da Janela>.json`.

---

## 10. Métodos da Library

```lua
Library:SetTheme("Arctic")
Library:Destroy()
Library:ToggleBlur(true)
Library:ToggleTransparency(true)
Library:SetWindowTransparency(1.5)

local valor = Library.Options["IdUnico"].Value

if Library.Unloaded then return end
```

---

## 11. Exemplo Completo

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Library/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title    = "My Hub",
    SubTitle = "v1.0",
    Theme    = "Midnight",
    Size     = UDim2.fromOffset(620, 500),
    TabWidth = 160,
})

Library:CreateMinimizer({ Draggable = true })

local CombatTab   = Window:AddTab({ Title = "Combat" })
local VisualTab   = Window:AddTab({ Title = "Visual" })
local SettingsTab = Window:AddTab({ Title = "Settings", SaveManager = true })

local ESPSub   = VisualTab:AddSubTab("ESP")
local ChamsSub = VisualTab:AddSubTab("Chams")

local AimSection = CombatTab:AddSection("Aimbot")

AimSection:AddToggle("Aimbot", {
    Title    = "Aimbot",
    Default  = false,
    Callback = function(v) end,
})

AimSection:AddSlider("AimFOV", {
    Title    = "FOV",
    Min      = 10,
    Max      = 500,
    Default  = 150,
    Rounding = 0,
    Callback = function(v) end,
})

AimSection:AddDropdown("AimPart", {
    Title    = "Target Part",
    Values   = { "Head", "Torso", "HumanoidRootPart" },
    Default  = "Head",
    Callback = function(v) end,
})

AimSection:AddKeybind("AimKey", {
    Title    = "Hold Key",
    Default  = "Q",
    Mode     = "Hold",
    Callback = function(v) end,
})

local ESPSec = ESPSub:AddSection("ESP")

ESPSec:AddToggle("ESPToggle", {
    Title    = "ESP",
    Default  = false,
    Callback = function(v) end,
})

ESPSec:AddColorpicker("ESPColor", {
    Title    = "Box Color",
    Default  = Color3.fromRGB(255, 65, 65),
    Callback = function(v) end,
})

ESPSec:AddDropdown("ESPMode", {
    Title    = "Mode",
    Values   = { "Box", "Skeleton", "Dot" },
    Default  = "Box",
    Callback = function(v) end,
})

local SettSec = SettingsTab:AddSection("Appearance")

SettSec:AddDropdown("Theme", {
    Title    = "Theme",
    Values   = Library.Themes,
    Default  = "Midnight",
    Callback = function(v) Library:SetTheme(v) end,
})

SettSec:AddToggle("Blur", {
    Title    = "Game Blur",
    Default  = true,
    Callback = function(v) Library:ToggleBlur(v) end,
})

SettSec:AddButton({
    Title    = "Save Config",
    Callback = function()
        local ok = Library.SaveManager:Save()
        Library:Notify({
            Title    = "SaveManager",
            Content  = ok and "Config salva!" or "Erro ao salvar.",
            Duration = 3,
        })
    end,
})

SettSec:AddParagraph({
    Title   = "Informações",
    Content = "My Hub v1.0\nDiscord: discord.gg/myhub",
})

Library:Notify({
    Title    = "My Hub",
    Content  = "Carregado com sucesso!",
    Duration = 4,
})
```

---

## Notas Finais

- **IDs dos elementos** devem ser únicos. São usados pelo `SaveManager` e por `Library.Options`.
- **MiniMessage** é suportado em textos: `<red>texto</red>`, `<gradient:#FF0000:#00FF00>gradiente</gradient>`, `<b>negrito</b>`, `<i>itálico</i>`, `<u>sublinhado</u>`.
- O `SaveManager` só funciona fora do Roblox Studio.
- `Acrylic = true` adiciona efeito de profundidade mas pode impactar performance.
