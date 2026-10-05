#!/usr/bin/env bash
# Verificação da seção "Páginas" da central de ajuda (paginas/).
# Só lê arquivos do repositório; não faz requisição de rede.
# Uso: bash scripts/verificar-ajuda.sh   (sai com 0 se tudo ok, 1 se houver qualquer falha)
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"

PASTA="paginas"
ARTIGOS=(publicar dominio editar blog crm-no-celular)
FALHAS=0

ok()    { echo "ok: $1"; }
falha() { echo "FALHA: $1"; FALHAS=$((FALHAS + 1)); }

# --- 1. Existência dos seis arquivos (RF-01) ---
TODOS=("$PASTA/index.html")
for a in "${ARTIGOS[@]}"; do TODOS+=("$PASTA/$a.html"); done

PRESENTES=()
for f in "${TODOS[@]}"; do
  if [ -f "$f" ]; then
    PRESENTES+=("$f")
  else
    falha "arquivo ausente: $f"
  fi
done
[ "${#PRESENTES[@]}" -eq "${#TODOS[@]}" ] && ok "os 6 arquivos de $PASTA/ existem"

# Artigos presentes (os cinco, sem o índice)
ARTIGOS_PRESENTES=()
for a in "${ARTIGOS[@]}"; do
  [ -f "$PASTA/$a.html" ] && ARTIGOS_PRESENTES+=("$PASTA/$a.html")
done

# Conteúdo do arquivo em uma linha só (tags podem quebrar linha)
uma_linha() { tr '\n\r\t' '   ' < "$1"; }

# --- 2. Estrutura de cada página (RF-01, RNF-01) ---
for f in "${PRESENTES[@]}"; do
  if grep -q '<html lang="pt-br"' "$f"; then ok "$f: lang=\"pt-br\""; else falha "$f: falta <html lang=\"pt-br\">"; fi

  titulo="$(uma_linha "$f" | grep -oP '<title>\K[^<]*' | head -n1 | tr -d ' ' || true)"
  if [ -n "$titulo" ]; then ok "$f: <title> preenchido"; else falha "$f: <title> ausente ou vazio"; fi

  n_h1="$(grep -o '<h1[ >]' "$f" | wc -l)"
  if [ "$n_h1" -eq 1 ]; then ok "$f: exatamente um h1"; else falha "$f: $n_h1 elementos h1 (esperado 1)"; fi

  if grep -q '<meta name="viewport"' "$f"; then ok "$f: meta viewport"; else falha "$f: falta meta viewport"; fi
done

# --- 3. Estrutura exclusiva dos artigos ---
for f in "${ARTIGOS_PRESENTES[@]}"; do
  if grep -q '— Central de ajuda Unum People</title>' "$f"; then ok "$f: título no formato do spec"; else falha "$f: <title> fora do formato '{Título} — Central de ajuda Unum People'"; fi

  if grep -q 'mailto:atendimento@unumpeople.com.br' "$f"; then ok "$f: mailto de atendimento"; else falha "$f: falta mailto:atendimento@unumpeople.com.br"; fi

  if grep -q 'Para quem é:' "$f"; then ok "$f: linha 'Para quem é:'"; else falha "$f: falta 'Para quem é:'"; fi
  if grep -q 'Algo não funcionou?' "$f"; then ok "$f: caixa 'Algo não funcionou?'"; else falha "$f: falta a caixa 'Algo não funcionou?'"; fi
  if grep -q 'Voltar à central de ajuda' "$f"; then ok "$f: link 'Voltar à central de ajuda'"; else falha "$f: falta o link 'Voltar à central de ajuda'"; fi
  if grep -q 'href="\./"' "$f" && grep -q 'href="\.\./"' "$f"; then ok "$f: trilha com links para ../ e ./"; else falha "$f: trilha precisa de links para ../ e ./"; fi

  # Passos: <li> dentro de <ol>; mínimo 3 e nenhum vazio (RF-07)
  # Saída do awk: "<total> <vazios>"
  contagem="$(uma_linha "$f" | awk '
    {
      s = $0; dentro = 0; total = 0; vazios = 0
      while (length(s) > 0) {
        match(s, /<\/?(ol|li)[ >]/)
        if (RSTART == 0) break
        tag = substr(s, RSTART, RLENGTH)
        s = substr(s, RSTART + RLENGTH)
        if (tag ~ /^<ol/) { dentro = 1 }
        else if (tag ~ /^<\/ol/) { dentro = 0 }
        else if (tag ~ /^<li/ && dentro) {
          # conteúdo até o próximo </li>
          fim = index(s, "</li>")
          corpo = (fim > 0) ? substr(s, 1, fim - 1) : s
          gsub(/<[^>]*>/, "", corpo); gsub(/[ ]|&nbsp;/, "", corpo)
          total++
          if (length(corpo) == 0) vazios++
        }
      }
      print total, vazios
    }')"
  total="${contagem% *}"; vazios="${contagem#* }"
  if [ "$total" -ge 3 ]; then ok "$f: $total passos numerados (>= 3)"; else falha "$f: $total passos em <ol> (mínimo 3)"; fi
  if [ "$vazios" -eq 0 ]; then ok "$f: nenhum passo vazio"; else falha "$f: $vazios passo(s) vazio(s)"; fi
