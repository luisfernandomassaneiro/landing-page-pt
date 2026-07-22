# Integração: Meta Pixel (Facebook / Instagram Ads)

**Quando usar:** obrigatório se vai rodar tráfego no Meta Ads. Sem pixel, não tem retargeting nem otimização.

## Setup

1. Acesse https://business.facebook.com → **Gerenciador de eventos** → **Conectar fontes de dados** → **Web** → **Meta Pixel**.
2. Nomeie e copie o **Pixel ID** (número de 15-16 dígitos).
3. Instale via banner LGPD (nunca fora — dispara antes do consent viola LGPD).

## Instalação (via banner LGPD)

Já incluído em `references/lgpd-consent.md` dentro de `loadAnalytics()`. Só substitua `PIXEL_ID_AQUI`.

## Eventos padrão

O Meta reconhece eventos com nomes específicos. Use os oficiais:

| Evento | Quando disparar |
|--------|-----------------|
| `PageView` | Automático (já no snippet) |
| `ViewContent` | Ver página de produto/detalhe |
| `Lead` | Formulário de captura enviado |
| `CompleteRegistration` | Cadastro finalizado |
| `InitiateCheckout` | Início de checkout |
| `Purchase` | Compra concluída |
| `Contact` | Clique em WhatsApp/telefone |
| `Schedule` | Agendamento (Calendly, etc.) |
| `SubmitApplication` | Aplicação/inscrição enviada |

## Exemplos práticos

### Lead (form de captura)

Já incluído em `integrations/formspree.md`:

```javascript
if (window.fbq) {
  fbq('track', 'Lead', {
    content_name: 'lead_capture',
    value: 0.00,
    currency: 'BRL'
  });
}
```

### Contact (clique em WhatsApp)

```html
<a
  href="https://wa.me/5511999999999?text=Ol%C3%A1"
  onclick="if(window.fbq){fbq('track','Contact',{content_name:'whatsapp_hero'})}"
  target="_blank"
  rel="noopener"
  class="..."
>
  Falar no WhatsApp
</a>
```

### Purchase (para pixel de e-commerce)

Coloque na página de "obrigado" após compra:

```javascript
if (window.fbq) {
  fbq('track', 'Purchase', {
    value: 297.00,
    currency: 'BRL',
    content_ids: ['produto-123'],
    content_type: 'product'
  });
}
```

## Conversions API (server-side, recomendado 2025+)

iOS 14+ e navegadores privacy-first bloqueiam pixel client-side. Complementar com **Conversions API** melhora atribuição em ~20%.

**Setup rápido via Zapier** (sem código):
1. Trigger: novo lead no Formspree/Resend/webhook.
2. Action: Meta Conversions API → evento `Lead`.
3. Deduplicação por `event_id` (mesmo ID no pixel + CAPI).

**Setup direto (Astro/Next.js) — no endpoint que já grava lead:**

```ts
// depois de gravar o lead no seu banco:
await fetch(`https://graph.facebook.com/v19.0/${PIXEL_ID}/events?access_token=${CAPI_TOKEN}`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    data: [{
      event_name: 'Lead',
      event_time: Math.floor(Date.now() / 1000),
      action_source: 'website',
      event_source_url: 'https://seudominio.com/',
      user_data: {
        em: [await sha256(email.toLowerCase().trim())],
        ph: [await sha256(phone.replace(/\D/g,''))],
      },
      custom_data: {
        value: 0.00,
        currency: 'BRL',
      }
    }]
  })
});
```

⚠️ **PII precisa ser SHA-256** antes de enviar.

## Validação

- **Meta Pixel Helper** (extensão Chrome) — mostra pixel encontrado + eventos disparados.
- **Events Manager → Test Events** — vê eventos em tempo real com URL de teste.
- **Events Manager → Diagnostics** — pega problemas de match/qualidade.

## Match Quality Score

O Meta pontua a qualidade dos dados enviados. Mais alto = melhor otimização de anúncios.

Para melhorar: envie mais parâmetros hasheados no `Lead` — nome (`fn`), sobrenome (`ln`), telefone (`ph`), e-mail (`em`), cidade (`ct`), estado (`st`).

## LGPD

- Sempre atrás do consent (nunca dispare antes do banner ser aceito).
- Menção explícita à Meta na Política de Privacidade.
- Direito de opt-out — link no footer para revogar consent.
