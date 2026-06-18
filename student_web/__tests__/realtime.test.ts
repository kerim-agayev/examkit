/**
 * Unit tests: getRemainingMs (lib/realtime.ts)
 * Global timer utility — kritik, matematiksel olarak test edilebilir.
 */

import { describe, it, expect, vi, afterEach } from "vitest";

// getRemainingMs sadece Date.now() kullanır (pure function)
function getRemainingMs(globalTimerEndsAt: number): number {
  return Math.max(0, globalTimerEndsAt - Date.now());
}

describe("getRemainingMs", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("returns positive ms when end is in the future", () => {
    vi.spyOn(Date, "now").mockReturnValue(100000);
    const end = 200000;
    expect(getRemainingMs(end)).toBe(100000);
  });

  it("returns 0 when end is exactly now", () => {
    vi.spyOn(Date, "now").mockReturnValue(500000);
    expect(getRemainingMs(500000)).toBe(0);
  });

  it("returns 0 when end is in the past", () => {
    vi.spyOn(Date, "now").mockReturnValue(500000);
    expect(getRemainingMs(400000)).toBe(0);
  });

  it("handles late joiner: 20 dk exam, joined after 5 dk", () => {
    const examStart = 0;
    const examEnd = examStart + 20 * 60 * 1000; // 20 dk
    const joinTime = examStart + 5 * 60 * 1000; // 5 dk geç
    vi.spyOn(Date, "now").mockReturnValue(joinTime);
    expect(getRemainingMs(examEnd)).toBe(15 * 60 * 1000);
  });

  it("returns 0 for negative overflow edge case", () => {
    vi.spyOn(Date, "now").mockReturnValue(Number.MAX_SAFE_INTEGER);
    expect(getRemainingMs(0)).toBe(0);
  });
});
