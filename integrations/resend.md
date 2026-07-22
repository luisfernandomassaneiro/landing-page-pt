# Integração: Resend

**Quando usar:** você quer controle real — guardar lead no seu banco, enviar e-mail transacional customizado, integrar com sequência de nurture. Requer backend (API route no Astro/Next.js).

## Setup

1. Crie conta em https://resend.com
2. Adicione domínio e configure DNS (SPF, DKIM, DMARC).
3. Gere API key em Settings → API Keys.
4. Adicione ao `.env`:

```
RESEND_API_KEY=re_xxxxxxxxxxxx
RESEND_FROM="Marca <ola@seudominio.com>"
LEAD_INBOX=nandomassaneiro@gmail.com
```

## Astro — endpoint API

`src/pages/api/lead.ts`:

```ts
import type { APIRoute } from 'astro';
import { Resend } from 'resend';

const resend = new Resend(import.meta.env.RESEND_API_KEY);

export const POST: APIRoute = async ({ request }) => {
  const data = await request.formData();
  const name = String(data.get('name') ?? '').trim();
  const email = String(data.get('email') ?? '').trim();
  const phone = String(data.get('phone') ?? '').trim();
  const consent = data.get('lgpd_consent');

  // Validação
  if (!name || !email || !consent) {
    return new Response(JSON.stringify({ ok: false, error: 'Campos obrigatórios ausentes' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return new Response(JSON.stringify({ ok: false, error: 'E-mail inválido' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  // Honeypot (bot preencheu campo escondido)
  if (data.get('_gotcha')) {
    return new Response(JSON.stringify({ ok: true }), { status: 200 });
  }

  try {
    // 1. Notifica você
    await resend.emails.send({
      from: import.meta.env.RESEND_FROM,
      to: import.meta.env.LEAD_INBOX,
      subject: `Novo lead: ${name}`,
      html: `
        <h2>Novo lead do site</h2>
        <p><strong>Nome:</strong> ${escape(name)}</p>
        <p><strong>E-mail:</strong> ${escape(email)}</p>
        <p><strong>WhatsApp:</strong> ${escape(phone)}</p>
        <p><strong>IP:</strong> ${request.headers.get('x-forwarded-for') ?? 'desconhecido'}</p>
      `,
      reply_to: email,
    });

    // 2. Confirma para o lead
    await resend.emails.send({
      from: import.meta.env.RESEND_FROM,
      to: email,
      subject: 'Recebemos seu contato!',
      html: `
        <h2>Olá, ${escape(name)}!</h2>
        <p>Recebemos sua mensagem e retornamos em até 24h úteis.</p>
        <p>Enquanto isso, aproveita e me segue no <a href="https://instagram.com/seuhandle">Instagram</a>.</p>
        <p>Abraço,<br>{{SEU_NOME}}</p>
      `,
    });

    // 3. (opcional) grava em Supabase, Airtable, Google Sheets, etc.
    // await supabase.from('leads').insert({ name, email, phone, created_at: new Date() });

    return new Response(JSON.stringify({ ok: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (err) {
    console.error('Resend error', err);
    return new Response(JSON.stringify({ ok: false, error: 'Erro no envio' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};

function escape(s: string) {
  return s.replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]!));
}
```

## Next.js App Router — route handler

`app/api/lead/route.ts`:

```ts
import { NextRequest, NextResponse } from 'next/server';
import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);

export async function POST(request: NextRequest) {
  const data = await request.formData();
  const name = String(data.get('name') ?? '').trim();
  const email = String(data.get('email') ?? '').trim();
  const phone = String(data.get('phone') ?? '').trim();
  const consent = data.get('lgpd_consent');

  if (!name || !email || !consent) {
    return NextResponse.json({ ok: false, error: 'Campos obrigatórios ausentes' }, { status: 400 });
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return NextResponse.json({ ok: false, error: 'E-mail inválido' }, { status: 400 });
  }
  if (data.get('_gotcha')) {
    return NextResponse.json({ ok: true });
  }

  try {
    await resend.emails.send({
      from: process.env.RESEND_FROM!,
      to: process.env.LEAD_INBOX!,
      subject: `Novo lead: ${name}`,
      html: `<h2>Novo lead</h2><p>${name} — ${email} — ${phone}</p>`,
      reply_to: email,
    });

    return NextResponse.json({ ok: true });
  } catch (err) {
    console.error(err);
    return NextResponse.json({ ok: false, error: 'Erro' }, { status: 500 });
  }
}
```

## Frontend (mesmo padrão do Formspree)

Só troca `action="/api/lead"` no `<form>` e o `fetch` no submit handler.

## Rate limiting (recomendado)

Sem rate limit, spam bot pode consumir seu quota de e-mail. Use:

- **Upstash Redis** (free) + middleware por IP.
- **Cloudflare Turnstile** — captcha invisível grátis, melhor que reCAPTCHA.

## Custos

- Free tier Resend: **3.000 e-mails/mês, 100/dia**.
- Overage: US$1 por 1.000 e-mails.
- Precisa de domínio próprio verificado (não roda com Gmail).
