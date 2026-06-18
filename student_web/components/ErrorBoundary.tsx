"use client";

import { Component, type ReactNode } from "react";

interface Props { children: ReactNode; fallback?: ReactNode; }
interface State { hasError: boolean; error?: Error; }

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="min-h-screen flex items-center justify-center bg-background p-4">
          <div className="text-center space-y-4 max-w-[400px]">
            <div className="text-4xl">⚠️</div>
            <h2 className="text-xl font-bold text-text-primary">Bir hata oluştu</h2>
            <p className="text-sm text-text-secondary">{this.state.error?.message || "Beklenmeyen bir hata oluştu"}</p>
            <button className="px-6 h-10 bg-primary text-on-primary rounded-xl text-sm font-medium" onClick={() => window.location.reload()}>
              Tekrar Dene
            </button>
          </div>
        </div>
      );
    }
    return this.props.children;
  }
}
