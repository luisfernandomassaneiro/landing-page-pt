---
name: landing-page-pt
description: Cria landing pages profissionais em português-BR seguindo fluxo spec-first (Brief → Copy → Compose → Audit). Aplica frameworks de copywriting (PAS/AIDA/BAB/StoryBrand), monta a página combinando blocos HTML curados, integra formulário (Formspree/Resend), analytics (GA4/Meta Pixel), consent LGPD e valida qualidade com Lighthouse ≥95 e Core Web Vitals antes de declarar pronto. Use quando o usuário pedir "criar landing page", "página de vendas", "página de captura", "one-pager", ou variações em PT-BR.
---

# Landing Page PT-BR

Skill opinativa para criar landing pages profissionais em português. **Spec-first, código depois.** Composição de blocos curados, não geração livre. Auditoria bloqueante ao final.

## Quando usar

- "Crie uma landing page para [produto/serviço]"
- "Preciso de uma página de vendas / captura / one-pager"
- "Gera um site de uma página só para lançamento"
- Qualquer pedido de landing page em PT-BR onde o usuário quer resultado profissional (não rascunho descartável)

**Quando NÃO usar:** app web multi-página, dashboard, blog, e-commerce. Nesse caso, use `web-design` ou `Senior Frontend`.

## Fluxo obrigatório de 4 fases

Nunca pule uma fase. Cada uma tem gate de aprovação do usuário.

### FASE 1 — Brief (5 min)

Copie `BRIEF.template.md` para `BRIEF.md` na raiz do projeto. Preencha com o usuário — **faça perguntas, não invente**. Peça aprovação antes de seguir.

**Bloqueadores:** sem público-alvo definido, sem oferta clara, sem CTA principal → pare e pergunte. Não gere página com brief vazio.

### FASE 2 — Copy first (10 min)

Antes de qualquer HTML, escreva a copy no `BRIEF.md`:

1. Escolha framework em `references/copywriting-ptbr.md` (PAS para dor forte, AIDA para funil linear, BAB para transformação, StoryBrand para produtos com narrativa).
2. Gere 3 opções de headline usando `references/headlines.md` (fórmulas testadas).
3. Escreva subhead, 3-6 benefícios, CTAs (primário + secundário), FAQ (5-8), testimonials (placeholders se não tiver reais — marque `[PLACEHOLDER]`).
4. **Aplique o filtro anti-slop**: nenhuma headline pode conter "Revolucione", "Transforme", "Descubra o segredo", "Alavanque". Ver lista completa em `references/copywriting-ptbr.md`.

Peça aprovação da copy antes de codar.

### FASE 3 — Compose (15 min)

1. **Escolha stack:**
   - `templates/html-single/` — HTML único, Tailwind CDN. Para MVP, prototipagem, one-pager simples.
   - `templates/astro/` — projeto Astro completo. Para produção séria, múltiplas páginas futuras, melhor performance.
   - Pergunte ao usuário se não estiver claro no brief.

2. **Escolha tokens** em `references/design-tokens.md` (5 paletas + 5 pares de fonte curados). Confirme com o usuário via preview textual antes de aplicar.

3. **Monte a página** seguindo a ordem canônica de `references/anatomy.md`. Para cada seção, escolha um bloco de `sections/<tipo>/` (leia os HTMLs disponíveis e escolha o que melhor serve o brief). **Não crie seções do zero se existir bloco** — copie e adapte.

4. **Integre**:
   - Formulário: `integrations/formspree.md` (mais simples) ou `integrations/resend.md` (mais controle).
   - Analytics: `integrations/ga4.md` e/ou `integrations/meta-pixel.md`.
   - LGPD: aplique `references/lgpd-consent.md` (banner + política mínima).

5. **SEO técnico**: aplique tudo de `references/seo-checklist.md` (meta tags, OG 1200×630, JSON-LD Organization + FAQPage, sitemap.xml, robots.txt, favicon set).

### FASE 4 — Audit (5 min) — BLOQUEANTE

Não declare "pronto" sem passar. Rode `scripts/audit.sh <url>` e verifique:

- ☐ Lighthouse Performance ≥ 95
- ☐ Lighthouse SEO ≥ 95
- ☐ Lighthouse Accessibility ≥ 95
- ☐ LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1
- ☐ Todos os 40 itens de `references/launch-checklist.md`
- ☐ Formulário testado com submit real
- ☐ OG image renderiza corretamente (validar em https://www.opengraph.xyz/)
- ☐ Banner LGPD funcional
- ☐ Testar em Safari iOS (real, não emulado)

Se algo falhar, corrija antes de reportar concluído. Se o usuário não tiver como testar Safari iOS real, avise explicitamente que essa checagem ficou pendente — nunca finja que testou.

## Anti-padrões (nunca faça)

- Gerar código antes do `BRIEF.md` aprovado.
- Escrever copy em inglês por padrão. É PT-BR sempre — pergunte se for outro idioma.
- Usar gradiente roxo→rosa como default (é a assinatura do "AI slop").
- Colocar autoplay de vídeo com som.
- Carrossel no hero (mata conversão).
- Múltiplos CTAs concorrentes acima da dobra — 1 objetivo por página.
- Menu de navegação completo (só logo + 1 CTA no topo).
- Declarar pronto sem rodar auditoria.
- Inventar depoimentos, logos de clientes ou números. Use `[PLACEHOLDER]` explícito.

## Estrutura da skill

```
landing-page-pt/
├── SKILL.md                     (este arquivo)
├── BRIEF.template.md            (copiar para projeto na Fase 1)
├── references/                  (leia sob demanda)
│   ├── anatomy.md
│   ├── copywriting-ptbr.md
│   ├── headlines.md
│   ├── design-tokens.md
│   ├── seo-checklist.md
│   ├── performance.md
│   ├── lgpd-consent.md
│   └── launch-checklist.md
├── sections/                    (blocos HTML+Tailwind para compor)
├── integrations/                (Formspree, Resend, GA4, Meta Pixel)
├── templates/                   (html-single/, astro/)
└── scripts/audit.sh
```
