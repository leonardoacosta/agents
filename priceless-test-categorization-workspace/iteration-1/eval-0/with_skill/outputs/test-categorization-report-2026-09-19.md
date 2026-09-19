# Test Categorization Report

Generated 2026-09-19T07:14:13.704249+00:00. Static audit against @oo/inventory and Playwright collection.

## Executive Summary
- **31,531 collected tests** across **1,561 files** and 207 inventory routes discovered.
- Collection succeeded with inert `NEXT_PUBLIC_APP_URL=http://localhost:3000`; no tests executed.
- **85 cross-file duplicate titles** and **749 duplicate instances beyond one per title**.
- Largest files: `tests/rbac-inventory/inventory-coverage.spec.ts` (10,350), `tests/web/personas/persona-smoke-journey.spec.ts` (691), `tests/web/admin/admin-rbac-journey.spec.ts` (486), `tests/web/vendor/vendor-invoice-journey.spec.ts` (435), `tests/web/staff/staff-misc-journey.spec.ts` (257), `tests/web/auth/auth-core-journey.spec.ts` (231), `tests/web/schedule/schedule-management-journey.spec.ts` (231), `tests/web/admin/admin-guests-journey.spec.ts` (229), `tests/web/apply/apply-form-journey.spec.ts` (224), `tests/web/auth/auth-advanced-journey.spec.ts` (216)

## Per-Module Analysis
| Module | Collected tests |
|---|---:|
| rbac-inventory | 10,350 |
| web/staff | 3,421 |
| web/admin | 2,835 |
| web/vendor | 1,568 |
| web/personas | 868 |
| apply | 818 |
| web/auth | 760 |
| web/public | 718 |
| web/affiliate | 505 |
| web/apply | 483 |
| web/programming | 444 |
| web/panelist | 392 |
| web/badge | 385 |
| web/attendee | 338 |
| web/cosplay | 337 |
| web/stripe | 330 |
| web/schedule | 275 |
| web/sponsorship | 247 |
| api | 223 |
| web/volunteer | 219 |
| web/finance | 199 |
| web/vendors | 198 |
| web/meetup | 141 |
| web/authenticated | 138 |
| web/registration | 137 |
| wave-4 | 136 |
| wave-5 | 116 |
| auth | 114 |
| audit-wave1b | 100 |
| web/sponsor | 100 |
| web/staff-layout | 98 |
| wave-6 | 96 |
| accessibility | 90 |
| wave-3 | 90 |
| vendor | 85 |
| staff/sidebar-nav-coverage.spec.ts | 84 |
| audit-wave1a | 82 |
| smoke | 80 |
| wave-10 | 80 |
| web/messaging | 79 |

## Per-Page Ceilings
Soft ceilings: LOW=3, MEDIUM=8, HIGH=15. Route matching is filename/route heuristic and requires human confirmation.

