# Biblioteca de Sections

Blocos HTML+Tailwind prontos. **Copie e adapte** — nunca crie do zero se já existe bloco.

## Como usar

1. Leia o(s) HTML(s) do tipo de seção que precisa.
2. Copie o bloco que melhor serve o brief (ou combine partes).
3. Substitua tudo entre `{{ }}` pelos valores do BRIEF.md.
4. Aplique os tokens de cor/fonte de `references/design-tokens.md`.
5. Mantenha classes Tailwind — não converta para CSS custom sem motivo.

## Convenções

- Todos os blocos assumem **Tailwind 3+** já configurado.
- Cores usam variáveis CSS de `design-tokens.md` (`bg-[color:var(--color-primary)]`).
- Placeholders sempre entre `{{ }}` (fácil de fazer find/replace).
- `<section>` semântico com `aria-labelledby`.
- Mobile-first: classes base são mobile, `md:` e `lg:` são desktop.

## Estrutura

- **hero/** — split (imagem + texto), centered (texto centro + CTA), video (vídeo bg)
- **social-proof/** — logos (faixa), stats (números)
- **features/** — grid (3x2), alternating (zigzag)
- **pricing/** — 3-tier (com destaque), single (produto único)
- **testimonials/** — cards (grid 3), quote (destaque grande)
- **faq/** — accordion
- **cta/** — simple (título + botão), with-form (título + email)
