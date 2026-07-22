# Integração: Google Analytics 4

**Setup:**

1. Crie propriedade em https://analytics.google.com → "Admin" → "Criar propriedade".
2. Adicione fluxo de dados "Web" → copie o **Measurement ID** (formato `G-XXXXXXXXXX`).
3. Adicione ao banner LGPD (não fora — GA4 só dispara após consent).

## Instalação (via `references/lgpd-consent.md`)

O snippet do banner LGPD já inclui GA4 dentro de `loadAnalytics()`. Só substitua `G-XXXXXX`.

## Eventos obrigatórios

Além do `page_view` automático, dispare estes:

### `cta_click` — em todo botão CTA

```html
<a
  href="#pricing"
  onclick="if(window.gtag){gtag('event','cta_click',{cta_location:'hero',cta_text:'Começar grátis'})}"
  class="..."
>
  Começar grátis
</a>
```

Ou global (mais limpo):

```html
<script>
document.addEventListener('click', function(e) {
  const link = e.target.closest('[data-cta]');
  if (!link || !window.gtag) return;
  gtag('event', 'cta_click', {
    cta_location: link.dataset.cta,
    cta_text: link.textContent.trim(),
    href: link.href
  });
});
</script>

<a href="#pricing" data-cta="hero" class="...">Começar grátis</a>
<a href="#pricing" data-cta="footer" class="...">Começar grátis</a>
```

### `form_submit` — em cada envio

Já incluído no snippet de `integrations/formspree.md` e `resend.md`.

### `scroll_depth` — profundidade de rolagem

```html
<script>
(function() {
  const marks = [25, 50, 75, 90];
  const fired = new Set();

  function check() {
    const scrolled = (window.scrollY + window.innerHeight) / document.documentElement.scrollHeight * 100;
    marks.forEach(m => {
      if (scrolled >= m && !fired.has(m) && window.gtag) {
        fired.add(m);
        gtag('event', 'scroll_depth', { percent: m });
      }
    });
  }

  let ticking = false;
  window.addEventListener('scroll', () => {
    if (!ticking) {
      requestAnimationFrame(() => { check(); ticking = false; });
      ticking = true;
    }
  }, { passive: true });
})();
</script>
```

### `video_play` / `video_complete` — se tiver vídeo hero

```javascript
document.querySelectorAll('video').forEach(v => {
  v.addEventListener('play', () => window.gtag?.('event', 'video_play', { video_id: v.id }));
  v.addEventListener('ended', () => window.gtag?.('event', 'video_complete', { video_id: v.id }));
});
```

## Configuração recomendada no painel GA4

1. **Admin → Data Settings → Data Retention** → mude para 14 meses (padrão é 2, insuficiente).
2. **Admin → Reporting Identity** → "Blended" (usa signals + device).
3. **Configure > Conversions** → marque `form_submit` e `cta_click` como conversões.
4. **Debug View** — instale extensão "GA Debugger" no Chrome para testar antes de publicar.

## Anonimização de IP (LGPD)

Já incluído no snippet do banner:

```javascript
gtag('config', 'G-XXX', { anonymize_ip: true });
```

## Validação

- **Chrome DevTools** → Network tab → filtre por `collect` → deve aparecer requisição para `google-analytics.com/g/collect` após aceitar cookies.
- **Realtime** no GA4 (Admin → Reports → Realtime) — deve mostrar sua visita em ~30s.
- **GA Debugger Chrome Extension** — mostra todos eventos disparados.

## GTM (Google Tag Manager) — quando usar

Se vai ter 3+ tags de tracking (GA4 + Meta Pixel + LinkedIn Insight + Hotjar…), migre para GTM para não poluir o `<head>`. Setup similar:

1. Crie container em https://tagmanager.google.com.
2. Coloque snippet do GTM no `<head>` + `<body>`.
3. Configure tags **dentro** do GTM, disparadas por trigger "Consent Given" (custom event).
4. No banner LGPD, em vez de carregar GA4 diretamente, dispare: `dataLayer.push({event: 'consent_given'})`.