| Route | Tier | Ceiling | Matched tests | Ratio |
|---|---|---:|---:|---:|
| / | LOW | 3 | 31,531 | 10510.3x |
| /staff/operations/programming/panelist/badges | LOW | 3 | 6,943 | 2314.3x |
| /staff/operations/programming/panelist | LOW | 3 | 6,876 | 2292.0x |
| /staff/operations/programming/guests | LOW | 3 | 6,738 | 2246.0x |
| /staff/operations/cosplay/runway/schedule | LOW | 3 | 6,492 | 2164.0x |
| /staff/operations/programming/approved | LOW | 3 | 6,464 | 2154.7x |
| /staff/operations/cosplay/schedule | LOW | 3 | 6,452 | 2150.7x |
| /staff/operations/programming/calendar | LOW | 3 | 6,391 | 2130.3x |
| /staff/operations/programming | LOW | 3 | 6,390 | 2130.0x |
| /staff/operations/cosplay/guests | LOW | 3 | 6,366 | 2122.0x |
| /staff/content/guests/badges | LOW | 3 | 6,109 | 2036.3x |
| /staff/operations/volunteers/schedule | LOW | 3 | 6,105 | 2035.0x |
| /staff/operations/booths/dashboard | LOW | 3 | 6,104 | 2034.7x |
| /staff/dev-harness/entity-image/panelist | LOW | 3 | 6,100 | 2033.3x |
| /staff/attendee/merch | LOW | 3 | 6,058 | 2019.3x |
| /staff/attendee/merch/pickup-queue | LOW | 3 | 6,058 | 2019.3x |
| /staff/operations/cosplay/contestants | LOW | 3 | 6,056 | 2018.7x |
| /staff/operations/cosplay/runway | LOW | 3 | 6,056 | 2018.7x |
| /staff/operations/vendors/badges | LOW | 3 | 6,051 | 2017.0x |
| /staff/attendee/badges | LOW | 3 | 6,045 | 2015.0x |
| /staff/attendee/badges/[badgeId] | LOW | 3 | 6,045 | 2015.0x |
| /staff/attendee/orders | LOW | 3 | 6,035 | 2011.7x |
| /staff/attendee/orders/[orderId] | LOW | 3 | 6,035 | 2011.7x |
| /staff/content/guests | LOW | 3 | 6,034 | 2011.3x |
| /staff/attendee/checkin | LOW | 3 | 6,017 | 2005.7x |
| /staff/operations/cosplay | LOW | 3 | 6,016 | 2005.3x |
| /staff/operations/cosplay/scoring | LOW | 3 | 6,016 | 2005.3x |
| /staff/operations/booths/manage | LOW | 3 | 6,008 | 2002.7x |
| /staff/operations/vendors/booths | LOW | 3 | 5,997 | 1999.0x |
| /staff/operations/vendors/invoices | LOW | 3 | 5,988 | 1996.0x |
| /staff/operations/vendors/create | LOW | 3 | 5,986 | 1995.3x |
| /staff/content/pages | LOW | 3 | 5,976 | 1992.0x |
| /staff/operations/vendors | LOW | 3 | 5,976 | 1992.0x |
| /staff/attendee/terminals | LOW | 3 | 5,972 | 1990.7x |
| /staff/operations/guests | LOW | 3 | 5,971 | 1990.3x |
| /staff/operations/registration | LOW | 3 | 5,781 | 1927.0x |
| /staff/operations/volunteers/badges | LOW | 3 | 5,742 | 1914.0x |
| /staff/registration | LOW | 3 | 5,722 | 1907.3x |
| /staff/operations/volunteers/checkin | LOW | 3 | 5,720 | 1906.7x |
| /staff/operations/affiliates/analytics | LOW | 3 | 5,716 | 1905.3x |
| /staff/content/faq | LOW | 3 | 5,696 | 1898.7x |
| /staff/operations/media | LOW | 3 | 5,696 | 1898.7x |
| /staff/operations/meetups | LOW | 3 | 5,693 | 1897.7x |
| /staff/operations/sponsorships/fulfillment | LOW | 3 | 5,690 | 1896.7x |
| /staff/operations/badges | LOW | 3 | 5,688 | 1896.0x |
| /staff/operations/sponsorships/applications | LOW | 3 | 5,684 | 1894.7x |
| /staff/operations/booths/setup | LOW | 3 | 5,683 | 1894.3x |
| /staff/operations/volunteers/reports | LOW | 3 | 5,683 | 1894.3x |
| /staff/content/panels | LOW | 3 | 5,682 | 1894.0x |
| /staff/content | LOW | 3 | 5,676 | 1892.0x |
| /staff/operations/review-queue | LOW | 3 | 5,675 | 1891.7x |
| /staff/operations/booths/assign | LOW | 3 | 5,673 | 1891.0x |
| /staff/operations/affiliates/programs/new | LOW | 3 | 5,672 | 1890.7x |
| /staff/operations/sponsorships/tiers/new | LOW | 3 | 5,671 | 1890.3x |
| /staff/operations/volunteers/swaps | LOW | 3 | 5,669 | 1889.7x |
| /staff/operations/volunteers | LOW | 3 | 5,667 | 1889.0x |
| /staff/operations/volunteers/shifts | LOW | 3 | 5,667 | 1889.0x |
| /staff/operations/affiliates/programs | LOW | 3 | 5,666 | 1888.7x |
| /staff/operations/sponsorships/tiers | LOW | 3 | 5,663 | 1887.7x |
| /staff/operations/affiliates/payouts | LOW | 3 | 5,662 | 1887.3x |
| /staff/operations/sponsorships | LOW | 3 | 5,659 | 1886.3x |
| /staff/operations/affiliates/tiers | LOW | 3 | 5,649 | 1883.0x |
| /staff/communications/messages | LOW | 3 | 5,648 | 1882.7x |
| /staff/operations/affiliates | LOW | 3 | 5,645 | 1881.7x |
| /staff/operations/affiliates/commissions | LOW | 3 | 5,645 | 1881.7x |
| /staff/operations/facilities/hotels | LOW | 3 | 5,637 | 1879.0x |
| /staff/operations/facilities | LOW | 3 | 5,635 | 1878.3x |
| /staff/operations/facilities/floor-plans | LOW | 3 | 5,635 | 1878.3x |
| /staff/operations/facilities/venues | LOW | 3 | 5,635 | 1878.3x |
| /staff/operations/marketing/mailing-list | LOW | 3 | 5,627 | 1875.7x |
| /staff/analytics | LOW | 3 | 5,625 | 1875.0x |
| /staff/analytics/funnels | LOW | 3 | 5,625 | 1875.0x |
| /staff/operations/invoices | LOW | 3 | 5,625 | 1875.0x |
| /staff/settings/events | LOW | 3 | 5,620 | 1873.3x |
| /staff/settings/events/[id] | LOW | 3 | 5,620 | 1873.3x |
| /staff/operations/marketing | LOW | 3 | 5,619 | 1873.0x |
| /staff/operations/panels | LOW | 3 | 5,619 | 1873.0x |
| /staff/operations | LOW | 3 | 5,613 | 1871.0x |
| /staff/operations/panelists | LOW | 3 | 5,613 | 1871.0x |
| /staff/operations/staff | LOW | 3 | 5,613 | 1871.0x |
| /staff/operations/staff/invitations | LOW | 3 | 5,613 | 1871.0x |
| /staff/operations/troupes | LOW | 3 | 5,613 | 1871.0x |
| /staff/settings/spaces/booths | LOW | 3 | 5,605 | 1868.3x |
| /staff/communications | LOW | 3 | 5,604 | 1868.0x |
| /staff/dev-harness/list-detail | LOW | 3 | 5,586 | 1862.0x |
| /staff/dev-harness/entity-image/room | LOW | 3 | 5,577 | 1859.0x |
| /staff/reports | LOW | 3 | 5,574 | 1858.0x |
| /staff/sales | LOW | 3 | 5,569 | 1856.3x |
| /staff/settings/badge-types | LOW | 3 | 5,565 | 1855.0x |
| /staff/settings | LOW | 3 | 5,564 | 1854.7x |
| /staff/settings/products | LOW | 3 | 5,564 | 1854.7x |
| /staff/settings/spaces | LOW | 3 | 5,564 | 1854.7x |
| /staff/settings/spaces/rooms | LOW | 3 | 5,564 | 1854.7x |
| /staff/settings/spaces/rooms/[id] | LOW | 3 | 5,564 | 1854.7x |
| /staff/settings/spaces/venues | LOW | 3 | 5,564 | 1854.7x |
| /staff/settings/spaces/venues/[id] | LOW | 3 | 5,564 | 1854.7x |
| /staff/settings/users | LOW | 3 | 5,564 | 1854.7x |
| /staff/settings/users/[userId]/modules | LOW | 3 | 5,564 | 1854.7x |
| /staff/marketing | LOW | 3 | 5,560 | 1853.3x |
| /staff/profile | LOW | 3 | 5,558 | 1852.7x |
| /staff/event-day | LOW | 3 | 5,557 | 1852.3x |
| /staff | LOW | 3 | 5,554 | 1851.3x |
| /staff/dev-harness/bulk-message | LOW | 3 | 5,554 | 1851.3x |
| /staff/dev-harness/entity-image/avatar-fallback | LOW | 3 | 5,554 | 1851.3x |
| /staff/org | LOW | 3 | 5,554 | 1851.3x |
| /apply/vendor | LOW | 3 | 4,335 | 1445.0x |
| /admin/invoice-explorer/vendors | LOW | 3 | 3,629 | 1209.7x |
| /admin/fees | LOW | 3 | 3,307 | 1102.3x |
| /admin/db-explorer | LOW | 3 | 3,265 | 1088.3x |
| /admin/bulk-resend | LOW | 3 | 3,250 | 1083.3x |
| /admin/webhooks | LOW | 3 | 3,243 | 1081.0x |
| /admin/compose | LOW | 3 | 3,240 | 1080.0x |
| /admin/invoice-explorer/stripe-invoices | LOW | 3 | 3,237 | 1079.0x |
| /admin/invoice-explorer | LOW | 3 | 3,235 | 1078.3x |
| /admin/invoice-explorer/attendees | LOW | 3 | 3,235 | 1078.3x |
| /admin | LOW | 3 | 3,224 | 1074.7x |
| /admin/email-queue | LOW | 3 | 3,224 | 1074.7x |
| /admin/platform-settings | LOW | 3 | 3,224 | 1074.7x |
| /admin/reconcile | LOW | 3 | 3,224 | 1074.7x |
| /get-involved/vendor | LOW | 3 | 2,915 | 971.7x |
| /apply/affiliate | LOW | 3 | 2,404 | 801.3x |
| /staff/finance/reconciliation/orders | MEDIUM | 8 | 6,138 | 767.2x |
| /staff/sales/orders/manage | MEDIUM | 8 | 6,057 | 757.1x |
| /staff/finance | MEDIUM | 8 | 5,972 | 746.5x |
| /staff/sales/orders | MEDIUM | 8 | 5,699 | 712.4x |
| /staff/sales/orders/[orderId] | MEDIUM | 8 | 5,699 | 712.4x |
| /staff/sales/payments/payouts | MEDIUM | 8 | 5,626 | 703.2x |
| /staff/sales/payments | MEDIUM | 8 | 5,609 | 701.1x |
| /staff/sales/payments/platform-fees | MEDIUM | 8 | 5,609 | 701.1x |
| /staff/sales/promo-codes | MEDIUM | 8 | 5,573 | 696.6x |
| /staff/sales/transactions | MEDIUM | 8 | 5,573 | 696.6x |
| /staff/sales/refund-requests | MEDIUM | 8 | 5,569 | 696.1x |
| /apply/sponsor | LOW | 3 | 2,047 | 682.3x |
| /apply/volunteer | LOW | 3 | 2,021 | 673.7x |
| /apply/volunteer/swaps | LOW | 3 | 2,021 | 673.7x |
| /apply/panelist | LOW | 3 | 2,002 | 667.3x |
| /apply/meetup | LOW | 3 | 1,824 | 608.0x |
| /apply/media | LOW | 3 | 1,532 | 510.7x |
| /apply | LOW | 3 | 1,516 | 505.3x |
| /get-involved/cosplay/guest | LOW | 3 | 1,162 | 387.3x |
| /cosplay/guest | LOW | 3 | 1,148 | 382.7x |
| /dashboard/vendors | LOW | 3 | 1,116 | 372.0x |
| /programming/venues/[slug] | LOW | 3 | 1,025 | 341.7x |
| /get-involved/affiliate | LOW | 3 | 1,024 | 341.3x |
| /programming | LOW | 3 | 1,016 | 338.7x |
| /programming/[id] | LOW | 3 | 1,016 | 338.7x |
| /dashboard/orders/transfer/[token] | LOW | 3 | 854 | 284.7x |
| /dashboard/orders | LOW | 3 | 846 | 282.0x |
| /dashboard/orders/badges-transfer/[token] | LOW | 3 | 846 | 282.0x |
| /dashboard/volunteers/leaderboard | LOW | 3 | 831 | 277.0x |
| /vendors/map | LOW | 3 | 804 | 268.0x |
| /dashboard/meetups | LOW | 3 | 761 | 253.7x |
| /get-involved/cosplay/runway | LOW | 3 | 746 | 248.7x |
| /get-involved/cosplay/contestant | LOW | 3 | 744 | 248.0x |
| /cosplay/runway | LOW | 3 | 732 | 244.0x |
| /cosplay/contestant | LOW | 3 | 730 | 243.3x |
| /dashboard/account | LOW | 3 | 703 | 234.3x |
| /get-involved/cosplay | LOW | 3 | 684 | 228.0x |
| /cosplay | LOW | 3 | 670 | 223.3x |
| /get-involved/sponsor | LOW | 3 | 639 | 213.0x |
| /dashboard | LOW | 3 | 637 | 212.3x |
| /my/sponsor/benefits | LOW | 3 | 625 | 208.3x |
| /get-involved/volunteer | LOW | 3 | 609 | 203.0x |
| /get-involved/panelist | LOW | 3 | 586 | 195.3x |
| /schedule | LOW | 3 | 512 | 170.7x |
| /vendors | LOW | 3 | 505 | 168.3x |
| /get-involved/meetup | LOW | 3 | 440 | 146.7x |
| /guests | LOW | 3 | 422 | 140.7x |
| /guests/[id] | LOW | 3 | 422 | 140.7x |
| /sponsors | LOW | 3 | 419 | 139.7x |
| /promo | LOW | 3 | 335 | 111.7x |
| /map | LOW | 3 | 321 | 107.0x |
| /purchase | LOW | 3 | 222 | 74.0x |
| /badges/confirmation | LOW | 3 | 208 | 69.3x |
| /invite/accept | LOW | 3 | 204 | 68.0x |
| /badges | LOW | 3 | 159 | 53.0x |
| /badges/[id] | LOW | 3 | 159 | 53.0x |
| /meetups | LOW | 3 | 124 | 41.3x |
| /meetups/[id] | LOW | 3 | 124 | 41.3x |
| /events | LOW | 3 | 65 | 21.7x |
| /events/[slug] | LOW | 3 | 65 | 21.7x |
| /shop | LOW | 3 | 57 | 19.0x |
| /shop/[slug] | LOW | 3 | 57 | 19.0x |
| /contact | LOW | 3 | 55 | 18.3x |
| /dev/db-explorer | LOW | 3 | 46 | 15.3x |
| /access-denied | LOW | 3 | 40 | 13.3x |
| /success | LOW | 3 | 40 | 13.3x |
| /login | LOW | 3 | 38 | 12.7x |
| /faq | LOW | 3 | 33 | 11.0x |
| /about | LOW | 3 | 28 | 9.3x |
| /my-schedule | LOW | 3 | 22 | 7.3x |
| /announcements | LOW | 3 | 21 | 7.0x |
| /legal/affiliate-terms | LOW | 3 | 18 | 6.0x |
| /get-involved | LOW | 3 | 14 | 4.7x |
| /stay | LOW | 3 | 11 | 3.7x |
| /verify/[badgeId] | LOW | 3 | 10 | 3.3x |
| /work-with-us | LOW | 3 | 10 | 3.3x |
| /signup | LOW | 3 | 8 | 2.7x |

