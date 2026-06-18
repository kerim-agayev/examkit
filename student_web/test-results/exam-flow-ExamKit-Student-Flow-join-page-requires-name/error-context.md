# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: exam-flow.spec.ts >> ExamKit Student Flow >> join page requires name
- Location: e2e\exam-flow.spec.ts:52:7

# Error details

```
Error: expect(locator).toBeEnabled() failed

Locator:  locator('button[type=\'submit\']')
Expected: enabled
Received: disabled
Timeout:  5000ms

Call log:
  - Expect "toBeEnabled" with timeout 5000ms
  - waiting for locator('button[type=\'submit\']')
    14 × locator resolved to <button disabled type="submit" class="w-full h-[56px] rounded-xl flex items-center justify-center text-lg font-semibold bg-text-disabled text-on-primary cursor-not-allowed">Sınava Katıl</button>
       - unexpected value "disabled"

```

```yaml
- button "Sınava Katıl" [disabled]
```

# Test source

```ts
  1  | import { test, expect } from "@playwright/test";
  2  | 
  3  | test.describe("ExamKit Student Flow", () => {
  4  |   test("full exam flow: code entry → name → waiting → exam → results", async ({ page }) => {
  5  |     // W1: Kod Giriş
  6  |     await page.goto("/");
  7  |     await expect(page.locator("h1")).toContainText("Sınava Katıl");
  8  |     const input = page.locator("input[placeholder='MAT7K2']");
  9  |     await input.fill("MAT7K2");
  10 |     await page.locator("button[type='submit']").click();
  11 |     await page.waitForURL("**/join/MAT7K2");
  12 | 
  13 |     // W2: Ad-Soyad
  14 |     await expect(page.locator("h1")).toContainText("Adınızı girin");
  15 |     await page.locator("input[placeholder='Adınız...']").fill("Test");
  16 |     await page.locator("input[placeholder='Soyadınız...']").fill("Öğrenci");
  17 |     await page.locator("button[type='submit']").click();
  18 |     await page.waitForURL("**/waiting/**");
  19 | 
  20 |     // W3: Bekleme
  21 |     await expect(page.locator("h1")).toContainText("Öğretmeni bekleyin");
  22 | 
  23 |     // W4: Scroll Sınav
  24 |     await page.goto("/exam/mock123?mode=scroll");
  25 |     await expect(page.locator("text=Soru 1 / 5")).toBeVisible();
  26 |     await page.locator("text=Büyüme ve onarım").first().click();
  27 |     await page.locator("text=Sınavı Gönder").click();
  28 |     await page.waitForURL("**/results/**");
  29 | 
  30 |     // W7: Sonuçlar
  31 |     await expect(page.locator("h1")).toContainText("Sonuçlar");
  32 |     await expect(page.locator("text=96%")).toBeVisible();
  33 | 
  34 |     // W5: Sequential Sınav
  35 |     await page.goto("/exam/mock123?mode=sequential");
  36 |     await expect(page.locator("text=Soru 1 / 5")).toBeVisible();
  37 |     await page.locator("text=Büyüme ve onarım").first().click();
  38 |     await page.locator("text=İlerle →").click();
  39 |     await expect(page.locator("text=Soru 2 / 5")).toBeVisible();
  40 |   });
  41 | 
  42 |   test("code entry shows error for invalid code", async ({ page }) => {
  43 |     await page.goto("/");
  44 |     // 2 karakter: buton disabled
  45 |     await page.locator("input[placeholder='MAT7K2']").fill("AB");
  46 |     await expect(page.locator("button[type='submit']")).toBeDisabled();
  47 |     // 4+ karakter: buton enabled
  48 |     await page.locator("input[placeholder='MAT7K2']").fill("MAT7K2");
  49 |     await expect(page.locator("button[type='submit']")).toBeEnabled();
  50 |   });
  51 | 
  52 |   test("join page requires name", async ({ page }) => {
  53 |     await page.goto("/join/MAT7K2");
  54 |     const btn = page.locator("button[type='submit']");
  55 |     await expect(btn).toBeDisabled();
  56 |     await page.locator("input[placeholder='Adınız...']").fill("Test");
  57 |     await page.locator("input[placeholder='Soyadınız...']").fill("User");
> 58 |     await expect(btn).toBeEnabled();
     |                       ^ Error: expect(locator).toBeEnabled() failed
  59 |   });
  60 | });
  61 | 
```