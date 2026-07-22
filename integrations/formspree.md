# Integração: Formspree

**Quando usar:** o mais rápido para colocar formulário funcionando. Free tier: 50 submissions/mês. Sem backend, sem código.

## Setup em 3 passos

1. Crie conta em https://formspree.io
2. Crie um novo form → copie o endpoint (formato `https://formspree.io/f/xxxxxxxx`)
3. Cole o endpoint no `action` do `<form>`

## HTML pronto (com validação e feedback)

```html
<form
  id="lead-form"
  action="https://formspree.io/f/{{FORMSPREE_ID}}"
  method="POST"
  class="space-y-4"
  novalidate
>
  <div>
    <label for="name" class="block text-sm font-medium text-slate-700 mb-1">Nome</label>
    <input
      id="name"
      name="name"
      type="text"
      required
      autocomplete="name"
      class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:outline-none focus:ring-2 focus:ring-slate-900"
    >
  </div>

  <div>
    <label for="email" class="block text-sm font-medium text-slate-700 mb-1">E-mail</label>
    <input
      id="email"
      name="email"
      type="email"
      required
      autocomplete="email"
      class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:outline-none focus:ring-2 focus:ring-slate-900"
    >
  </div>

  <div>
    <label for="phone" class="block text-sm font-medium text-slate-700 mb-1">WhatsApp</label>
    <input
      id="phone"
      name="phone"
      type="tel"
      inputmode="tel"
      autocomplete="tel"
      placeholder="(11) 99999-9999"
      class="w-full px-4 py-3 rounded-lg border border-slate-300 focus:outline-none focus:ring-2 focus:ring-slate-900"
    >
  </div>

  <!-- Honeypot anti-spam (Formspree ignora este campo) -->
  <input type="text" name="_gotcha" style="display:none">

  <!-- Subject do email que chega -->
  <input type="hidden" name="_subject" value="Novo lead do site">

  <!-- Redirect após submit (opcional — se remover, mostra JSON) -->
  <input type="hidden" name="_next" value="https://{{DOMAIN}}/obrigado.html">

  <label class="flex items-start gap-2 text-sm text-slate-600">
    <input type="checkbox" name="lgpd_consent" required class="mt-1 rounded border-slate-300">
    <span>
      Aceito a <a href="/privacidade" class="underline">Política de Privacidade</a>
      e autorizo contato.
    </span>
  </label>

  <button
    type="submit"
    id="submit-btn"
    class="w-full px-6 py-3.5 rounded-lg bg-slate-900 text-white font-semibold hover:bg-slate-800 transition disabled:opacity-50 disabled:cursor-not-allowed"
  >
    <span class="btn-text">Enviar</span>
    <span class="btn-loading hidden">Enviando...</span>
  </button>

  <div id="form-message" class="hidden text-sm text-center p-3 rounded-lg"></div>
</form>

<script>
document.getElementById('lead-form').addEventListener('submit', async function(e) {
  e.preventDefault();
  const form = e.target;
  const btn = document.getElementById('submit-btn');
  const msg = document.getElementById('form-message');

  btn.disabled = true;
  btn.querySelector('.btn-text').classList.add('hidden');
  btn.querySelector('.btn-loading').classList.remove('hidden');

  try {
    const response = await fetch(form.action, {
      method: 'POST',
      body: new FormData(form),
      headers: { 'Accept': 'application/json' }
    });

    if (response.ok) {
      msg.textContent = '✓ Recebemos! Retornamos em até 24h.';
      msg.className = 'text-sm text-center p-3 rounded-lg bg-emerald-50 text-emerald-800';
      msg.classList.remove('hidden');
      form.reset();

      // Dispara evento GA4 (se instalado)
      if (window.gtag) {
        gtag('event', 'form_submit', {
          form_id: 'lead-form',
          form_name: 'lead_capture'
        });
      }

      // Dispara evento Meta Pixel (se instalado)
      if (window.fbq) {
        fbq('track', 'Lead');
      }
    } else {
      throw new Error('Erro no envio');
    }
  } catch (err) {
    msg.textContent = '✗ Erro ao enviar. Tente novamente ou fale conosco no WhatsApp.';
    msg.className = 'text-sm text-center p-3 rounded-lg bg-red-50 text-red-800';
    msg.classList.remove('hidden');
  } finally {
    btn.disabled = false;
    btn.querySelector('.btn-text').classList.remove('hidden');
    btn.querySelector('.btn-loading').classList.add('hidden');
  }
});
</script>
```

## Limitações

- **50 submissions/mês grátis.** Se lançar campanha paga, considere upgrade ou Resend.
- **Não guarda leads no seu banco** — só envia por e-mail.
- **Sem workflow de nurture.** Para sequência de e-mail, integre com ConvertKit/Beehiiv via Zapier (ou use Resend + banco próprio).

## Alternativas gratuitas

- **Netlify Forms** — se deploy é Netlify, mais nativo (`netlify` attribute no form).
- **Web3Forms** — free tier maior, sem cadastro.
- **Getform** — similar ao Formspree.
- **Google Forms** embedded — feio mas funciona.
