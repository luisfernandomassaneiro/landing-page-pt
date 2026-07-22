# Design Tokens — Paletas e Tipografia curadas

5 paletas + 5 pares de fonte. **Escolha uma paleta e um par de fontes por página.** Não misture. Confirme com o usuário mostrando um preview textual antes de aplicar.

---

## Paleta 1: "Sobrio" (SaaS B2B, fintech, jurídico)

Base neutra, azul-escuro como ação. Passa confiança.

```css
--color-bg:        #FFFFFF;
--color-bg-alt:    #F8FAFC;
--color-text:      #0F172A;
--color-text-mute: #475569;
--color-primary:   #1E40AF;  /* azul escuro */
--color-primary-h: #1E3A8A;  /* hover */
--color-accent:    #F59E0B;  /* âmbar — só para destaque pontual */
--color-border:    #E2E8F0;
--color-success:   #059669;
--color-error:     #DC2626;
```

**Dark mode:**
```css
--color-bg:        #0F172A;
--color-bg-alt:    #1E293B;
--color-text:      #F1F5F9;
--color-text-mute: #94A3B8;
--color-primary:   #60A5FA;
--color-border:    #334155;
```

**Quando usar:** SaaS corporativo, banco, seguro, contabilidade, advocacia.
**Evitar em:** infoprodutos, cursos digitais, moda, gastronomia.

---

## Paleta 2: "Vibrante" (Infoproduto, curso, coaching)

Alto contraste, cor primária forte. Passa energia.

```css
--color-bg:        #FFFFFF;
--color-bg-alt:    #FEF3C7;  /* creme */
--color-text:      #18181B;
--color-text-mute: #52525B;
--color-primary:   #DC2626;  /* vermelho */
--color-primary-h: #B91C1C;
--color-accent:    #FACC15;  /* amarelo */
--color-border:    #E4E4E7;
--color-success:   #16A34A;
```

**Quando usar:** venda de curso, mentoria, e-book, lançamento clássico.
**Evitar em:** produto sério/corporativo.

---

## Paleta 3: "Elegante escuro" (Produto premium, agência, portfolio)

Dark-first. Passa sofisticação. Cuidado com contraste WCAG.

```css
--color-bg:        #0A0A0A;
--color-bg-alt:    #171717;
--color-text:      #FAFAFA;
--color-text-mute: #A3A3A3;
--color-primary:   #FAFAFA;  /* botão inverte pra branco */
--color-primary-h: #E5E5E5;
--color-primary-text: #0A0A0A;
--color-accent:    #10B981;  /* verde neon pontual */
--color-border:    #262626;
```

**Quando usar:** agência criativa, produto tech premium, portfolio, marca de luxo.
**Evitar em:** público 50+, produtos de urgência.

---

## Paleta 4: "Natural" (Wellness, sustentabilidade, alimentação)

Tons terrosos, verde oliva. Passa calma.

```css
--color-bg:        #FBFAF7;
--color-bg-alt:    #F1EEE6;
--color-text:      #292524;
--color-text-mute: #78716C;
--color-primary:   #4D7C0F;  /* verde oliva */
--color-primary-h: #3F6212;
--color-accent:    #C2410C;  /* terracota */
--color-border:    #E7E5E4;
```

**Quando usar:** wellness, terapias, produtos orgânicos, meditação, culinária saudável.
**Evitar em:** tech, urgência, ofertas agressivas.

---

## Paleta 5: "Tech moderno" (Dev tool, API, produto para engenharia)

Preto + accent frio. Estética Linear/Vercel.

```css
--color-bg:        #FFFFFF;
--color-bg-alt:    #FAFAFA;
--color-text:      #09090B;
--color-text-mute: #71717A;
--color-primary:   #09090B;  /* preto como primário */
--color-primary-h: #27272A;
--color-primary-text: #FAFAFA;
--color-accent:    #7C3AED;  /* roxo pontual — UM lugar só */
--color-border:    #E4E4E7;
```

⚠️ Cuidado: o roxo é a paleta "AI slop" mais comum. Use SÓ como destaque pontual, nunca como cor de fundo grande.

**Dark mode:** ver Paleta 3.

**Quando usar:** ferramenta técnica, API, CLI, produto para desenvolvedor.

---

## Pares de fontes (Google Fonts, self-host WOFF2 em produção)

### Par A: "Neutro moderno" (default seguro)
- **Display:** Inter (400, 600, 800)
- **Body:** Inter (400, 500)
- Funciona com qualquer paleta. Se estiver em dúvida, use este.

### Par B: "Editorial"
- **Display:** Fraunces (600, 800) — serif com personalidade
- **Body:** Inter (400)
- Combina com paletas 2, 3, 4.

### Par C: "Tech serious"
- **Display:** Geist (500, 700)
- **Body:** Geist (400)
- **Mono:** Geist Mono (para snippets de código)
- Combina com paletas 3, 5.

### Par D: "Amigável"
- **Display:** DM Sans (500, 700)
- **Body:** DM Sans (400)
- Combina com paletas 1, 2, 4.

### Par E: "Clássico com toque moderno"
- **Display:** Playfair Display (600) — serif clássica
- **Body:** Inter (400)
- Combina com paletas 2, 3, 4. Bom para produtos "premium acessível".

### Regras de tipografia
- Máximo 2 famílias por página.
- Máximo 2 pesos por família.
- Body: `line-height: 1.6`, `font-size: 16-18px`.
- Display: `line-height: 1.1-1.2`, escala modular (48/36/24/18/16).
- `font-display: swap` sempre.
- Preload da fonte principal do hero: `<link rel="preload" as="font" ...>`.

---

## Sistema de espaçamento (Tailwind default)

Use múltiplos de 4px. Escala: 4, 8, 12, 16, 24, 32, 48, 64, 96, 128.
- Padding vertical de seção: `py-16 md:py-24` (mobile 64px, desktop 96px).
- Gap entre seções: `space-y-24 md:space-y-32`.
- Container max-width: `max-w-6xl` (1152px). Nunca full-width em texto.
- Padding horizontal: `px-6 md:px-8`.

## Sombras

Landing pages modernas usam sombras muito sutis. Não use `shadow-lg` para tudo.

- Card básico: `shadow-sm`
- Card em destaque (pricing "popular"): `shadow-xl` + `ring-1 ring-primary/20`
- Botão: sem sombra por padrão. `hover:shadow-md` opcional.

## Border radius

- Botões e inputs: `rounded-lg` (8px) — padrão moderno
- Cards: `rounded-xl` (12px) ou `rounded-2xl` (16px)
- Pill/badge: `rounded-full`
- Consistência > variedade. Escolha um raio principal por página.