## Duplicate Titles
Top 100 by collected instances. Canonical is the shortest path heuristic.

- **45x** `renders not-open state UI (and not the marketing landing for non-browsing)`
  - canonical candidate: `tests/apply/media-status-states.spec.ts`
  - copies: `tests/apply/contestants-status-states.spec.ts`, `tests/apply/guests-status-states.spec.ts`, `tests/apply/media-status-states.spec.ts`, `tests/apply/meetup-status-states.spec.ts`, `tests/apply/panelist-status-states.spec.ts`, `tests/apply/runway-status-states.spec.ts`, `tests/apply/sponsor-status-states.spec.ts`, `tests/apply/vendor-status-states.spec.ts`, `tests/apply/volunteer-status-states.spec.ts`
- **45x** `renders browsing state UI (and not the marketing landing for non-browsing)`
  - canonical candidate: `tests/apply/media-status-states.spec.ts`
  - copies: `tests/apply/contestants-status-states.spec.ts`, `tests/apply/guests-status-states.spec.ts`, `tests/apply/media-status-states.spec.ts`, `tests/apply/meetup-status-states.spec.ts`, `tests/apply/panelist-status-states.spec.ts`, `tests/apply/runway-status-states.spec.ts`, `tests/apply/sponsor-status-states.spec.ts`, `tests/apply/vendor-status-states.spec.ts`, `tests/apply/volunteer-status-states.spec.ts`
