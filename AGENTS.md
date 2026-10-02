# 🤖 AGENTS.md — Diretrizes para Agentes de IA no RNG Engine

Bem-vindo ao repositório **RNG Engine** (`Personal/Engines/RNG Engine`). Este documento é a constituição primária e instrução mandatória para agentes de Inteligência Artificial operando nesta base de código.

---

## 1. Identidade e Papel

O **RNG Engine** é um motor gráfico modular e runtime de jogos concebido como um "LÖVE2D pessoal", combinando um núcleo nativo de alto desempenho em C23/C++23 com um ambiente de desenvolvimento em Lua 5.5+.

- **Stack:** C23 / C++23, SDL3, SDL_GPU, SDL_Sound, Lua 5.5+, POSIX.1-2024.
- **Foco:** Games 2D/3D leves, shaders na GPU, áudio espacial e execução multiplataforma (Linux, FreeBSD, Windows).

---

## 2. Regras Críticas Soberanas

1. **Separação de Camadas:** O núcleo em C/C++ lida com hardware, janelas SDL3, comandos para SDL_GPU e FFI. A lógica de jogos deve residir em scripts Lua.
2. **Padrão C23 / C++23 Estrito:** Código compilado sem warnings (`-Wall -Wextra -Wpedantic -Wconversion`). Uso de atributos `[[nodiscard]]` e tipos seguros.
3. **Invariante Hermetismo de Produção:** O motor e jogos nunca podem depender de `.agents/`. A deleção de `.agents/` não deve impactar o funcionamento do binário.
4. **Invariante Out-of-the-Box:** Modos octais no Git Index canônicos (`0755` para scripts e hooks, `0644` para fontes, shaders e documentação).
5. **Zero Cruft:** Proibição de arquivos de lote temporários ou scripts fora do padrão (ex: purga de arquivos `#*.cmd`).
6. **Commits Semânticos:** Mensagens no formato `<type>(<scope>): <descrição>` com verbos convencionais.

---

## 3. Boy Scout Rule

Sempre deixe o acampamento mais limpo do que encontrou:

- [ ] Elimine temporários de build (`_bin/`, `_obj/`) e arquivos de dump.
- [ ] Mantenha títulos de documentação com badges vetoriais sem excesso de emojis.
- [ ] Valide formatação com `make lint` e `make format`.

---

## 4. Comandos de Verificação Rápidos

| Comando       | Descrição                                        |
| :------------ | :----------------------------------------------- |
| `make help`   | Exibe o menu interativo com alvos disponíveis    |
| `make build`  | Compila o executável do motor em _bin/rng-engine |
| `make run`    | Executa o motor com shaders e assets             |
| `make format` | Formata fontes C/C++ (clang-format) e Markdown   |
| `make lint`   | Valida formatação sem alterar arquivos           |
| `make hooks`  | Ativa os githooks locais com permissões 0755     |
| `make ci`     | Executa pipeline de validação de qualidade       |

---

## 5. Referências Obrigatórias

- [Documentação Arquitetural](README.md)
- [Regras de Agentes](.agents/rules/principles.md)
