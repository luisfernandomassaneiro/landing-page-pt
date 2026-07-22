# Launch Checklist — 40 itens antes de mandar tráfego

Rode item a item antes de reportar "pronto". Se algum falhar, corrija.

## Conteúdo e copy (8)

- [ ] `BRIEF.md` preenchido e aprovado pelo cliente
- [ ] Headline passa no filtro anti-slop (nenhuma palavra proibida de `copywriting-ptbr.md`)
- [ ] Subhead responde à objeção implícita da headline
- [ ] CTA primário usa verbo forte + benefício (não "Enviar")
- [ ] Mesmo CTA repetido 3-5 vezes ao longo da página
- [ ] Zero placeholders `[PLACEHOLDER]` visíveis
- [ ] Zero Lorem Ipsum
- [ ] Revisão ortográfica em PT-BR (usar Grammarly, LanguageTool ou revisor humano)

## SEO (8)

- [ ] `<title>` entre 30-60 chars, com marca no final
- [ ] Meta description entre 120-155 chars
- [ ] Canonical URL definida
- [ ] `lang="pt-BR"` no `<html>`
- [ ] 1 único `<h1>` (a headline do hero)
- [ ] Hierarquia H1 → H2 → H3 respeitada
- [ ] OG image 1200×630, <200KB, testada em https://www.opengraph.xyz/
- [ ] JSON-LD Organization + WebSite + FAQPage (se tiver FAQ) validados em https://search.google.com/test/rich-results

## Performance (6)

- [ ] Lighthouse Performance ≥ 95 (Mobile Slow 4G)
- [ ] LCP ≤ 2.5s
- [ ] INP ≤ 200ms
- [ ] CLS ≤ 0.1
- [ ] Hero image em WebP/AVIF, ≤100KB, com `fetchpriority="high"`
- [ ] Tailwind compilado e minificado (não CDN em produção)

## Acessibilidade (5)

- [ ] Lighthouse Accessibility ≥ 95
- [ ] Contraste WCAG AA em todo texto (4.5:1 normal, 3:1 grande)
- [ ] Focus visível em todos os elementos interativos
- [ ] Todo `<img>` tem `alt` descritivo (não "imagem 1")
- [ ] Formulário navegável via teclado (Tab funciona, Enter submete)

## Assets (4)

- [ ] Favicon set completo: `favicon.svg`, `favicon-32.png`, `favicon-16.png`, `apple-touch-icon.png`
- [ ] `manifest.json` presente e válido
- [ ] Logo em SVG ou PNG @2x
- [ ] Screenshot/mockup do produto no hero (não stock genérico)

## Formulário / conversão (5)

- [ ] Formulário submete e chega no destino (testado com envio real)
- [ ] Loading state visível no botão durante submit
- [ ] Sucesso mostra mensagem clara ("Recebemos! Retornamos em X horas")
- [ ] Erro mostra mensagem clara (não travar sem feedback)
- [ ] Validação client-side em campos obrigatórios (não só HTML5 `required`)

## Legal / LGPD (5)

- [ ] Banner de consent aparece na primeira visita
- [ ] GA4/Meta Pixel só dispara DEPOIS do aceite
- [ ] Página `/privacidade` acessível com CNPJ + DPO reais
- [ ] Checkbox de consent no formulário (não pré-marcado)
- [ ] Footer com links: Privacidade, Termos (se venda), CNPJ

## Analytics (4)

- [ ] GA4 instalado e recebendo eventos (checar Realtime)
- [ ] Meta Pixel instalado e disparando PageView (checar Events Manager)
- [ ] Evento `cta_click` disparando em cliques nos botões
- [ ] Evento `form_submit` disparando em submits bem-sucedidos

## Deploy (5)

- [ ] HTTPS ativo com certificado válido
- [ ] Redirect `www` ↔ apex configurado (escolher um canônico)
- [ ] 404 customizada (não a padrão do host)
- [ ] `sitemap.xml` + `robots.txt` acessíveis na raiz
- [ ] Testado em Safari iOS **real** (não emulado no Chrome)

## Cross-browser (2)

- [ ] Chrome/Edge desktop OK
- [ ] Safari iOS mobile OK (é o mais problemático — testar antes)

---

## Comando resumo

Rode antes de entregar:

```bash
# 1. Auditoria automática
~/.claude/skills/landing-page-pt/scripts/audit.sh https://SEU-DOMINIO.com

# 2. Validações manuais
open https://pagespeed.web.dev/report?url=https://SEU-DOMINIO.com
open https://www.opengraph.xyz/url/https%3A%2F%2FSEU-DOMINIO.com
open https://search.google.com/test/rich-results?url=https%3A%2F%2FSEU-DOMINIO.com
open https://validator.w3.org/nu/?doc=https%3A%2F%2FSEU-DOMINIO.com
```

## Só declare "pronto" se

Todos os 40 itens passaram OU foram documentados como "não aplicável" no BRIEF.md com justificativa. **Se não conseguiu testar Safari iOS real, avise explicitamente** — não finja.