done

# --- 4. Expressões proibidas em paginas/ (RF-04 + recursos adiados) ---
PROIBIDAS=("google ads" "app android" "aplicativo android" "landing page" "play store" "app store")
ADIADAS=("portal do cliente" "cancelamento" "nova página")
achou=0
for f in "${PRESENTES[@]}"; do
  for expr in "${PROIBIDAS[@]}"; do
    if grep -qiF -- "$expr" "$f"; then falha "$f contém expressão proibida: \"$expr\""; achou=1; fi
  done
done
[ "$achou" -eq 0 ] && ok "nenhuma expressão proibida (RF-04) em $PASTA/"
achou=0
for f in "${PRESENTES[@]}"; do
  for expr in "${ADIADAS[@]}"; do
    if grep -qiF -- "$expr" "$f"; then falha "$f cita recurso adiado: \"$expr\""; achou=1; fi
  done
done
[ "$achou" -eq 0 ] && ok "nenhuma menção a recurso adiado em $PASTA/"

# --- 5. Links relativos resolvem para arquivo existente (RF-05) ---
quebrados=0
for f in "${PRESENTES[@]}"; do
  while IFS= read -r alvo; do
    [ -z "$alvo" ] && continue
    case "$alvo" in
      http://*|https://*|//*|mailto:*|tel:*|javascript:*|data:*|\#*) continue ;;
    esac
    caminho="${alvo%%#*}"; caminho="${caminho%%\?*}"
    [ -z "$caminho" ] && continue
    destino="$(dirname "$f")/$caminho"
    if [ -d "$destino" ]; then destino="${destino%/}/index.html"; fi
    if [ ! -f "$destino" ]; then falha "$f: link relativo quebrado: $alvo"; quebrados=1; fi
  done < <(uma_linha "$f" | grep -oP '(?:href|src)="\K[^"]*' || true)
done
[ "$quebrados" -eq 0 ] && ok "todos os links relativos de $PASTA/ resolvem"

# --- 6. target="_blank" exige rel="noopener noreferrer" na mesma tag (RF-08) ---
semrel=0
for f in "${PRESENTES[@]}"; do
  while IFS= read -r tag; do
    [ -z "$tag" ] && continue
    if ! printf '%s' "$tag" | grep -qE 'rel="[^"]*noopener[^"]*"' || ! printf '%s' "$tag" | grep -qE 'rel="[^"]*noreferrer[^"]*"'; then
      falha "$f: target=\"_blank\" sem rel=\"noopener noreferrer\": $tag"; semrel=1
    fi
  done < <(uma_linha "$f" | grep -oP '<[a-zA-Z][^>]*target="_blank"[^>]*>' || true)
done
[ "$semrel" -eq 0 ] && ok "todo target=\"_blank\" tem rel=\"noopener noreferrer\""

# --- 7. Cartão "Páginas" na raiz (RF-03) ---
if [ -f index.html ] && grep -q 'href="paginas/"' index.html; then
  ok "index.html da raiz linka paginas/"
else
  falha "index.html da raiz não contém href=\"paginas/\""
fi

# --- 8. Índice lista os cinco artigos (RF-02) ---
if [ -f "$PASTA/index.html" ]; then
  faltam=0
  for a in "${ARTIGOS[@]}"; do
    grep -q "href=\"$a.html\"" "$PASTA/index.html" || { falha "$PASTA/index.html não linka $a.html"; faltam=1; }
  done
  [ "$faltam" -eq 0 ] && ok "$PASTA/index.html linka os 5 artigos"
fi

# --- 9. README lista paginas/ e o script (RF-10) ---
if grep -q 'paginas/' README.md && grep -q 'scripts/verificar-ajuda.sh' README.md; then
  ok "README.md lista paginas/ e scripts/verificar-ajuda.sh"
else
  falha "README.md não lista paginas/ e scripts/verificar-ajuda.sh"
fi

echo
if [ "$FALHAS" -gt 0 ]; then
  echo "RESULTADO: $FALHAS falha(s)"
  exit 1
fi
echo "RESULTADO: tudo ok"