- **45x** `renders closed state UI (and not the marketing landing for non-browsing)`
  - canonical candidate: `tests/apply/media-status-states.spec.ts`
  - copies: `tests/apply/contestants-status-states.spec.ts`, `tests/apply/guests-status-states.spec.ts`, `tests/apply/media-status-states.spec.ts`, `tests/apply/meetup-status-states.spec.ts`, `tests/apply/panelist-status-states.spec.ts`, `tests/apply/runway-status-states.spec.ts`, `tests/apply/sponsor-status-states.spec.ts`, `tests/apply/vendor-status-states.spec.ts`, `tests/apply/volunteer-status-states.spec.ts`
- **45x** `renders pending state UI (and not the marketing landing for non-browsing)`
  - canonical candidate: `tests/apply/media-status-states.spec.ts`
  - copies: `tests/apply/contestants-status-states.spec.ts`, `tests/apply/guests-status-states.spec.ts`, `tests/apply/media-status-states.spec.ts`, `tests/apply/meetup-status-states.spec.ts`, `tests/apply/panelist-status-states.spec.ts`, `tests/apply/runway-status-states.spec.ts`, `tests/apply/sponsor-status-states.spec.ts`, `tests/apply/vendor-status-states.spec.ts`, `tests/apply/volunteer-status-states.spec.ts`
- **45x** `renders approved state UI (and not the marketing landing for non-browsing)`
  - canonical candidate: `tests/apply/media-status-states.spec.ts`
  - copies: `tests/apply/contestants-status-states.spec.ts`, `tests/apply/guests-status-states.spec.ts`, `tests/apply/media-status-states.spec.ts`, `tests/apply/meetup-status-states.spec.ts`, `tests/apply/panelist-status-states.spec.ts`, `tests/apply/runway-status-states.spec.ts`, `tests/apply/sponsor-status-states.spec.ts`, `tests/apply/vendor-status-states.spec.ts`, `tests/apply/volunteer-status-states.spec.ts`
- **45x** `renders waitlisted state UI (and not the marketing landing for non-browsing)`
  - canonical candidate: `tests/apply/media-status-states.spec.ts`
  - copies: `tests/apply/contestants-status-states.spec.ts`, `tests/apply/guests-status-states.spec.ts`, `tests/apply/media-status-states.spec.ts`, `tests/apply/meetup-status-states.spec.ts`, `tests/apply/panelist-status-states.spec.ts`, `tests/apply/runway-status-states.spec.ts`, `tests/apply/sponsor-status-states.spec.ts`, `tests/apply/vendor-status-states.spec.ts`, `tests/apply/volunteer-status-states.spec.ts`
- **45x** `renders rejected state UI (and not the marketing landing for non-browsing)`
  - canonical candidate: `tests/apply/media-status-states.spec.ts`
  - copies: `tests/apply/contestants-status-states.spec.ts`, `tests/apply/guests-status-states.spec.ts`, `tests/apply/media-status-states.spec.ts`, `tests/apply/meetup-status-states.spec.ts`, `tests/apply/panelist-status-states.spec.ts`, `tests/apply/runway-status-states.spec.ts`, `tests/apply/sponsor-status-states.spec.ts`, `tests/apply/vendor-status-states.spec.ts`, `tests/apply/volunteer-status-states.spec.ts`
- **45x** `renders withdrawn state UI (and not the marketing landing for non-browsing)`
  - canonical candidate: `tests/apply/media-status-states.spec.ts`
  - copies: `tests/apply/contestants-status-states.spec.ts`, `tests/apply/guests-status-states.spec.ts`, `tests/apply/media-status-states.spec.ts`, `tests/apply/meetup-status-states.spec.ts`, `tests/apply/panelist-status-states.spec.ts`, `tests/apply/runway-status-states.spec.ts`, `tests/apply/sponsor-status-states.spec.ts`, `tests/apply/vendor-status-states.spec.ts`, `tests/apply/volunteer-status-states.spec.ts`
- **25x** `should validate required fields`
  - canonical candidate: `tests/web/admin/admin-misc-journey.spec.ts`
  - copies: `tests/web/admin/admin-misc-journey.spec.ts`, `tests/web/admin/admin-programming-journey.spec.ts`, `tests/web/affiliate/affiliate-application-journey.spec.ts`, `tests/web/panelist/panelist-troupe-journey.spec.ts`, `tests/web/sponsorship/sponsorship-flow.spec.ts`, `tests/web/vendor/vendor-core-flows-journey.spec.ts`
