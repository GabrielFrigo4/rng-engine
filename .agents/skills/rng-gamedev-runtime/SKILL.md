---
name: rng-gamedev-runtime
description: >-
    Runbook cognitivo e manual de desenvolvimento de jogos para o RNG Engine.
    Use ao criar ou modificar o runtime C23/C++23, integrar a pipeline gráfica SDL_GPU,
    manipular shaders SPIR-V/WGSL, implementar decodificação de áudio via SDL_Sound,
    ou desenvolver jogos e bindings em Lua 5.5+ no estilo LÖVE2D.
---

# RNG Engine GameDev Runtime Runbook

Este runbook instrui agentes de Inteligência Artificial sobre as convenções de arquitetura, ciclo de vida e técnicas de gamedev no **RNG Engine** (LÖVE2D pessoal).

---

## 1. O Loop de Jogo (Game Loop) & Ciclo de Vida

Inspirado no LÖVE2D, o motor C expõe um ciclo de eventos previsível para o script Lua:

```lua
-- main.lua (Exemplo de Jogo)
function rng.load()
    rng.graphics.setBackgroundColor(0.05, 0.05, 0.08)
    player = { x = 400, y = 300, speed = 250 }
end

function rng.update(dt)
    if rng.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    if rng.keyboard.isDown("left")  then player.x = player.x - player.speed * dt end
end

function rng.draw()
    rng.graphics.setColor(0.2, 0.8, 1.0)
    rng.graphics.rectangle("fill", player.x, player.y, 40, 40)
end
```

---

## 2. A Pipeline Gráfica: SDL_GPU

Em vez de chamadas de desenho manuais por pixel:

- **Command Buffers:** Todos os passos de renderização são gravados em _command buffers_ assíncronos e submetidos em lote para a GPU.
- **Pipeline States:** Pipelines de shaders são compilados e cacheados na inicialização, eliminando _stuttering_ durante a execução.
- **Shaders SPIR-V / WGSL:** Shaders residem em `shader/` e são compilados em tempo de build para o backend gráfico nativo (Vulkan, DX12, Metal).

---

## 3. Áudio com SDL_Sound

- **Formatos Suportados:** Decodificação direta de WAV, OGG Vorbis, FLAC e MP3.
- **Buffers de Streaming:** Trilha sonora reproduzida em streaming assíncrono para economizar memória RAM; efeitos curtos carregados em amostras estáticas pré-decodificadas.

---

## 4. Invariantes de Desenvolvimento

- **Hot-Reloading:** O motor monitora alterações em arquivos `.lua` e recarrega módulos sem derrubar a janela.
- **Memória Estéril:** Evitar alocações excessivas no `rng.update` ou `rng.draw` para não sobrecarregar o _garbage collector_ do Lua.
- **Compilação Sem Warnings:** Fontes C/C++ devem compilar limpos com `-Wall -Wextra -Wpedantic -Wconversion`.

---

## 5. Empacotamento Standalone (O Jeito UNIX)

Para criar um executável único para distribuição:

```sh
# Gera o binário _bin/game-standalone fundindo o motor ao zip do jogo
make package
```

Mecanismo: o runtime C23/C++23 examina o arquivo executável em busca da assinatura de cabeçalho `PK\x03\x04` ao final do arquivo (`fseek` para o final e montagem de VFS). Se encontrada, carrega os recursos e dispara o `main.lua` sem depender de diretórios externos.
