# SEO Checklist — On-page e técnico

Aplicar TUDO abaixo em qualquer landing page. Não é opcional.

## `<head>` obrigatório

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Primary -->
  <title>{{TITLE_30_A_60_CHARS}}</title>
  <meta name="description" content="{{DESCRIPTION_120_A_155_CHARS}}">
  <link rel="canonical" href="https://{{DOMAIN}}/">

  <!-- Open Graph (Facebook, LinkedIn, WhatsApp) -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://{{DOMAIN}}/">
  <meta property="og:title" content="{{OG_TITLE}}">
  <meta property="og:description" content="{{OG_DESCRIPTION}}">
  <meta property="og:image" content="https://{{DOMAIN}}/og.png">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta property="og:locale" content="pt_BR">
  <meta property="og:site_name" content="{{BRAND}}">

  <!-- Twitter -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@{{TWITTER_HANDLE}}">
  <meta name="twitter:title" content="{{TITLE}}">
  <meta name="twitter:description" content="{{DESCRIPTION}}">
  <meta name="twitter:image" content="https://{{DOMAIN}}/og.png">

  <!-- Favicon set completo -->
  <link rel="icon" type="image/svg+xml" href="/favicon.svg">
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16.png">
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
  <link rel="manifest" href="/manifest.json">
  <meta name="theme-color" content="{{PRIMARY_COLOR_HEX}}">

  <!-- Perf: preconnect + preload -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preload" as="image" href="/hero.webp" fetchpriority="high">
</head>
```

## Regras de conteúdo

- **1 `<h1>` por página.** É a headline do hero.
- H2/H3 hierárquico. Não pule níveis (não vá de H1 para H4).
- `alt` em TODA imagem (descritivo, não "imagem 1").
- Links externos: `rel="noopener"` (se `target="_blank"`).
- Texto do link: descritivo. Nunca "clique aqui".
- Contraste WCAG AA mínimo: 4.5:1 (texto normal), 3:1 (texto grande e UI).

## JSON-LD (structured data)

Coloque no `<head>` ou fim do `<body>`.

### Organization (sempre)
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "{{BRAND}}",
  "url": "https://{{DOMAIN}}",
  "logo": "https://{{DOMAIN}}/logo.png",
  "sameAs": [
    "https://www.instagram.com/{{HANDLE}}",
    "https://www.linkedin.com/company/{{HANDLE}}"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+55-11-XXXX-XXXX",
    "contactType": "customer service",
    "areaServed": "BR",
    "availableLanguage": ["pt-BR"]
  }
}
</script>
```

### WebSite (sempre)
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "{{BRAND}}",
  "url": "https://{{DOMAIN}}",
  "inLanguage": "pt-BR"
}
</script>
```

### Product / SoftwareApplication (se aplicável)
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "{{PRODUCT_NAME}}",
  "description": "{{DESCRIPTION}}",
  "brand": {"@type": "Brand", "name": "{{BRAND}}"},
  "offers": {
    "@type": "Offer",
    "price": "49.00",
    "priceCurrency": "BRL",
    "availability": "https://schema.org/InStock"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "342"
  }
}
</script>
```
⚠️ Só inclua `aggregateRating` se os números forem reais.

### FAQPage (obrigatório se tiver seção FAQ)
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "{{PERGUNTA_1}}",
      "acceptedAnswer": {"@type": "Answer", "text": "{{RESPOSTA_1}}"}
    }
    /* ... repetir */
  ]
}
</script>
```

## Arquivos obrigatórios na raiz

### `/robots.txt`
```
User-agent: *
Allow: /

Sitemap: https://{{DOMAIN}}/sitemap.xml
```

### `/sitemap.xml` (mínimo)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://{{DOMAIN}}/</loc>
    <lastmod>2026-01-01</lastmod>
    <priority>1.0</priority>
  </url>
</urlset>
```

### `/manifest.json` (PWA-ready básico)
```json
{
  "name": "{{BRAND}}",
  "short_name": "{{SHORT}}",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "{{PRIMARY_HEX}}",
  "icons": [
    {"src": "/icon-192.png", "sizes": "192x192", "type": "image/png"},
    {"src": "/icon-512.png", "sizes": "512x512", "type": "image/png"}
  ]
}
```

## OG image (1200×630)

**Requisitos:**
- 1200×630 exatos.
- `<200KB` (comprima com [squoosh.app](https://squoosh.app)).
- PNG ou JPG (não WebP — WhatsApp não renderiza).
- Texto grande, legível em preview 300px.
- Contém logo + headline curta + eventual imagem de produto.
- Contraste alto — funciona em thumbnail escuro do Slack e claro do LinkedIn.

**Não usar:**
- Screenshot da própria página (fica ilegível).
- Foto de banco com pessoas em reunião fake.
- Só texto sem contexto visual.

## Validação

Antes de declarar pronto, cheque:

- [ ] https://www.opengraph.xyz/ — renderiza corretamente em FB/LinkedIn/Twitter/WhatsApp
- [ ] https://search.google.com/test/rich-results — JSON-LD válido
- [ ] https://validator.w3.org/ — HTML válido
- [ ] https://wave.webaim.org/ — acessibilidade sem erros críticos
- [ ] https://pagespeed.web.dev/ — Lighthouse ≥95 nas 4 categorias
