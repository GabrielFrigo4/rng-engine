# Regras Canônicas de Domínio & Regras Locais: RNG Engine

> Regras de governança estrita e diretrizes de desenvolvimento para agentes de IA operando no repositório **RNG Engine** (`Personal/Engines/RNG Engine`).

---

## 1. O Paradigma do LÖVE2D Pessoal

1. **Separação Rígida entre Motor e Lógica:**
    - **O Motor (C23 / C++23):** Fornece a infraestrutura de alto desempenho: gerenciamento de janelas com SDL3, pipeline gráfico moderno com SDL_GPU, carregamento de áudio com SDL_Sound e execução de scripts Lua.
    - **A Lógica dos Jogos (Lua 5.5+):** Todas as entidades, mecânicas de gameplay, estados de cena, UI e inteligência artificial do jogo residem em scripts Lua (`main.lua`, `conf.lua`), permitindo _hot-reloading_ e iteração instantânea.
2. **Sem Abstrações Legadas:** Proibido retornar para APIs legadas como SDL2 ou pipelines fixos de OpenGL. O motor utiliza exclusivamente **SDL3** e a abstração moderna **SDL_GPU**.
3. **Áudio Nativo sem Servidores Externos:** O áudio é decodificado e reproduzido diretamente através do **SDL_Sound**.

---

## 2. Padrões de Código & Build

1. **Padrão C23 / C++23 Estrito:** Compilação com `-std=c23` (C) e `-std=c++23` (C++), flags estritas de aviso (`-Wall -Wextra -Wpedantic -Wconversion`) e zero dependência de comandos batch legados.
2. **Purga de Scripts Fora do Padrão:** Proibição de arquivos temporários de lote como `#*.cmd` ou atalhos fora das convenções POSIX.
3. **Formatação Rigorosa:** Todo código C/C++ deve ser formatado com `clang-format` e toda documentação com `prettier`.

---

## 3. Invariantes de Engenharia

1. **Invariante Hermetismo de Produção:** O motor gráfico e os jogos nunca podem depender de `.agents/` ou skills.
2. **Invariante Out-of-the-Box:** Modos octais canônicos no Git Index (`0755` para scripts/hooks, `0644` para fontes, shaders e documentação).
3. **Tipografia Reader-First:** Documentações utilizam badges vetoriais (SVG) e evitam excesso de emojis.
