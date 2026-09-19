export interface ActionInventory {
  procedure?: string;
  requires?: Record<string, string[]>;
  crud?: "C" | "R" | "U" | "D" | "Bulk" | string;
  security_critical?: boolean;
  escalation?: boolean;
  side_effects?: string[];
}
export interface ViewAccess { allow: string[]; deny_default: boolean; }
export interface PageInventoryEntry { route: string; file: string; actions: ActionInventory[]; view_access: ViewAccess; }
export type PageInventory = PageInventoryEntry[];
