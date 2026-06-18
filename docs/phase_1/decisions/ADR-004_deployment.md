# ADR-004: Next.js Deployment için Cloudflare Pages

**Tarih:** Haziran 2026  
**Durum:** accepted

## Bağlam
Öğrenci web uygulamasının (Next.js 15.5) deploy edilmesi için platform seçimi.

## Karar
**Cloudflare Pages** (ücretsiz plan).

## Gerekçe
- Vercel ücretsiz plan Hobby tier'da açıkça "commercial use prohibited" yazar
- Bu uygulama ticari bir ürün → Vercel ücretsiz plan kullanılamaz
- Cloudflare Pages: ticari kullanım OK, sınırsız bant genişliği, sınırsız build
- GitHub push → otomatik deploy (CI/CD dahil)
- Next.js static export veya edge runtime ile uyumlu

## Sonuçlar
- Deployment maliyeti: $0
- GitHub main branch'e push = otomatik production deploy
- Custom domain desteği (gelecekte)

## Yapılandırma
```
Build command: npm run build
Build output: .next (veya out/ static export için)
Node.js version: 22
```

## Alternatifler
- Vercel — Ücretli plan $20/ay, MVP için fazla
- Firebase Hosting — 10GB/360MB günlük limit, yetersiz
- Netlify — Benzer özellikler, ancak Next.js 15 desteği Cloudflare kadar iyi değil
