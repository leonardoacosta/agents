/** Page inventory contract for Next.js App Router test planning. */
export interface ActionInventory {
  /** Dot-notation tRPC procedure path, for example "badges.approve". */
  procedure?: string;
  /** Permission requirements keyed by permission domain. */
  requires?: Record<string, string[]>;
  /** CRUD classification: C, R, U, D, or Bulk. */
  crud?: string;
  /** Destructive, security-sensitive, or payment-sensitive actions need E2E coverage. */
  security_critical?: boolean;
  /** Actions that may be covered by integration tests instead of E2E. */
  escalation?: boolean;
  /** External or durable side effects, for example "stripe_refund". */
  side_effects?: string[];
}

export interface ViewAccess {
  /** Persona keys allowed to view this route. Use "anonymous" for public access. */
  allow: string[];
  /** Deny every persona not listed in allow when true. */
  deny_default: boolean;
}

export interface PageInventoryEntry {
  /** Canonical route path, such as "/staff/sales/badges/:id". */
  route: string;
  /** Source path relative to the repository root. */
  file: string;
  actions: ActionInventory[];
  view_access: ViewAccess;
}

/** Complete inventory: one entry for every discovered App Router page file. */
export type PageInventory = PageInventoryEntry[];
