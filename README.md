# Recuperação de Arquivos (File Carving)

Script em Bash para recuperação de arquivos perdidos ou deletados em dispositivos de armazenamento, usando o `foremost`. A técnica é conhecida como **file carving**: os arquivos são reconstruídos a partir de suas assinaturas binárias, sem depender do sistema de arquivos ou dos metadados originais.

Criado por **Luciano Ramone (Ram0n3)** — 2023.
Versão melhorada em 2026.

---

## Requisitos

- Sistema Linux (recomendado: Kali Linux)
- `bash`
- Usuário **root**
- `foremost` (o script instala automaticamente via `apt` caso não esteja presente)

---

## Instalação

```bash
git clone <url-do-repositorio>
cd <pasta-do-repositorio>
chmod +x recuperacao.sh
```

---

## Uso

```bash
sudo ./recuperacao.sh
```

### Passo a passo

1. O script verifica se está sendo executado como root e se o `foremost` está instalado.
2. Lista os dispositivos conectados (via `fdisk -l`) para você identificar o dispositivo de origem, por exemplo `/dev/sdb`.
3. Informe os tipos/extensões de arquivo a recuperar, separados por vírgula (ex: `jpg,png,pdf`), ou `all` para recuperar todos os formatos suportados.
4. Informe o local do dispositivo (ex: `/dev/sdb`).
5. Aguarde a recuperação. Um diretório `backup_HORAMINUTOSEGUNDO_DIAMES` é criado no diretório atual com os arquivos recuperados.

### Exemplo

```
Tipos/extensões de arquivos (separados por virgula,) all para todos: jpg,png,pdf
Local do dispositivo (ex: /dev/sdb): /dev/sdb
```

---

## Formatos aceitos

`jpg, gif, png, bmp, avi, exe, mpg, wav, riff, wmv, mov, pdf, ole, doc, zip, rar, htm, cpp, mp4`

Para recuperar todos os formatos suportados de uma vez, use `all`.

---

## Saída

Dentro da pasta `backup_*` gerada, os arquivos recuperados ficam organizados em subpastas por tipo (ex: `png`, `jpg`). Como a recuperação é feita por assinatura binária:

- Os arquivos **perdem os metadados e nomes originais**, recebendo títulos numerados.
- É gerado um arquivo de log chamado `audit.txt` dentro da pasta, com todas as informações da recuperação.

---

## Aviso

- É necessário rodar como **root**, pois o acesso direto ao dispositivo (`/dev/sdX`) exige privilégios elevados.
- Confirme o caminho do dispositivo em `fdisk -l` antes de continuar — apontar para o disco errado pode levar à leitura de dados incorretos ou indesejados.
- O processo pode demorar dependendo do tamanho do dispositivo e da quantidade de arquivos a recuperar.

---

## Como funciona

O script é dividido em funções:

| Função | Descrição |
|---|---|
| `mostrar_intro` | Exibe a introdução e instruções de uso |
| `verificar_root` | Garante que o script está sendo executado como root |
| `verificar_foremost` | Verifica se o `foremost` está instalado e instala se necessário |
| `listar_dispositivos` | Lista os dispositivos conectados via `fdisk -l` |
| `solicitar_dados` | Pede o formato dos arquivos e o local do dispositivo |
| `recuperar_arquivos` | Cria a pasta de backup e executa o `foremost` |
| `mostrar_final` | Exibe o resumo final e a data/hora de conclusão |
| `main` | Controla a ordem de execução |

---

## Histórico de versões

- **2023** — Versão original, criada por Luciano Ramone (Ram0n3).
- **2026** — Código reorganizado em funções, indentação padronizada, tratamento de erro do `foremost` e ajuste na ordem de exibição das mensagens durante a recuperação.

---

## Licença

© 2023–2026 Luciano Ramone (Ram0n3)
