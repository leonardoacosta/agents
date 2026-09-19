// packages/inventory/src/types.ts

export interface ActionInventory {
  /** dot-notation tRPC procedure path, e.g. "badges.approve" */
  procedure?: string;
  /** Permissions required to invoke this action */
  requires?: Record<string, string[]>;
  /** CRUD classification: "C"reate, "R"ead, "U"pdate, "D"elete, "Bulk" */
  crud?: string;
  /** Security-critical actions must have E2E coverage */
  security_critical?: boolean;
  /** Escalation actions may skip E2E if Vitest-integration covered */
  escalation?: boolean;
  /** Side-effect tags: stripe_checkout, stripe_refund, resend_email, etc. */
  side_effects?: string[];
}

export interface ViewAccess {
  /** Persona keys that may access this page. "anonymous" = no auth required. */
  allow: string[];
  /** If true, deny access to all personas not in `allow`. Default false. */
  deny_default: boolean;
}

export interface PageInventoryEntry {
  /** Canonical route path, e.g. "/staff/sales/badges" */
  route: string;
  /** Source file relative to repo root */
  file: string;
  /** Actions surfaced on this page */
  actions: ActionInventory[];
  /** Who can see this page */
  view_access: ViewAccess;
}

/** The complete inventory — one entry per Next.js App Router page. */
export type PageInventory = PageInventoryEntry[];