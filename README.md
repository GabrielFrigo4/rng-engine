# RNG Engine — O LÖVE2D Pessoal

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?logo=open-source-initiative&logoColor=white)](LICENSE)
[![C Standard: C23](https://img.shields.io/badge/C_Standard-C23-blue.svg?logo=c&logoColor=white)](include/)
[![C++ Standard: C++23](https://img.shields.io/badge/C%2B%2B_Standard-C%2B%2B23-blue.svg?logo=cplusplus&logoColor=white)](source/)
[![Graphics: SDL3 + SDL_GPU](https://img.shields.io/badge/Graphics-SDL3_%2B_SDL__GPU-purple.svg?logo=vulkan&logoColor=white)](shader/)
[![Audio: SDL_Sound](https://img.shields.io/badge/Audio-SDL__Sound-darkgreen.svg)](resource/)
[![Scripting: Lua 5.5+](https://img.shields.io/badge/Engine-Lua_5.5%2B-blue.svg?logo=lua&logoColor=white)](source/)
[![POSIX: 2024](https://img.shields.io/badge/POSIX-2024-purple.svg?logo=freebsd&logoColor=white)](Makefile)

O **RNG Engine** é um motor gráfico e runtime 2D/3D modular concebido como um "LÖVE2D pessoal": uma plataforma de altíssimo desempenho perto do metal, onde o núcleo de hardware é escrito em **C23/C++23** sobre a stack moderna **SDL3 + SDL_GPU + SDL_Sound**, expondo um ambiente expressivo e divertido em **Lua 5.5+** para criação rápida de jogos, protótipos e simulações visuais.

---

## Arquitetura: Núcleo Nativo & Scripting em Lua

```text
+--------------------------------------------------------------+
|                    JOGOS & SCRIPTS (LUA 5.5+)                |
|       love.update(dt) • love.draw() • Shaders • Entidades    |
+--------------------------------------------------------------+
                               | Bindings Diretos de C/Lua
+--------------------------------------------------------------+
|                    RNG ENGINE RUNTIME (C23 / C++23)          |
|   Ciclo de Janelas (SDL3) • Pipeline Gráfico (SDL_GPU)       |
|   Sistema de Som (SDL_Sound) • I/O Não-Bloqueante POSIX      |
+--------------------------------------------------------------+
                               | Hardware & Drivers
+--------------------------------------------------------------+
|     Vulkan (Linux/FreeBSD) • DX12 (Windows) • Metal (macOS)   |
+--------------------------------------------------------------+
```

### Por que um runtime inspirado no LÖVE2D?

- **Foco na Criatividade:** Em vez de recompilar código C++ a cada mudança de cor ou posição, a lógica do jogo vive em arquivos Lua carregados dinamicamente com suporte a _hot-reloading_.
- **Vanguarda Tecnológica:** O LÖVE2D tradicional ainda carrega raízes em SDL2 e OpenGL arcaico. O **RNG Engine** salta diretamente para o **SDL3** e o **SDL_GPU** (renderização nativa sobre Vulkan/DX12 sem abstrações pesadas).
- **Áudio Nativo sem Dependências Ocultas:** Integração direta com **SDL_Sound** para decodificação e streaming de múltiplos formatos de áudio sem travamentos na thread principal.

### A Filosofia de Distribuição Standalone (O Jeito UNIX de Empacotar)

O RNG Engine herda a genialidade do LÖVE2D na distribuição de binários finais: **o jogo inteiro pode ser fundido diretamente ao executável do motor em um único arquivo binário autocontido**, sem necessidade de instaladores complexos ou empacotadores obscuros:

1. **Compactar o Jogo em um Pacote:**
   Compacte seus scripts Lua, shaders e assets em um arquivo `.zip` (ou `.rng`):

    ```sh
    zip -9 -r game.rng main.lua conf.lua assets/ shader/
    ```

2. **Fusão Binária Canônica (Simplicidade UNIX):**
   Concatene o binário do motor ao pacote zipado:
    - **No Linux e FreeBSD:**
        ```sh
        cat _bin/rng-engine game.rng > meu-jogo && chmod +x meu-jogo
        ```
    - **No Windows:**
        ```cmd
        copy /b _bin\rng-engine.exe + game.rng meu-jogo.exe
        ```

3. **Execução Transparente:**
   Ao ser executado, o motor detecta a assinatura ZIP anexada ao próprio binário, monta o VFS na memória e inicializa o jogo instantaneamente. Um arquivo único, independente e 100% soberano.

---

## Módulos da Engine

- **`source/`**: Ponto de entrada nativo, inicialização da janela SDL3, carregador do estado Lua e despacho de renderização.
- **`include/`**: Headers C23 e C++23 com definições de tipos e interfaces de binding.
- **`shader/`**: Shaders modernos compatíveis com SDL_GPU (SPIR-V / WGSL / HLSL).
- **`assets/`**: Sprites, fontes TTF e texturas do jogo.
- **`resource/`**: Efeitos sonoros, trilhas musicais e arquivos de dados.

---

## Compilação & Execução

O motor adota um Makefile POSIX silencioso compatível com Linux, FreeBSD e Windows (MSYS2):

```sh
# Exibir o menu interativo com os alvos disponíveis
make help

# Compilar o motor
make build

# Executar a aplicação
make run

# Formatar o código-fonte C/C++ e Markdown
make format

# Executar os quality gates locais
make ci
```

---

## Licença

Distribuído sob a licença soberana **MIT**. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.
