import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./e2e",
  retries: 0,
  use: {
    baseURL: "http://localhost:3008",
    headless: true,
  },
  webServer: {
    command: "npx next start -p 3008",
    port: 3008,
    reuseExistingServer: true,
  },
});
