/**
 * ExamKit — Next.js i18n (next-intl).
 * Desteklenen diller: az, tr. Varsayılan: tr.
 * Dil öğrencinin tarayıcı tercihine veya sınav bağlantısındaki ?lang= parametresine göre belirlenir.
 */

import { getRequestConfig } from "next-intl/server";
import { headers } from "next/headers";

export const locales = ["az", "tr"] as const;
export type Locale = (typeof locales)[number];
export const defaultLocale: Locale = "tr";

export default getRequestConfig(async () => {
  const headersList = await headers();
  const acceptLanguage = headersList.get("accept-language") || defaultLocale;
  const locale = acceptLanguage.startsWith("az") ? "az" : (defaultLocale as Locale);

  return {
    locale,
    messages: (await import(`../messages/${locale}.json`)).default,
  };
});