- **20x** `should validate email format`
  - canonical candidate: `tests/web/admin/admin-guests-journey.spec.ts`
  - copies: `tests/web/admin/admin-guests-journey.spec.ts`, `tests/web/affiliate/affiliate-application-journey.spec.ts`, `tests/web/panelist/panelist-troupe-journey.spec.ts`, `tests/web/sponsorship/sponsorship-flow.spec.ts`
- **15x** `should require authentication for application`
  - canonical candidate: `tests/web/sponsorship/sponsorship-flow.spec.ts`
  - copies: `tests/web/affiliate/affiliate-application-journey.spec.ts`, `tests/web/sponsorship/sponsorship-flow.spec.ts`, `tests/web/vendor/vendor-core-flows-journey.spec.ts`
- **14x** `landing page renders with h1 and CTA`
  - canonical candidate: `tests/web/apply/apply-media-drawer.spec.ts`
  - copies: `tests/web/apply/apply-affiliate-drawer.spec.ts`, `tests/web/apply/apply-media-drawer.spec.ts`, `tests/web/apply/apply-meetup-drawer.spec.ts`, `tests/web/apply/apply-panelist-drawer.spec.ts`, `tests/web/apply/apply-sponsor-drawer.spec.ts`, `tests/web/apply/apply-vendor-drawer.spec.ts`, `tests/web/apply/apply-volunteer-drawer.spec.ts`
- **14x** `[4.1a] filter tab bar renders with ARIA tablist role`
  - canonical candidate: `tests/web/staff/guests-v2.spec.ts`
  - copies: `tests/web/staff/booths-redesign.spec.ts`, `tests/web/staff/guests-v2.spec.ts`, `tests/web/staff/meetups-redesign.spec.ts`, `tests/web/staff/panels-redesign.spec.ts`, `tests/web/staff/vendor-applications-redesign.spec.ts`, `tests/web/staff/volunteers-redesign.spec.ts`, `tests/web/staff/volunteers-v2.spec.ts`
- **12x** `[4.1e] no separate legend row — color dots are integrated into tabs`
  - canonical candidate: `tests/web/staff/booths-redesign.spec.ts`
  - copies: `tests/web/staff/booths-redesign.spec.ts`, `tests/web/staff/cosplay-guests-redesign.spec.ts`, `tests/web/staff/cosplay-runway-redesign.spec.ts`, `tests/web/staff/meetups-redesign.spec.ts`, `tests/web/staff/panels-redesign.spec.ts`, `tests/web/staff/volunteers-redesign.spec.ts`
- **10x** `should validate website URL format`
  - canonical candidate: `tests/web/admin/admin-guests-journey.spec.ts`
  - copies: `tests/web/admin/admin-guests-journey.spec.ts`, `tests/web/vendor/vendor-core-flows-journey.spec.ts`
- **10x** `should display pending applications in admin dashboard`
  - canonical candidate: `tests/web/sponsorship/sponsorship-flow.spec.ts`
  - copies: `tests/web/affiliate/affiliate-application-journey.spec.ts`, `tests/web/sponsorship/sponsorship-flow.spec.ts`
- **10x** `should allow admin to approve application`
  - canonical candidate: `tests/web/sponsorship/sponsorship-flow.spec.ts`
  - copies: `tests/web/affiliate/affiliate-application-journey.spec.ts`, `tests/web/sponsorship/sponsorship-flow.spec.ts`
- **10x** `should allow admin to reject application with reason`
  - canonical candidate: `tests/web/sponsorship/sponsorship-flow.spec.ts`
  - copies: `tests/web/affiliate/affiliate-application-journey.spec.ts`, `tests/web/sponsorship/sponsorship-flow.spec.ts`
- **10x** `should be mobile responsive`
  - canonical candidate: `tests/web/badge/badge-misc-journey.spec.ts`
  - copies: `tests/web/badge/badge-misc-journey.spec.ts`, `tests/web/public/public-pages-journey.spec.ts`, `tests/web/public/public-vendor-map-journey.spec.ts`
- **10x** `[4.1d] clicking a filter tab changes the active selection`
  - canonical candidate: `tests/web/staff/volunteers-v2.spec.ts`
  - copies: `tests/web/staff/booths-redesign.spec.ts`, `tests/web/staff/meetups-redesign.spec.ts`, `tests/web/staff/panels-redesign.spec.ts`, `tests/web/staff/volunteers-redesign.spec.ts`, `tests/web/staff/volunteers-v2.spec.ts`
- **10x** `page does not crash with an error boundary`
  - canonical candidate: `tests/web/staff/event-day-dashboard.spec.ts`
  - copies: `tests/web/staff/event-day-dashboard.spec.ts`, `tests/web/staff/financial-reconciliation.spec.ts`
- **10x** `detail page URL pattern navigates without server error`
  - canonical candidate: `tests/web/staff/staff-cosplay-journey.spec.ts`
  - copies: `tests/web/staff/staff-affiliates-journey.spec.ts`, `tests/web/staff/staff-cosplay-journey.spec.ts`
- **9x** `should copy promo code to clipboard`
  - canonical candidate: `tests/web/admin/admin-promo-journey.spec.ts`
  - copies: `tests/web/admin/admin-promo-journey.spec.ts`, `tests/web/admin/admin-promo-writer-journey.spec.ts`
- **9x** `should reject webhook with invalid signature`
  - canonical candidate: `tests/web/stripe/stripe-vendor-isolated.spec.ts`
  - copies: `tests/web/stripe/stripe-badge-webhook-mutations.spec.ts`, `tests/web/stripe/stripe-vendor-isolated.spec.ts`, `tests/web/stripe/stripe-webhook-errors-mutations.spec.ts`
- **8x** `direct navigation to ?id=<uuid> renders the pane without prior selection`
  - canonical candidate: `tests/staff/sponsorships/tiers-pane-migration.spec.ts`
  - copies: `tests/staff/affiliates/programs-pane-migration.spec.ts`, `tests/staff/programming/panelist-pane-migration.spec.ts`, `tests/staff/programming/troupes-pane-migration.spec.ts`, `tests/staff/sponsorships/tiers-pane-migration.spec.ts`
