# Performance — Core Web Vitals

**Alvos obrigatórios (2025-2026):**

| Métrica | Bom | Aceitável | Ruim |
|---------|-----|-----------|------|
| **LCP** (Largest Contentful Paint) | ≤ 2.5s | ≤ 4.0s | > 4.0s |
| **INP** (Interaction to Next Paint) | ≤ 200ms | ≤ 500ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | ≤ 0.25 | > 0.25 |
| **FCP** (First Contentful Paint) | ≤ 1.8s | ≤ 3.0s | > 3.0s |
| **TTFB** (Time to First Byte) | ≤ 800ms | ≤ 1.8s | > 1.8s |

Sempre almeje **"Bom"**. Se não bater, refatore antes de entregar.

---

## LCP — como bater ≤ 2.5s

O LCP quase sempre é a imagem do hero. Otimize:

### 1. Formato e compressão
- **AVIF** (melhor) ou **WebP** (fallback). Nunca PNG/JPG grandes.
- Ferramenta: [squoosh.app](https://squoosh.app) — comprima antes de subir.
- Alvo de peso do hero: **≤ 100KB**.

### 2. Dimensões corretas
- Não sirva imagem 4000px se vai renderizar 800px.
- Use `srcset` + `sizes`:
```html
<img
  src="/hero-800.webp"
  srcset="/hero-400.webp 400w, /hero-800.webp 800w, /hero-1600.webp 1600w"
  sizes="(max-width: 768px) 100vw, 800px"
  width="800"
  height="600"
  alt="Descrição real"
  fetchpriority="high"
>
```
- **Sempre** `width` + `height` (evita CLS).
- `fetchpriority="high"` só no hero — nada mais.

### 3. Preload
No `<head>`, antes de qualquer CSS:
```html
<link rel="preload" as="image" href="/hero.webp" fetchpriority="high">
```

### 4. Fontes
- Self-host WOFF2 (não Google Fonts CDN em produção).
- `font-display: swap` — texto aparece com fallback enquanto fonte carrega.
- Preload da fonte principal:
```html
<link rel="preload" href="/fonts/inter-var.woff2" as="font" type="font/woff2" crossorigin>
```
- Subset: só glyphs pt-BR (economiza ~60% do tamanho).

### 5. Servidor
- CDN sempre (Vercel/Netlify/Cloudflare fazem isso automático).
- HTTP/2 ou HTTP/3.
- Cache headers: `Cache-Control: public, max-age=31536000, immutable` para assets versionados.

---

## INP — como bater ≤ 200ms

INP mede latência de interação (click, tap, keystroke). Problema: JS que trava a main thread.

### Regras
1. **Menos JS.** Landing page raramente precisa de React inteiro. Se der, prefira HTML+Tailwind puro ou Astro (envia zero JS por padrão).
2. **Defer scripts terceiros.** Analytics, chat, pixel: sempre `defer` ou carregue via GTM async.
3. **Zero listeners globais pesados.** Nada de `scroll` sem throttle.
4. **Chat widgets são o pior offensor.** Intercom/Drift adicionam 100-300KB de JS. Carregue on-demand (só quando usuário clica no botão).
5. **Evite frameworks pesados** para landing simples. Se estiver em Next.js e a página não precisa de interatividade React, use `export const dynamic = 'force-static'` e minimize componentes client.

### Padrão de carregamento de terceiros
```html
<!-- GA4 defer -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXX');
</script>
```

---

## CLS — como bater ≤ 0.1

Layout Shift acontece quando algo carrega e empurra conteúdo. Regras:

1. **Imagens sempre com `width` e `height`** (ou `aspect-ratio` CSS).
2. **Fontes com `font-display: swap` + preload** para minimizar swap visível.
3. **Reserve espaço para embeds** (vídeo, iframe):
```html
<div style="aspect-ratio: 16/9;">
  <iframe src="..." style="width:100%; height:100%;"></iframe>
</div>
```
4. **Banners de cookie/LGPD** — nunca empurrar conteúdo do topo. Usar overlay ou bottom-sheet.
5. **Sem `@import` em CSS** — bloqueia renderização.

---

## Estratégia por stack

### HTML+Tailwind CDN (quick)
- CDN é OK para prototipar mas ruim para produção (Tailwind CDN = ~3MB de CSS).
- Antes de subir para produção: rodar `tailwindcss -i input.css -o output.css --minify` e servir só as classes usadas (10-20KB).

### Astro
- Já é ótimo por padrão (zero JS enviado se você não usar `client:*`).
- Use `<Image>` do `astro:assets` — otimiza AVIF/WebP + srcset automaticamente.
- Ilhas interativas só onde precisa: `<Contador client:visible />`.

### Next.js
- `next/image` com `priority` no hero.
- `next/font` para fontes self-hosted automáticas.
- Página como Server Component (padrão App Router). Só marque `'use client'` no que precisa de estado.
- Analisar bundle: `npm run build` → checar output. Cada rota deve ter <100KB First Load JS.

---

## Ferramentas de auditoria

- **Lighthouse** (Chrome DevTools) — auditoria completa.
- **PageSpeed Insights** — https://pagespeed.web.dev — dados de lab + de campo (CrUX).
- **WebPageTest** — https://webpagetest.org — waterfall detalhado.
- **Bundle Analyzer** — para Next: `@next/bundle-analyzer`.

Rode em **rede simulada Mobile 4G Slow** — é o cenário real da maioria dos usuários no Brasil.

---

## Checklist rápido antes de entregar

- [ ] Hero image em WebP/AVIF, ≤100KB, com `width`+`height` e `fetchpriority="high"`
- [ ] Fonte principal preloaded
- [ ] Tailwind CSS compilado e minificado (não CDN em produção)
- [ ] Analytics scripts com `defer`
- [ ] Sem chat widget carregado por padrão
- [ ] Todas as imagens têm dimensões declaradas
- [ ] Iframes/vídeos com `aspect-ratio` reservado
- [ ] Testado em rede Slow 4G Mobile no Lighthouse
- [ ] LCP < 2.5s, INP < 200ms, CLS < 0.1 na aba Performance do PageSpeed Insights
