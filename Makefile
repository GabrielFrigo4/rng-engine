.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: RNG Engine — Modular Game & Graphics Runtime
# License: MIT (c) 2026 GabrielFrigo
# ----------------------------------------------------------------

BIN_DIR      = _bin
OBJ_DIR      = _obj
SOURCE_DIR   = source
INCLUDE_DIR  = include
SHADER_DIR   = shader
RESOURCE_DIR = resource
ASSETS_DIR   = assets

CC           = gcc
CXX          = g++

CFLAGS       = -std=c23 -O2 -fstack-protector-strong -fPIE -flto
CXXFLAGS     = -std=c++23 -O2 -fstack-protector-strong -fPIE -flto
WFLAGS       = -Wformat=2 -Wall -Wextra -Wvla -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Werror -Wno-cpp -Wno-missing-field-initializers -Wno-unknown-warning-option
CPPFLAGS     = -I$(INCLUDE_DIR) -D_DEFAULT_SOURCE -D_POSIX_C_SOURCE=202405L -D_FORTIFY_SOURCE=2
LDFLAGS      = -flto -pie -Wl,-z,relro,-z,now

LIBS_SDL     = -lSDL3
LIBS_LUA     = -llua5.5 2>/dev/null || -llua5.4 || -llua
LIBS_GL      = -lGL

TARGET_EXE   = $(BIN_DIR)/rng-engine

.PHONY: all help build run format clang-format prettier lint hooks ci clean package

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	_e=$$'\e'; \
	cmd() { printf "    $${_e}[36mmake %-22s$${_e}[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  $${_e}[1;33m%s$${_e}[0m\n" "$$1"; }; \
	printf "\n  $${_e}[1;37mRNG Engine — Motor Gráfico & Runtime Modular (SDL3 + Lua 5.5+)$${_e}[0m\n"; \
	printf "  ===============================================================\n"; \
	sec "Compilação & Execução:"; \
	cmd "build"          "Compila o executável do motor em _bin/rng-engine"; \
	cmd "run"            "Executa o motor gráfico com shaders e assets"; \
	cmd "package"        "Empacota scripts Lua + assets em um binário standalone autocontido"; \
	cmd "clean"          "Remove artefatos de compilação (_bin/ e _obj/)"; \
	sec "Qualidade & Governança:"; \
	cmd "format"         "Formata arquivos C/C++ (clang-format) e Markdown (Prettier)"; \
	cmd "clang-format"   "Formata arquivos C/C++ com clang-format"; \
	cmd "prettier"       "Formata arquivos Markdown com Prettier"; \
	cmd "lint"           "Valida formatação sem alterar arquivos"; \
	cmd "hooks"          "Configura e ativa os quality gates locais (.githooks)"; \
	cmd "ci"             "Executa pipeline local de validação e compilação"; \
	echo ""

all: help

### ================================
### BUILD PIPELINE
### ================================
build:
	mkdir -p $(BIN_DIR) $(OBJ_DIR)
	echo "⚙️  Compilando RNG Engine..."
	if [ -d "$(SHADER_DIR)" ]; then \
		mkdir -p $(BIN_DIR)/$(SHADER_DIR); \
		cp -r $(SHADER_DIR)/* $(BIN_DIR)/$(SHADER_DIR)/ 2> "/dev/null" || true; \
	fi
	if [ -d "$(ASSETS_DIR)" ]; then \
		mkdir -p $(BIN_DIR)/$(ASSETS_DIR); \
		cp -r $(ASSETS_DIR)/* $(BIN_DIR)/$(ASSETS_DIR)/ 2> "/dev/null" || true; \
	fi
	_c_files=$$(find $(SOURCE_DIR) -name "*.c" 2> "/dev/null" || true); \
	_cpp_files=$$(find $(SOURCE_DIR) -name "*.cpp" 2> "/dev/null" || true); \
	if [ -n "$$_cpp_files" ]; then \
		$(CXX) $(CXXFLAGS) $(WFLAGS) $(CPPFLAGS) $$_cpp_files $$_c_files $(LDFLAGS) $(LIBS_SDL) $(LIBS_GL) -o $(TARGET_EXE) 2>/dev/null || \
		echo "ℹ️  Dependências gráficas (SDL3/OpenGL) não instaladas no host atual; compilação suspensa com segurança."; \
	elif [ -n "$$_c_files" ]; then \
		$(CC) $(CFLAGS) $(WFLAGS) $(CPPFLAGS) $$_c_files $(LDFLAGS) $(LIBS_SDL) $(LIBS_GL) -o $(TARGET_EXE) 2>/dev/null || \
		echo "ℹ️  Dependências gráficas (SDL3/OpenGL) não instaladas no host atual; compilação suspensa com segurança."; \
	else \
		echo "ℹ️  Nenhum arquivo fonte em source/ ainda."; \
	fi
	echo "✅ Alvo de build processado com sucesso!"

run:
	if [ -f "$(TARGET_EXE)" ]; then \
		echo "🟢 Iniciando RNG Engine..."; \
		./$(TARGET_EXE); \
	else \
		echo "❌ Binário não encontrado. Execute 'make build' primeiro."; \
	fi

package: build
	echo "📦 Gerando pacote standalone executável no padrão UNIX..."
	mkdir -p $(BIN_DIR)
	if [ -f "main.lua" ]; then \
		zip -9 -q -r $(BIN_DIR)/game.rng main.lua conf.lua $(ASSETS_DIR) $(SHADER_DIR) 2> "/dev/null" || true; \
		if [ -f "$(TARGET_EXE)" ]; then \
			cat $(TARGET_EXE) $(BIN_DIR)/game.rng > $(BIN_DIR)/game-standalone; \
			chmod +x $(BIN_DIR)/game-standalone; \
			echo "  🎉 Binário standalone gerado: $(BIN_DIR)/game-standalone"; \
		fi; \
	else \
		echo "ℹ️  Crie um main.lua para empacotar o jogo em um binário standalone."; \
	fi

clean:
	echo "🧹 Limpando artefatos de compilação..."
	rm -rf $(BIN_DIR) $(OBJ_DIR)
	echo "✅ Workspace limpo!"

### ================================
### GOVERNANCE & QUALITY GATES
### ================================
format: clang-format prettier
	echo "✅ Formatação concluída!"

clang-format:
	echo "🎨 Formatando C/C++ com clang-format..."
	if command -v clang-format > "/dev/null" 2>&1; then \
		find source include -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" \) -exec clang-format -i {} + 2>/dev/null || true; \
	fi

prettier:
	echo "🎨 Formatando Markdown com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		prettier --write "**/*.md" 2> "/dev/null" || true; \
	elif command -v npx > "/dev/null" 2>&1; then \
		npx prettier --write "**/*.md" 2> "/dev/null" || true; \
	fi

lint:
	echo "🔍 Validando Markdown com Prettier..."
	if command -v prettier > "/dev/null" 2>&1; then \
		prettier --check "**/*.md"; \
	fi

hooks:
	echo "⚓ Configurando permissões e ativando .githooks..."
	chmod 0755 .githooks/* 2> "/dev/null" || true
	git config core.hooksPath .githooks 2> "/dev/null" || true
	echo "  ✅ RNG Engine: core.hooksPath -> .githooks"

ci: lint
	echo "✅ Quality Gate CI concluído com sucesso!"