- **8x** `should filter applications by status`
  - canonical candidate: `tests/web/sponsorship/sponsorship-flow.spec.ts`
  - copies: `tests/web/admin/admin-affiliate-journey.spec.ts`, `tests/web/sponsorship/sponsorship-flow.spec.ts`
- **8x** `refund dialog has reason input field`
  - canonical candidate: `tests/web/admin/admin-order-journey.spec.ts`
  - copies: `tests/web/admin/admin-finance-journey.spec.ts`, `tests/web/admin/admin-order-journey.spec.ts`
- **8x** `refund dialog can be cancelled`
  - canonical candidate: `tests/web/admin/admin-order-journey.spec.ts`
  - copies: `tests/web/admin/admin-finance-journey.spec.ts`, `tests/web/admin/admin-order-journey.spec.ts`
- **8x** `can deny refund request with reason`
  - canonical candidate: `tests/web/admin/admin-refund-journey.spec.ts`
  - copies: `tests/web/admin/admin-refund-journey.spec.ts`, `tests/web/vendor/vendor-invoice-journey.spec.ts`
- **8x** `clicking a thread opens the thread drawer (skip if no threads)`
  - canonical candidate: `tests/web/messaging/staff-replies.spec.ts`
  - copies: `tests/web/messaging/applicant-sends-message.spec.ts`, `tests/web/messaging/staff-replies.spec.ts`
- **8x** `[4.1c] filter tabs show counts in (##) format when data is available`
  - canonical candidate: `tests/web/staff/booths-redesign.spec.ts`
  - copies: `tests/web/staff/booths-redesign.spec.ts`, `tests/web/staff/meetups-redesign.spec.ts`, `tests/web/staff/panels-redesign.spec.ts`, `tests/web/staff/volunteers-redesign.spec.ts`
- **7x** `should prevent duplicate applications`
  - canonical candidate: `tests/web/panelist/panelist-troupe-journey.spec.ts`
  - copies: `tests/web/panelist/panelist-troupe-journey.spec.ts`, `tests/web/vendor/vendor-core-flows-journey.spec.ts`
- **6x** `opens the card, confirms reset, and audits the action`
  - canonical candidate: `tests/staff/vendors/account-support-password-reset.spec.ts`
  - copies: `tests/staff/affiliates/account-support-password-reset.spec.ts`, `tests/staff/sponsorships/account-support-password-reset.spec.ts`, `tests/staff/vendors/account-support-password-reset.spec.ts`
- **6x** `finance hub renders the snapshot without server error`
  - canonical candidate: `tests/web/admin/revenue-feed-alignment-v9.spec.ts`
  - copies: `tests/web/admin/fix-finance-revenue-feed-scope-regression.spec.ts`, `tests/web/admin/revenue-feed-alignment-v9.spec.ts`
- **6x** `/programming?view=calendar loads without error`
  - canonical candidate: `tests/web/programming/fix-programming-ux-regression.spec.ts`
  - copies: `tests/web/programming/consolidate-public-programming-nav-regression.spec.ts`, `tests/web/programming/fix-programming-coming-soon-regression.spec.ts`, `tests/web/programming/fix-programming-ux-regression.spec.ts`
- **6x** `[4.1a] status filter control renders`
  - canonical candidate: `tests/web/staff/cosplay-guests-redesign.spec.ts`
  - copies: `tests/web/staff/cosplay-contestants-redesign.spec.ts`, `tests/web/staff/cosplay-guests-redesign.spec.ts`, `tests/web/staff/cosplay-runway-redesign.spec.ts`
- **6x** `[4.3b] clicking Edit button switches to edit mode`
  - canonical candidate: `tests/web/staff/meetups-redesign.spec.ts`
  - copies: `tests/web/staff/cosplay-contestants-redesign.spec.ts`, `tests/web/staff/cosplay-runway-redesign.spec.ts`, `tests/web/staff/meetups-redesign.spec.ts`
- **6x** `[4.3c] canceling edit mode restores read-only state`
  - canonical candidate: `tests/web/staff/meetups-redesign.spec.ts`
  - copies: `tests/web/staff/cosplay-runway-redesign.spec.ts`, `tests/web/staff/meetups-redesign.spec.ts`, `tests/web/staff/volunteers-redesign.spec.ts`
- **5x** `should show loading state while fetching data`
  - canonical candidate: `tests/web/admin/admin-vendors-journey.spec.ts`
  - copies: `tests/web/admin/admin-programming-journey.spec.ts`, `tests/web/admin/admin-vendors-journey.spec.ts`
- **5x** `should validate panel title is required`
  - canonical candidate: `tests/web/admin/admin-programming-journey.spec.ts`
  - copies: `tests/web/admin/admin-programming-journey.spec.ts`, `tests/web/schedule/schedule-management-journey.spec.ts`
- **4x** `renders approved portal chrome and tabs (not placeholder copy)`
  - canonical candidate: `tests/apply/vendor-approved-portal.spec.ts`
  - copies: `tests/apply/sponsor-approved-portal.spec.ts`, `tests/apply/vendor-approved-portal.spec.ts`
- **4x** `destination /staff/operations/affiliates renders content (not 404)`
  - canonical candidate: `tests/audit-wave1a/affiliates-routing.spec.ts`
  - copies: `tests/audit-wave1a/affiliates-routing.spec.ts`, `tests/wave-3/admin-affiliates-routing.spec.ts`
- **4x** `/contact page renders without error for authenticated user`
  - canonical candidate: `tests/wave-4/contact-form-ux.spec.ts`
  - copies: `tests/audit-wave1b/contact-form-ux.spec.ts`, `tests/wave-4/contact-form-ux.spec.ts`
- **4x** `contact form email input is pre-filled with authenticated user's email`
  - canonical candidate: `tests/wave-4/contact-form-ux.spec.ts`
  - copies: `tests/audit-wave1b/contact-form-ux.spec.ts`, `tests/wave-4/contact-form-ux.spec.ts`
- **4x** `contact form name input is pre-filled with authenticated user's name`
  - canonical candidate: `tests/wave-4/contact-form-ux.spec.ts`
  - copies: `tests/audit-wave1b/contact-form-ux.spec.ts`, `tests/wave-4/contact-form-ux.spec.ts`
