#!/usr/bin/env bash
# audit.sh — roda Lighthouse + validações rápidas antes de declarar landing page pronta.
#
# Uso: ./audit.sh https://sua-landing.com
# Requisitos: node, npx, lighthouse (instala on-demand via npx).

set -euo pipefail

URL="${1:-}"

if [ -z "$URL" ]; then
  echo "Uso: $0 <url>"
  echo "Ex:  $0 https://minha-landing.com"
  exit 1
fi

OUT_DIR="${OUT_DIR:-./audit-report}"
mkdir -p "$OUT_DIR"

echo "═══════════════════════════════════════════════════════════"
echo "  Auditando: $URL"
echo "  Output:    $OUT_DIR"
echo "═══════════════════════════════════════════════════════════"
echo ""

# 1. Lighthouse mobile (perfil que importa para maioria dos usuários no Brasil)
echo "▶ Rodando Lighthouse (Mobile Slow 4G)..."
npx --yes lighthouse "$URL" \
  --preset=perf \
  --form-factor=mobile \
  --throttling-method=simulate \
  --output=html \
  --output=json \
  --output-path="$OUT_DIR/lighthouse-mobile" \
  --chrome-flags="--headless=new --no-sandbox" \
  --quiet 2>&1 | grep -E "^(Performance|Accessibility|Best Practices|SEO)" || true

# 2. Parse dos scores
if [ -f "$OUT_DIR/lighthouse-mobile.report.json" ]; then
  PERF=$(node -e "const r=require('$PWD/$OUT_DIR/lighthouse-mobile.report.json');console.log(Math.round(r.categories.performance.score*100))")
  SEO=$(node -e "const r=require('$PWD/$OUT_DIR/lighthouse-mobile.report.json');console.log(Math.round(r.categories.seo.score*100))")
  A11Y=$(node -e "const r=require('$PWD/$OUT_DIR/lighthouse-mobile.report.json');console.log(Math.round(r.categories.accessibility.score*100))")
  BP=$(node -e "const r=require('$PWD/$OUT_DIR/lighthouse-mobile.report.json');console.log(Math.round(r.categories['best-practices'].score*100))")

  LCP=$(node -e "const r=require('$PWD/$OUT_DIR/lighthouse-mobile.report.json');console.log((r.audits['largest-contentful-paint'].numericValue/1000).toFixed(2))")
  CLS=$(node -e "const r=require('$PWD/$OUT_DIR/lighthouse-mobile.report.json');console.log(r.audits['cumulative-layout-shift'].numericValue.toFixed(3))")
  TBT=$(node -e "const r=require('$PWD/$OUT_DIR/lighthouse-mobile.report.json');console.log(Math.round(r.audits['total-blocking-time'].numericValue))")

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  RESULTADOS"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  printf "  Performance:      %s  (alvo ≥95)\n" "$PERF"
  printf "  SEO:              %s  (alvo ≥95)\n" "$SEO"
  printf "  Accessibility:    %s  (alvo ≥95)\n" "$A11Y"
  printf "  Best Practices:   %s  (alvo ≥95)\n" "$BP"
  echo ""
  printf "  LCP:              %ss  (alvo ≤2.5)\n" "$LCP"
  printf "  CLS:              %s   (alvo ≤0.1)\n" "$CLS"
  printf "  TBT:              %sms (aproximação para INP)\n" "$TBT"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Verifica bloqueadores
  FAILED=0
  [ "$PERF" -lt 95 ] && echo "❌ Performance abaixo de 95" && FAILED=1
  [ "$SEO" -lt 95 ] && echo "❌ SEO abaixo de 95" && FAILED=1
  [ "$A11Y" -lt 95 ] && echo "❌ Accessibility abaixo de 95" && FAILED=1
  awk -v v="$LCP" 'BEGIN{exit !(v > 2.5)}' && echo "❌ LCP > 2.5s" && FAILED=1
  awk -v v="$CLS" 'BEGIN{exit !(v > 0.1)}' && echo "❌ CLS > 0.1" && FAILED=1

  if [ "$FAILED" -eq 0 ]; then
    echo "✅ Auditoria automática PASSOU."
  else
    echo ""
    echo "⛔ Auditoria automática FALHOU. Corrija antes de entregar."
  fi
fi

# 3. Verifica arquivos essenciais
echo ""
echo "▶ Verificando arquivos essenciais..."
for path in "/robots.txt" "/sitemap.xml" "/favicon.svg"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "${URL%/}${path}")
  if [ "$code" = "200" ]; then
    echo "  ✓ $path (200)"
  else
    echo "  ✗ $path ($code) — FALTA"
  fi
done

# 4. Verifica meta tags críticas
echo ""
echo "▶ Verificando meta tags..."
HTML=$(curl -s "$URL")

check_meta() {
  local pattern="$1"
  local label="$2"
  if echo "$HTML" | grep -qi "$pattern"; then
    echo "  ✓ $label"
  else
    echo "  ✗ $label — FALTA"
  fi
}

check_meta 'lang="pt-BR"' 'lang="pt-BR"'
check_meta '<title>' 'title tag'
check_meta 'name="description"' 'meta description'
check_meta 'property="og:image"' 'og:image'
check_meta 'property="og:title"' 'og:title'
check_meta 'link rel="canonical"' 'canonical URL'
check_meta 'application/ld+json' 'JSON-LD structured data'

# 5. Lembrete de validações manuais
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  VALIDAÇÕES MANUAIS PENDENTES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ☐ OG image render:      https://www.opengraph.xyz/url/${URL//\//%2F}"
echo "  ☐ Rich Results:         https://search.google.com/test/rich-results?url=${URL//\//%2F}"
echo "  ☐ HTML válido:          https://validator.w3.org/nu/?doc=${URL//\//%2F}"
echo "  ☐ PageSpeed campo real: https://pagespeed.web.dev/report?url=${URL//\//%2F}"
echo "  ☐ Formulário testado com submit real"
echo "  ☐ Banner LGPD funcional (GA4 só dispara após aceite)"
echo "  ☐ Testado em Safari iOS REAL (não emulado)"
echo ""
echo "  Report Lighthouse HTML: $OUT_DIR/lighthouse-mobile.report.html"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
