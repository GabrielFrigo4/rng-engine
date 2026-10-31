# 🤖 RNG Engine — AI Agent Briefing

> Motor gráfico modular e runtime de jogos concebido como um ambiente ágil ("LÖVE2D pessoal"), combinando um núcleo nativo de alto desempenho em C23/C++23 com um ambiente de desenvolvimento em Lua 5.5+.

---

## 🧭 Identidade e Papel

O **RNG Engine** provê arquitetura para jogos 2D/3D leves, shaders acelerados na GPU, áudio espacial e execução multiplataforma determinística.

- **Stack Primária:** C23 / C++23, SDL3, SDL_GPU, SDL_Sound, Lua 5.5+, POSIX.1-2024
- **Foco:** Games modulares, renderização moderna via GPU, pipelines limpos e portabilidade (Linux, FreeBSD, Windows)

---

## 📁 Estrutura Canônica de Arquivos

```text
RNG Engine/
├── assets/                    # Texturas, fontes e mapas
├── include/                   # Headers públicos (.h / .hpp)
├── resource/                  # Assets estáticos empacotados
├── shader/                    # Shaders GPU (SPIR-V, WGSL, GLSL)
├── source/                    # Implementação do motor (.c / .cpp)
├── .agents/                   # Governança e runbooks locais de IA
├── AGENTS.md                  # Constituição e briefing para agentes de IA
├── LICENSE                    # Licença MIT
├── Makefile                   # Orquestrador POSIX silencioso
├── PRINCIPLES.md              # 22 Princípios de Engenharia aplicados
└── README.md                  # Documentação arquitetural do motor
```

---

## ⚠️ Regras Críticas para Agentes de IA

1. **Separação de Camadas:** O núcleo em C/C++ gerencia hardware, janelas SDL3, comandos para SDL_GPU e bindings FFI. A lógica de jogos e entidades reside estritamente em scripts Lua.
2. **Padrão C23 / C++23 Estrito:** Código compilado sem advertências (`-Wall -Wextra -Wpedantic -Wconversion`). Uso obrigatório de atributos `[[nodiscard]]` e tipos seguros.
3. **Hermetismo de Produção (`rm -rf .agents`):** O motor e jogos nunca devem depender de `.agents/`. A deleção de `.agents/` não deve impactar o funcionamento do binário.
4. **Invariante Out-of-the-Box:** Modos octais no Git Index rigorosamente canônicos (`0755` para scripts e hooks, `0644` para fontes, shaders e documentação).
5. **Zero Cruft:** Proibição de arquivos de lote temporários ou scripts fora do padrão (purga de scripts ad-hoc e temporários).
6. **Commits Semânticos:** Mensagens no formato `<type>(<scope>): <descrição>` com verbos convencionais.

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA atua de forma proativa na manutenção e aplicação dos padrões canônicos deste repositório.

Ao identificar linhas ou artefatos fora dos padrões estabelecidos:

1. **Notificar concisamente** o usuário sobre o ajuste realizado.
2. **Corrigir a inconformidade**, aplicando o padrão correspondente:
    - **Comentários Narrativos:** Eliminar comentários óbvios que apenas narram código executável.
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo.
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI & Escapes:** Não use octais (`\033`, `\001`) para caracteres ou escapes. Use `[ -t 1 ] && echo -n $'\e...'` ou notação hexadecimal (`\x01`, `\x1b`). Octal é exclusivo para permissões POSIX (`chmod 0755`, `chmod 0644`, `umask`).
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).
    - **Invariante Out-of-the-Box:** Garantir modos octais corretos no Git Index e auto-cura em tempo de execução sem requerer intervenção manual pós-clone.
    - **Emissão Semântica de UI:** Substituir `echo` avulsos com emojis pelas rotinas canônicas `_ui_*`.
    - **Antifragilidade & Resiliência:** Resolução ativa de caminhos em cascata, auto-cura de permissões (0600 em chaves/segredos) e validação defensiva de pré-requisitos.
    - **Curadoria Cognitiva:** Capturar decisões estruturais e regras tácitas em skills locais compactas (`.agents/skills/`), mantendo-as atualizadas e expurgando ruído obsoleto.
    - **Refatoração Sem Legado:** Expurgar aliases obsoletos, variáveis mortas e shims de compatibilidade em renomeações.
    - **Elevação Antifrágil & Shift Seguro:** Usar o bloco explícito `if [ "$(id -u)" -ne 0 ]` para resolução de `ELEVATE` (evitando término fatal sob `set -e` como root) e proteger todo comando `shift` com validação prévia de parâmetros (`[ "$#" -ge N ] && shift N`).
    - **Simetria de Documentação:** Mover regras ou invariantes universais documentadas erroneamente em sub-membros específicos para o documento de arquitetura do grupo correspondente, eliminando falsas assimetrias.

---

## 🚀 Comandos de Verificação Rápida (Quality Gates)

| Comando             | Finalidade Operacional                                         |
| :------------------ | :------------------------------------------------------------- |
| `make help`         | Exibe o catálogo interativo com alvos disponíveis              |
| `make build`        | Compila o executável do motor em `_bin/rng-engine`             |
| `make run`          | Executa o motor com shaders e assets configurados              |
| `make format`       | Formata fontes C/C++ (clang-format) e Markdown (Prettier)      |
| `make clang-format` | Formata apenas o código-fonte C/C++ com clang-format           |
| `make prettier`     | Formata arquivos Markdown com Prettier                         |
| `make lint`         | Valida formatação sem alterar arquivos                         |
| `make hooks`        | Configura permissões `0755` nos githooks locais                |
| `make ci`           | Executa pipeline local de validação de qualidade               |
| `make clean`        | Remove artefatos de compilação intermediários (`_bin`, `_obj`) |

---

## 📖 Referências Obrigatórias

Antes de qualquer modificação neste ecossistema, consulte:

- [README.md](README.md) — Documentação arquitetural do motor
- [PRINCIPLES.md](PRINCIPLES.md) — Os 22 Princípios de Engenharia Soberanos
- [LICENSE](LICENSE) — Licença do projeto
- [.agents/rules/principles.md](.agents/rules/principles.md) — Regra de Princípios
- [.agents/skills/rng-gamedev-runtime/SKILL.md](.agents/skills/rng-gamedev-runtime/SKILL.md) — Runbook de GameDev e Shaders GPU