- **4x** `promo code list page renders without error`
  - canonical candidate: `tests/wave-3/promo-code-display.spec.ts`
  - copies: `tests/audit-wave1b/promo-code-display.spec.ts`, `tests/wave-3/promo-code-display.spec.ts`
- **4x** `fixed_amount promo code edit form input shows dollar value (e.g. 5), not cents (500)`
  - canonical candidate: `tests/wave-3/promo-code-display.spec.ts`
  - copies: `tests/audit-wave1b/promo-code-display.spec.ts`, `tests/wave-3/promo-code-display.spec.ts`
- **4x** `financial analytics page renders without error`
  - canonical candidate: `tests/wave-7/analytics-accuracy.spec.ts`
  - copies: `tests/audit-wave1b/staff-data-display.spec.ts`, `tests/wave-7/analytics-accuracy.spec.ts`
- **4x** `/events does not render a 404 or error page`
  - canonical candidate: `tests/audit-wave2/events-redirect.spec.ts`
  - copies: `tests/audit-wave2/events-redirect.spec.ts`, `tests/wave-3/events-schedule-unification.spec.ts`
- **4x** `panel detail page contains a back link pointing to /programming`
  - canonical candidate: `tests/audit-wave2/events-redirect.spec.ts`
  - copies: `tests/audit-wave2/events-redirect.spec.ts`, `tests/wave-3/events-schedule-unification.spec.ts`
- **4x** `clicking back link on panel detail navigates to /programming`
  - canonical candidate: `tests/audit-wave2/events-redirect.spec.ts`
  - copies: `tests/audit-wave2/events-redirect.spec.ts`, `tests/wave-3/events-schedule-unification.spec.ts`
- **4x** `attendee dashboard renders without error`
  - canonical candidate: `tests/audit-wave2/events-redirect.spec.ts`
  - copies: `tests/audit-wave2/events-redirect.spec.ts`, `tests/wave-3/events-schedule-unification.spec.ts`
- **4x** `'View Schedule' CTA href points to /programming`
  - canonical candidate: `tests/audit-wave2/events-redirect.spec.ts`
  - copies: `tests/audit-wave2/events-redirect.spec.ts`, `tests/wave-3/events-schedule-unification.spec.ts`
- **4x** `clicking 'View Schedule' CTA navigates to /programming`
  - canonical candidate: `tests/audit-wave2/events-redirect.spec.ts`
  - copies: `tests/audit-wave2/events-redirect.spec.ts`, `tests/wave-3/events-schedule-unification.spec.ts`
- **4x** `review queue page renders without error`
  - canonical candidate: `tests/wave-6/review-queue-features.spec.ts`
  - copies: `tests/audit-wave2/review-queue-features.spec.ts`, `tests/wave-6/review-queue-features.spec.ts`
- **4x** `clicking the Transactions card on /staff/sales/payments navigates to /staff/sales/transactions`
  - canonical candidate: `tests/staff/finance/sales-dashboard.spec.ts`
  - copies: `tests/staff/finance/finance-navigation.spec.ts`, `tests/staff/finance/sales-dashboard.spec.ts`
- **4x** `drawer opens on the LEFT side via Radix Sheet`
  - canonical candidate: `tests/staff/operations/staff-detail-drawer-redesign.spec.ts`
  - copies: `tests/staff/operations/staff-detail-drawer-redesign.spec.ts`, `tests/staff/operations/staff-invite-drawer-redesign.spec.ts`
- **4x** `/programming?filter=panel renders without error`
  - canonical candidate: `tests/wave-4/broken-routes.spec.ts`
  - copies: `tests/wave-4/broken-routes.spec.ts`, `tests/wave-4/programming-staff-routing.spec.ts`
- **4x** `page renders without crash`
  - canonical candidate: `tests/wave-5/affiliate-ledger.spec.ts`
  - copies: `tests/wave-5/affiliate-ledger.spec.ts`, `tests/wave-5/finance-snapshot.spec.ts`
- **4x** `/get-involved/affiliate renders without error`
  - canonical candidate: `tests/wave-6/affiliate-program.spec.ts`
  - copies: `tests/wave-6/affiliate-program.spec.ts`, `tests/wave-7/social-proof-polish.spec.ts`
- **4x** `/vendors page renders without error`
  - canonical candidate: `tests/wave-7/vendor-directory.spec.ts`
  - copies: `tests/wave-6/vendor-hall-status.spec.ts`, `tests/wave-7/vendor-directory.spec.ts`
- **4x** `shows check-in status indicator`
  - canonical candidate: `tests/web/admin/admin-misc-journey.spec.ts`
  - copies: `tests/web/admin/admin-misc-journey.spec.ts`, `tests/web/badge/badge-dashboard-journey.spec.ts`
- **4x** `editing a pre-filled field is not clobbered by the session pre-fill effect`
  - canonical candidate: `tests/web/apply/apply-panelist-drawer.spec.ts`
  - copies: `tests/web/apply/apply-affiliate-drawer.spec.ts`, `tests/web/apply/apply-panelist-drawer.spec.ts`
- **4x** `unauthenticated user is redirected to /login`
  - canonical candidate: `tests/web/staff/staff-auth-context-journey.spec.ts`
  - copies: `tests/web/attendee/attendee-finance-journey.spec.ts`, `tests/web/staff/staff-auth-context-journey.spec.ts`
- **4x** `should be keyboard navigable`
  - canonical candidate: `tests/web/panelist/panelist-troupe-journey.spec.ts`
  - copies: `tests/web/panelist/panelist-troupe-journey.spec.ts`, `tests/web/public/public-vendor-map-journey.spec.ts`
- **4x** `/programming page loads without error`
  - canonical candidate: `tests/web/programming/fix-programming-timezone-regression.spec.ts`
  - copies: `tests/web/programming/consolidate-public-programming-nav-regression.spec.ts`, `tests/web/programming/fix-programming-timezone-regression.spec.ts`
- **4x** `/meetups page loads without error`
  - canonical candidate: `tests/web/programming/fix-programming-ux-regression.spec.ts`
  - copies: `tests/web/programming/fix-programming-thin-landing-pages-regression.spec.ts`, `tests/web/programming/fix-programming-ux-regression.spec.ts`
