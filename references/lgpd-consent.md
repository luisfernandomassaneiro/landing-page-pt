# LGPD — Consent banner + Política mínima

Landing pages brasileiras que coletam qualquer dado (formulário, cookies de analytics, pixel) precisam cumprir a **LGPD (Lei 13.709/2018)**. Este arquivo cobre o mínimo para não tomar multa e não perder o cliente na primeira dúvida jurídica.

## Regra prática

- Se a página tem **GA4, Meta Pixel, ou qualquer cookie não-essencial** → precisa de banner de consent.
- Se coleta **qualquer dado pessoal** (nome, e-mail, telefone) → precisa de Política de Privacidade + checkbox de aceite.
- WhatsApp e clique em botão externo não coletam PII do seu lado, mas o link para a política deve estar no footer sempre.

## Banner de consent (opt-in, não opt-out)

**Crítico:** analytics/pixel **não podem** disparar antes do aceite. Coloque os scripts atrás de uma flag.

### HTML (bottom sheet, sem empurrar conteúdo — CLS zero)

```html
<div
  id="lgpd-banner"
  role="dialog"
  aria-live="polite"
  aria-label="Aviso de privacidade"
  class="fixed bottom-0 inset-x-0 z-50 bg-white border-t border-slate-200 shadow-xl p-4 md:p-6 hidden"
>
  <div class="max-w-6xl mx-auto flex flex-col md:flex-row md:items-center gap-4">
    <p class="text-sm text-slate-700 flex-1">
      Usamos cookies para melhorar sua experiência e medir tráfego (Google Analytics, Meta Pixel).
      Você pode aceitar todos, recusar não-essenciais, ou <a href="/privacidade" class="underline">saber mais</a>.
    </p>
    <div class="flex gap-2 shrink-0">
      <button
        type="button"
        id="lgpd-reject"
        class="px-4 py-2 text-sm rounded-lg border border-slate-300 text-slate-700 hover:bg-slate-50"
      >Recusar</button>
      <button
        type="button"
        id="lgpd-accept"
        class="px-4 py-2 text-sm rounded-lg bg-slate-900 text-white hover:bg-slate-800"
      >Aceitar todos</button>
    </div>
  </div>
</div>

<script>
(function() {
  const KEY = 'lgpd-consent';
  const banner = document.getElementById('lgpd-banner');
  const stored = localStorage.getItem(KEY);

  if (!stored) {
    banner.classList.remove('hidden');
  } else if (stored === 'accepted') {
    loadAnalytics();
  }

  document.getElementById('lgpd-accept').addEventListener('click', () => {
    localStorage.setItem(KEY, 'accepted');
    banner.classList.add('hidden');
    loadAnalytics();
  });

  document.getElementById('lgpd-reject').addEventListener('click', () => {
    localStorage.setItem(KEY, 'rejected');
    banner.classList.add('hidden');
  });

  function loadAnalytics() {
    // GA4
    const ga = document.createElement('script');
    ga.async = true;
    ga.src = 'https://www.googletagmanager.com/gtag/js?id=G-XXXXXX';
    document.head.appendChild(ga);
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-XXXXXX', { anonymize_ip: true });
    window.gtag = gtag;

    // Meta Pixel
    !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
      n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
      n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
      t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
      document,'script','https://connect.facebook.net/en_US/fbevents.js');
    window.fbq('init', 'PIXEL_ID_AQUI');
    window.fbq('track', 'PageView');
  }
})();
</script>
```

**Personalize:**
- `G-XXXXXX` → ID do GA4 real.
- `PIXEL_ID_AQUI` → ID do Meta Pixel real.
- Adicione mais scripts dentro de `loadAnalytics()` conforme necessário.

## Checkbox em formulário (opt-in explícito)

Para todo formulário de captura:

```html
<label class="flex items-start gap-2 text-sm text-slate-600">
  <input
    type="checkbox"
    name="lgpd_consent"
    required
    class="mt-1 rounded border-slate-300"
  >
  <span>
    Li e aceito a <a href="/privacidade" class="underline">Política de Privacidade</a>
    e autorizo o uso dos meus dados para receber contato de {{BRAND}}.
  </span>
</label>
```

