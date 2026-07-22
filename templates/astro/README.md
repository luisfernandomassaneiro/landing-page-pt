# Template Astro — instruções

Astro é a stack recomendada para landing pages em produção. Zero JS por padrão, ótima para Core Web Vitals.

## Setup em 4 passos

```bash
# 1. Scaffold projeto (dentro da pasta do projeto)
npm create astro@latest -- --template minimal --typescript strict --install --git

# 2. Adicione integrações essenciais
npx astro add tailwind
npx astro add sitemap

# 3. Instale utilitários
npm install @astrojs/rss resend
```

## Estrutura sugerida

```
my-landing/
├── astro.config.mjs
├── tailwind.config.mjs
├── src/
│   ├── layouts/
│   │   └── Layout.astro         # <head> completo, LGPD banner
│   ├── components/
│   │   ├── Hero.astro           # copiar de sections/hero/split.html
│   │   ├── Features.astro       # copiar de sections/features/
│   │   ├── Testimonials.astro
│   │   ├── Pricing.astro
│   │   ├── Faq.astro
│   │   ├── CtaFinal.astro
│   │   └── LgpdBanner.astro
│   ├── pages/
│   │   ├── index.astro          # a landing page
│   │   ├── privacidade.astro
│   │   ├── obrigado.astro
│   │   └── api/
│   │       └── lead.ts          # endpoint Resend (ver integrations/resend.md)
│   └── content/
│       └── brief.md             # o BRIEF.md do projeto
├── public/
│   ├── favicon.svg
│   ├── favicon-32.png
│   ├── apple-touch-icon.png
│   ├── manifest.json
│   ├── og.png                   # 1200×630
│   ├── hero.webp                # otimizado
│   └── robots.txt
└── .env
```

## astro.config.mjs

```javascript
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://SEUDOMINIO.com',
  integrations: [
    tailwind({ applyBaseStyles: true }),
    sitemap(),
  ],
  compressHTML: true,
  build: {
    inlineStylesheets: 'auto',
  },
  image: {
    // otimização automática AVIF/WebP
    service: { entrypoint: 'astro/assets/services/sharp' },
  },
});
```

## Layout.astro — head completo

Use como base — inclua meta tags, OG, favicon, JSON-LD e LGPD banner. Copie de `references/seo-checklist.md` e `references/lgpd-consent.md`.

## Otimização de imagem

```astro
---
import { Image } from 'astro:assets';
import heroImage from '../assets/hero.jpg';
---

<Image
  src={heroImage}
  alt="Descrição real do que a imagem mostra"
  width={1200}
  height={800}
  format="webp"
  quality={85}
  loading="eager"
  fetchpriority="high"
/>
```

O `<Image>` do Astro gera automaticamente WebP/AVIF + srcset + width/height.

## Fontes self-hosted

```bash
npm install @fontsource-variable/inter
```

No Layout:

```astro
---
import '@fontsource-variable/inter';
---
```

Preload no head:

```html
<link rel="preload" href="/fonts/inter-variable.woff2" as="font" type="font/woff2" crossorigin>
```

## Deploy

**Vercel:** `vercel --prod` (autodetecta Astro).
**Netlify:** conecte repo, build command `npm run build`, publish dir `dist/`.
**Cloudflare Pages:** similar.

Todos suportam edge functions para `src/pages/api/lead.ts`.

## Comando rápido

Para começar do zero:

```bash
mkdir minha-landing && cd minha-landing
npm create astro@latest -- --template minimal --typescript strict --install --git .
npx astro add tailwind sitemap
cp ~/.claude/skills/landing-page-pt/BRIEF.template.md ./BRIEF.md
# preencha o BRIEF.md, depois peça ao Claude para montar as páginas usando os blocos de sections/
```
