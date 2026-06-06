# Fluent UI — Documentação Completa

Biblioteca de interface gráfica para scripts Roblox. Oferece janelas, abas, elementos interativos e temas visuais.

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

Cole o código-fonte da biblioteca no topo do seu script. Após isso, `Fluent` (ou `Library`) estará disponível globalmente.

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/Library/refs/heads/main/Library.lua"))()
```

---

## 2. Criando a Janela

```lua
local Window = Library:CreateWindow({
    Title          = "Meu Script",       -- Título principal (obrigatório)
    SubTitle       = "v1.0",             -- Subtítulo (opcional)
    Theme          = "Dark",             -- Tema inicial (ver lista abaixo)
    Acrylic        = false,              -- Efeito de vidro fosco (true/false)
    TabWidth       = 150,                -- Largura da barra de abas (padrão: 150)
    Size           = UDim2.fromOffset(600, 480), -- Tamanho da janela
    MinimizeKey    = Enum.KeyCode.LeftControl,   -- Tecla para minimizar
    BackgroundImage = "",                -- URL de imagem de fundo (opcional)
    BackgroundTransparency = 0.5,        -- Transparência do fundo (0–1)
    Icon           = "",                 -- Ícone rbxassetid (opcional)
    Image          = "",                 -- Imagem no topo da aba (opcional)
    Search         = true,               -- Barra de busca de elementos (padrão: true)
    DropdownsOutsideWindow = false,      -- Dropdowns fora da janela (padrão: false)

    -- Informações do usuário no painel lateral (todos opcionais)
    UserInfo          = true,
    UserInfoTitle     = "Player Name",
    UserInfoSubtitle  = "VIP",
    UserInfoSubtitleColor = Color3.fromRGB(255, 200, 0),
    UserInfoTop       = false,           -- Exibir no topo (true) ou rodapé (false)
})
```

---

## 3. Temas Disponíveis

Passe qualquer um desses nomes no campo `Theme` ou em `Library:SetTheme()`:

| Nome       | Descrição                 |
|------------|---------------------------|
| `Dark`     | Cinza escuro clássico      |
| `Darker`   | Ainda mais escuro          |
| `AMOLED`   | Preto puro                 |
| `Light`    | Fundo branco               |
| `Balloon`  | Tons de azul claro         |
| `SoftCream`| Tons creme/bege            |
| `Aqua`     | Verde-azulado              |
| `Amethyst` | Roxo                       |
| `Rose`     | Rosa/vermelho              |
| `Midnight` | Azul meia-noite            |
| `Forest`   | Verde floresta             |
| `Sunset`   | Laranja/pôr do sol         |
| `Ocean`    | Azul oceano                |
| `Emerald`  | Verde esmeralda            |
| `Sapphire` | Azul safira                |
| `Cloud`    | Azul petróleo              |
| `Grape`    | Preto com roxo             |
| `Bloody`   | Vermelho sangue            |
| `Arctic`   | Azul gelo                  |

```lua
Library:SetTheme("Midnight")
```

---

## 4. Abas e Sub-abas

### Aba principal

```lua
local MinhaAba = Window:AddTab({
    Title = "Combat",
    Icon  = "",  -- rbxassetid (opcional)
})
```

### Navegar para uma aba

```lua
Window:SetTab("Combat")   -- por nome
Window:SetTab(1)          -- por índice
```

### Sub-abas (dentro de uma aba)

```lua
local SubA = MinhaAba:AddSubTab("ESP")
local SubB = MinhaAba:AddSubTab("Chams")

-- Adicionar seção dentro de uma sub-aba:
local Secao = SubA:AddSection("Configurações de ESP")
```

---

## 5. Seções

Seções organizam os elementos visualmente dentro de uma aba.

```lua
local MinhaSecao = MinhaAba:AddSection("Título da Seção")

-- Seção com ícone:
local SecaoComIcone = MinhaAba:AddSection("Players", "rbxassetid://...")
```

Todos os elementos são adicionados **dentro de uma seção**:

```lua
MinhaSecao:AddToggle(...)
MinhaSecao:AddSlider(...)
-- etc.
```

---

## 6. Elementos

### Toggle

Botão liga/desliga.

```lua
local MeuToggle = MinhaSecao:AddToggle("IdUnico", {
    Title       = "Aimbot",
    Description = "Descrição opcional",
    Default     = false,               -- Estado inicial
    Callback    = function(Value)
        print("Toggle:", Value)        -- Value = true ou false
    end,
})

-- Escutar mudanças:
MeuToggle:OnChanged(function(Value)
    print("Mudou para:", Value)
end)

-- Alterar valor por código:
MeuToggle:SetValue(true)