**Nunca pré-marcado.** A LGPD exige consent ativo.

## Política de Privacidade — template mínimo

Salve como `/privacidade.html` ou `/pages/privacidade`. Substitua tudo entre `{{ }}`.

```markdown
# Política de Privacidade

**Última atualização:** {{DATA_ATUAL}}

Esta Política descreve como {{BRAND_LEGAL}} (CNPJ {{CNPJ}}, "nós")
coleta, usa e protege seus dados pessoais, em conformidade com a
Lei Geral de Proteção de Dados (Lei 13.709/2018).

## 1. Dados que coletamos

- **Fornecidos por você:** nome, e-mail, telefone (via formulário de contato).
- **Coletados automaticamente:** endereço IP, dados de navegação (via cookies de analytics), mediante seu consentimento.

## 2. Como usamos

- Responder sua solicitação.
- Enviar comunicações comerciais (com sua autorização).
- Medir uso do site para melhorá-lo.
- Cumprir obrigações legais.

**Base legal:** consentimento (art. 7º, I da LGPD) e legítimo interesse (art. 7º, IX).

## 3. Com quem compartilhamos

Não vendemos seus dados. Compartilhamos com:
- Provedores de infraestrutura ({{Vercel/Netlify/etc.}}).
- Ferramentas de analytics (Google, Meta) — apenas dados anonimizados após seu consent.
- Ferramenta de e-mail marketing ({{ConvertKit/Resend/etc.}}) — apenas se você optou.

## 4. Seus direitos

Você pode, a qualquer momento, solicitar:
- Confirmação e acesso aos seus dados.
- Correção de dados incompletos ou desatualizados.
- Anonimização, bloqueio ou eliminação.
- Portabilidade.
- Revogação do consentimento.

Envie sua solicitação para: **{{EMAIL_DPO}}**.

## 5. Retenção

Mantemos seus dados enquanto o consentimento estiver ativo ou pelo prazo mínimo legal (geralmente 5 anos após o último contato).

## 6. Segurança

Adotamos medidas técnicas (HTTPS, controle de acesso, backups criptografados) para proteger seus dados. Nenhum sistema é 100% seguro — em caso de incidente, notificaremos você e a ANPD.

## 7. Encarregado (DPO)

**{{NOME_DPO}}** — {{EMAIL_DPO}}

## 8. Cookies

Detalhes em nossa [Política de Cookies](/cookies).

## 9. Alterações

Alterações serão publicadas nesta página com nova data.

## 10. Foro

Comarca de {{CIDADE_UF}}.
```

## Termos de Uso — quando incluir

Se a página faz **venda direta** ou **cadastro em serviço**, inclua também `/termos.html`. Se é só captura de lead, a Política de Privacidade basta.

## Footer — links obrigatórios

```html
<footer class="border-t border-slate-200 py-8 mt-16">
  <div class="max-w-6xl mx-auto px-6 flex flex-col md:flex-row justify-between gap-4 text-sm text-slate-600">
    <div>
      © 2026 {{BRAND_LEGAL}} — CNPJ {{CNPJ}}
    </div>
    <div class="flex gap-4">
      <a href="/privacidade" class="hover:text-slate-900">Privacidade</a>
      <a href="/termos" class="hover:text-slate-900">Termos</a>
      <a href="/cookies" class="hover:text-slate-900">Cookies</a>
    </div>
  </div>
</footer>
```

## O que NÃO fazer

- ❌ Pré-marcar checkbox de consent.
- ❌ Disparar GA4/Pixel antes do aceite.
- ❌ Botão "aceitar" gigante e "recusar" escondido — a ANPD já sinalizou que isso é dark pattern.
- ❌ Copiar Política de Privacidade de outro site sem adaptar CNPJ, DPO, contato.
- ❌ Coletar dado que você não precisa (minimização é princípio da LGPD).
