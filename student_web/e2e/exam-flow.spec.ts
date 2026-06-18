import { test, expect } from "@playwright/test";

test.describe("ExamKit Student Flow", () => {
  test("full exam flow: code entry → name → waiting → exam → results", async ({ page }) => {
    // W1: Kod Giriş
    await page.goto("/");
    await expect(page.locator("h1")).toContainText("Sınava Katıl");
    const input = page.locator("input[placeholder='MAT7K2']");
    await input.fill("MAT7K2");
    await page.locator("button[type='submit']").click();
    await page.waitForURL("**/join/MAT7K2");

    // W2: Ad-Soyad
    await expect(page.locator("h1")).toContainText("Adınızı girin");
    await page.locator("input[placeholder='Adınız...']").fill("Test");
    await page.locator("input[placeholder='Soyadınız...']").fill("Öğrenci");
    await page.locator("button[type='submit']").click();
    await page.waitForURL("**/waiting/**");

    // W3: Bekleme
    await expect(page.locator("h1")).toContainText("Öğretmeni bekleyin");

    // W4: Scroll Sınav
    await page.goto("/exam/mock123?mode=scroll");
    await expect(page.locator("text=Soru 1 / 5")).toBeVisible();
    await page.locator("text=Büyüme ve onarım").first().click();
    await page.locator("text=Sınavı Gönder").click();
    await page.waitForURL("**/results/**");

    // W7: Sonuçlar
    await expect(page.locator("h1")).toContainText("Sonuçlar");
    await expect(page.locator("text=96%")).toBeVisible();

    // W5: Sequential Sınav
    await page.goto("/exam/mock123?mode=sequential");
    await expect(page.locator("text=Soru 1 / 5")).toBeVisible();
    await page.locator("text=Büyüme ve onarım").first().click();
    await page.locator("text=İlerle →").click();
    await expect(page.locator("text=Soru 2 / 5")).toBeVisible();
  });

  test("code entry shows error for invalid code", async ({ page }) => {
    await page.goto("/");
    await page.locator("input[placeholder='MAT7K2']").fill("AB");
    await page.locator("button[type='submit']").click();
    await expect(page.locator("text=Geçersiz kod")).toBeVisible();
  });

  test("join page requires name", async ({ page }) => {
    await page.goto("/join/MAT7K2");
    const btn = page.locator("button[type='submit']");
    await expect(btn).toBeDisabled();
    await page.locator("input[placeholder='Adınız...']").fill("Test");
    await page.locator("input[placeholder='Soyadınız...']").fill("User");
    await expect(btn).toBeEnabled();
  });
});