-- Ler valor atual:
print(Library.Options["IdUnico"].Value)
```

---

### Slider

Controle deslizante numérico.

```lua
local MeuSlider = MinhaSecao:AddSlider("IdUnico", {
    Title       = "Walk Speed",
    Description = "Velocidade do personagem",
    Min         = 16,       -- Valor mínimo (obrigatório)
    Max         = 500,      -- Valor máximo (obrigatório)
    Default     = 16,       -- Valor inicial (obrigatório)
    Rounding    = 0,        -- Casas decimais (0 = inteiro) (obrigatório)
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

Botão clicável.

```lua
MinhaSecao:AddButton({
    Title       = "Teleportar",
    Description = "Vai ao spawn",
    Callback    = function()
        -- código ao clicar
        Library:Notify({ Title = "OK", Content = "Teleportado!", Duration = 3 })
    end,
})
```

---

### Dropdown

Menu de seleção (single ou multi).

```lua
-- Seleção simples:
local MeuDrop = MinhaSecao:AddDropdown("IdUnico", {
    Title       = "Target Part",
    Description = "Parte para mirar",
    Values      = { "Head", "Torso", "HumanoidRootPart" },
    Default     = "Head",
    Multi       = false,
    Search      = true,    -- Barra de busca interna (padrão: true)
    AllowNull   = false,   -- Permite deselecionar tudo
    Callback    = function(Value)
        print("Selecionado:", Value)
    end,
})

-- Seleção múltipla:
local MultiDrop = MinhaSecao:AddDropdown("IdMulti", {
    Title    = "Partes",
    Values   = { "Head", "Torso", "LeftArm", "RightArm" },
    Default  = { "Head", "Torso" },
    Multi    = true,
    Callback = function(Value)
        -- Value é uma tabela: { Head = true, Torso = true }
        for parte, ativo in pairs(Value) do
            print(parte, ativo)
        end
    end,
})

MeuDrop:OnChanged(function(Value) end)
MeuDrop:SetValue("Torso")
MeuDrop:SetValues({ "Head", "Torso", "LeftLeg" })  -- Recarrega a lista
print(Library.Options["IdUnico"].Value)
```

---

### Keybind

Captura de tecla.

```lua
local MeuBind = MinhaSecao:AddKeybind("IdUnico", {
    Title           = "Aimbot Key",
    Description     = "Tecla para ativar",
    Default         = "Q",          -- Nome da tecla (string)
    Mode            = "Toggle",     -- "Toggle", "Hold" ou "Always"
    Callback        = function(Value)
        -- Chamado quando a tecla é pressionada (Toggle: passa o estado bool)
    end,
    ChangedCallback = function(NewKey)
        print("Nova tecla:", NewKey)
    end,
})

MeuBind:OnChanged(function(Key) end)
MeuBind:SetValue("E", "Hold")  -- (tecla, modo)

-- Verificar estado atual:
if Library.Options["IdUnico"]:GetState() then
    -- Ativo
end
```

**Modos:**
- `"Toggle"` — alterna entre ativo/inativo a cada pressionamento
- `"Hold"` — ativo apenas enquanto a tecla está pressionada
- `"Always"` — sempre ativo, ignora a tecla

---

### Colorpicker

Seletor de cor com suporte a transparência.

```lua
local MeuColor = MinhaSecao:AddColorpicker("IdUnico", {
    Title        = "Cor do ESP",
    Description  = "Escolha a cor",
    Default      = Color3.fromRGB(255, 0, 0),
    Transparency = false,  -- true = habilita canal alpha
    Callback     = function(Color)
        print("Cor:", Color)
    end,
})

MeuColor:OnChanged(function(Color) end)

-- Definir por HSV:
MeuColor:SetValue({ 0, 1, 1 }, 0)  -- { H, S, V }, Transparência

-- Definir por RGB:
MeuColor:SetValueRGB(Color3.fromRGB(0, 255, 100), 0.5)

print(Library.Options["IdUnico"].Value)      -- Color3
print(Library.Options["IdUnico"].Transparency) -- número 0–1
```

---

### Input

Campo de texto livre.

```lua
local MeuInput = MinhaSecao:AddInput("IdUnico", {
    Title       = "Player Name",
    Description = "Nome do alvo",
    Default     = "",
    Placeholder = "Digite aqui...",
    Numeric     = false,   -- true = aceita apenas números
    Finished    = false,   -- true = callback só ao pressionar Enter
    MaxLength   = 50,      -- Limite de caracteres (opcional)
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

Texto informativo somente leitura.

```lua
MinhaSecao:AddParagraph({
    Title   = "Informações",
    Content = "Versão 1.0 | Discord: meuhub.gg\nSuporte a múltiplas linhas.",
})
```

Suporte a MiniMessage (formatação de texto):

```lua
MinhaSecao:AddParagraph({
    Title   = "Colorido",
    Content = "<red>Vermelho</red> | <green>Verde</green> | <gradient:#FF0000:#0000FF>Gradiente</gradient>",
})
```

---

## 7. Notificações

Popups no canto inferior direito da tela.

```lua
Library:Notify({
    Title      = "Título",
    Content    = "Mensagem principal",
    SubContent = "Detalhe adicional (opcional)",
    Duration   = 5,  -- Segundos (nil = não fecha automaticamente)
})

-- Fechar manualmente:
local Notif = Library:Notify({ Title = "...", Content = "..." })
Notif:Close()
```

---

## 8. Minimizador

Botão flutuante para minimizar/restaurar a janela.

```lua
Library:CreateMinimizer({
    Draggable    = true,                          -- Pode arrastar o botão
    Icon         = "rbxassetid://...",            -- Ícone (opcional)
    Size         = UDim2.fromOffset(36, 36),      -- Tamanho
    Position     = UDim2.new(0, 300, 0, 20),      -- Posição inicial
    Acrylic      = false,                         -- Efeito acrílico
    Transparency = 0,                             -- Transparência do fundo
    Corner       = 14,                            -- Raio dos cantos
    Visible      = true,                          -- Visível ao criar
})
```

A tecla configurada em `MinimizeKey` também minimiza a janela.

---

## 9. SaveManager

Sistema de salvar e carregar configurações automaticamente em arquivo JSON.

```lua
-- Salvar manualmente:
local ok, err = Library.SaveManager:Save()
if not ok then print("Erro ao salvar:", err) end

-- Carregar manualmente:
local ok, err = Library.SaveManager:Load()

-- Auto-save (salva sozinho quando qualquer opção muda):
-- Ative passando SaveManager = true na aba desejada:
local SettingsTab = Window:AddTab({
    Title       = "Settings",
    SaveManager = true,   -- ativa o auto-save
})

-- Ignorar um elemento específico do save:
Library.SaveManager.Ignore["IdUnico"] = true

-- Mudar a pasta de saves (padrão: "FluentSettings"):
Library.SaveManager.Folder = "MeuScript"
```

O arquivo é salvo em `FluentSettings/<Título da Janela>.json`.

---

## 10. Métodos da Library

```lua
-- Alterar tema:
Library:SetTheme("Arctic")

-- Destruir a interface completamente:
Library:Destroy()

-- Ativar/desativar blur do jogo:
Library:ToggleBlur(true)

-- Ativar/desativar transparência do painel:
Library:ToggleTransparency(true)

-- Ajustar transparência da janela (0–3, só com Acrylic = true):
Library:SetWindowTransparency(1.5)

-- Acessar qualquer opção pelo ID:
local valor = Library.Options["IdUnico"].Value

-- Verificar se a interface foi destruída:
if Library.Unloaded then return end
```

---

## 11. Exemplo Completo

```lua
-- ============================================================
--  EXEMPLO COMPLETO — Fluent UI
-- ============================================================

local Library = Fluent  -- biblioteca já carregada

-- 1. Janela
local Window = Library:CreateWindow({
    Title    = "My Hub",
    SubTitle = "v1.0",
    Theme    = "Midnight",
    Size     = UDim2.fromOffset(620, 500),
    TabWidth = 160,
})

Library:CreateMinimizer({ Draggable = true })

-- 2. Abas
local CombatTab  = Window:AddTab({ Title = "Combat" })
local VisualTab  = Window:AddTab({ Title = "Visual" })
local SettingsTab = Window:AddTab({ Title = "Settings", SaveManager = true })

-- 3. Sub-abas
local ESPSub   = VisualTab:AddSubTab("ESP")
local ChamsSub = VisualTab:AddSubTab("Chams")

-- 4. Seções e elementos

-- Combat
local AimSection = CombatTab:AddSection("Aimbot")

local Aimbot = AimSection:AddToggle("Aimbot", {
    Title    = "Aimbot",
    Default  = false,
    Callback = function(v)
        -- lógica do aimbot
    end,
})

AimSection:AddSlider("AimFOV", {
    Title    = "FOV",
    Min = 10, Max = 500, Default = 150, Rounding = 0,
    Callback = function(v) end,
})

AimSection:AddDropdown("AimPart", {
    Title   = "Target Part",
    Values  = { "Head", "Torso", "HumanoidRootPart" },
    Default = "Head",
    Callback = function(v) end,
})

AimSection:AddKeybind("AimKey", {
    Title   = "Hold Key",
    Default = "Q",
    Mode    = "Hold",
    Callback = function(v) end,
})

-- Visual > ESP
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
    Title   = "Mode",
    Values  = { "Box", "Skeleton", "Dot" },
    Default = "Box",
    Callback = function(v) end,
})

-- Settings
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
            Title   = "SaveManager",
            Content = ok and "Config salva!" or "Erro ao salvar.",
            Duration = 3,
        })
    end,
})

SettSec:AddParagraph({
    Title   = "Informações",
    Content = "My Hub v1.0\nDiscord: discord.gg/myhub",
})

-- 5. Notificação de boas-vindas
Library:Notify({
    Title    = "My Hub",
    Content  = "Carregado com sucesso!",
    Duration = 4,
})
```

---

## Notas Finais

- **IDs dos elementos** devem ser únicos dentro da mesma sessão. São usados pelo `SaveManager` e por `Library.Options`.
- **MiniMessage** é suportado em textos: `<red>texto</red>`, `<gradient:#FF0000:#00FF00>gradiente</gradient>`, `<b>negrito</b>`, `<i>itálico</i>`, `<u>sublinhado</u>`.
- O `SaveManager` só funciona fora do Roblox Studio (usa `writefile`/`readfile` do executor).
- Acrylic (`Acrylic = true`) adiciona efeito de profundidade mas pode impactar performance.