- **4x** `[4.2b] detail header contains a status select dropdown`
  - canonical candidate: `tests/web/staff/runway-v2.spec.ts`
  - copies: `tests/web/staff/contestants-v2.spec.ts`, `tests/web/staff/runway-v2.spec.ts`
- **4x** `[4.2e] Approve button in detail header triggers a tRPC mutation`
  - canonical candidate: `tests/web/staff/runway-v2.spec.ts`
  - copies: `tests/web/staff/contestants-v2.spec.ts`, `tests/web/staff/runway-v2.spec.ts`
- **4x** `[4.1b] status filter exposes All plus status options`
  - canonical candidate: `tests/web/staff/cosplay-guests-redesign.spec.ts`
  - copies: `tests/web/staff/cosplay-guests-redesign.spec.ts`, `tests/web/staff/cosplay-runway-redesign.spec.ts`
- **4x** `[4.3a] detail panel shows Edit button by default (read-only mode)`
  - canonical candidate: `tests/web/staff/volunteers-redesign.spec.ts`
  - copies: `tests/web/staff/cosplay-runway-redesign.spec.ts`, `tests/web/staff/volunteers-redesign.spec.ts`
- **4x** `/staff/admin/affiliates → /staff/operations/affiliates`
  - canonical candidate: `tests/web/staff/redirects-canonical-paths.spec.ts`
  - copies: `tests/web/staff/fix-dead-route-redirects-regression.spec.ts`, `tests/web/staff/redirects-canonical-paths.spec.ts`
- **4x** `[4.2b] non-submitted rows do NOT show inline Approve/Decline buttons`
  - canonical candidate: `tests/web/staff/guests-v2.spec.ts`
  - copies: `tests/web/staff/guests-v2.spec.ts`, `tests/web/staff/meetups-redesign.spec.ts`
- **4x** `[4.2a] submitted tab shows rows with Approve/Decline buttons`
  - canonical candidate: `tests/web/staff/panels-redesign.spec.ts`
  - copies: `tests/web/staff/meetups-redesign.spec.ts`, `tests/web/staff/panels-redesign.spec.ts`
- **4x** `[4.2c] inline Approve button triggers status change mutation`
  - canonical candidate: `tests/web/staff/panels-redesign.spec.ts`
  - copies: `tests/web/staff/meetups-redesign.spec.ts`, `tests/web/staff/panels-redesign.spec.ts`
- **4x** `should navigate to staff vendors page`
  - canonical candidate: `tests/web/vendor/vendor-staff-view-journey.spec.ts`
  - copies: `tests/web/staff/staff-vendor-management-journey.spec.ts`, `tests/web/vendor/vendor-staff-view-journey.spec.ts`
- **4x** `vendors page loads without error`
  - canonical candidate: `tests/web/vendors/add-vendor-hall-hours-regression.spec.ts`
  - copies: `tests/web/vendors/add-vendor-hall-hours-regression.spec.ts`, `tests/web/vendors/add-vendor-hall-tiered-hours-regression.spec.ts`
- **3x** `adding the same variant add-on twice with different variants creates two separate cart entries`
  - canonical candidate: `tests/wave-4/bundle-addon-ux.spec.ts`
  - copies: `tests/bundle-addon-ux/bundle-addon-ux.spec.ts`, `tests/wave-4/bundle-addon-ux.spec.ts`
- **3x** `migrate-addon-stripe-to-connect.ts --dry-run exits 0 and emits [DRY-RUN] output`
  - canonical candidate: `tests/wave-3/addon-stripe-connect-scoping.spec.ts`
  - copies: `tests/stripe-connect-scoping/addon-stripe-scoping-readers.spec.ts`, `tests/wave-3/addon-stripe-connect-scoping.spec.ts`
- **3x** `[4.1c] clicking a status tab changes the active selection`
  - canonical candidate: `tests/web/staff/guests-v2.spec.ts`
  - copies: `tests/web/guests/refine-programming-guests-v3-regression.spec.ts`, `tests/web/staff/guests-v2.spec.ts`
- **2x** `Next Year tab renders + accept flips status='accepted'`
  - canonical candidate: `tests/volunteer/next-year-tab-accept.spec.ts`
  - copies: `tests/apply/panelist-next-year-tab-accept.spec.ts`, `tests/volunteer/next-year-tab-accept.spec.ts`
- **2x** `badges page renders without error`
  - canonical candidate: `tests/badges-filter.spec.ts`
  - copies: `tests/badges-filter.spec.ts`, `tests/web/badge/badge-filter-sort-regression.spec.ts`
- **2x** `/announcements renders without an error boundary`
  - canonical candidate: `tests/web/public/fix-public-page-access-regression.spec.ts`
  - copies: `tests/web/announcements/fix-announcements-public-access-regression.spec.ts`, `tests/web/public/fix-public-page-access-regression.spec.ts`
- **2x** `shop page loads without error`
  - canonical candidate: `tests/web/shop/redesign-public-shop-regression.spec.ts`
  - copies: `tests/web/merch/fix-shop-addon-link-to-order-regression.spec.ts`, `tests/web/shop/redesign-public-shop-regression.spec.ts`
- **2x** `/shop loads without error`
  - canonical candidate: `tests/web/public/fix-public-page-access-regression.spec.ts`
  - copies: `tests/web/merch/fix-shop-test-data-visibility-regression.spec.ts`, `tests/web/public/fix-public-page-access-regression.spec.ts`

## Vitest Migration Candidates
The candidate JSON flags 39 files whose source appears to contain pure schema, permission, parsing, or calculation logic without browser primitives. Keep E2E for navigation, auth transport, visible gating, accessibility, responsive behavior, and provider-terminal integration.

## Recommendations
1. **P0:** inspect skipped/zero-collected files.
2. **P1:** collapse exact cross-file title duplicates after confirming invariant equivalence.
3. **P2:** move pure logic/schema/permission predicates to Vitest.
4. **P3:** review wave and audit-wave files against canonical web/staff specs.

## Limitations
- Exact collection is **31,531**, materially above the reported 14,000 estimate due to project/data-driven expansion.
- Duplicate titles may be intentional cross-browser or persona coverage.
- No usable flake report was found, so flake penalties were not applied.
- Inventory mapping is conservative heuristic because runtime page records were not serialized.
