# Synthetic fixtures

Fake data only. Each row exists to plant a known issue.

## claims.csv
- C001: exact duplicate line (same claim in two extract files)
- C002: paid, then fully reversed (should net to zero and drop)
- C003: paid, reversed, then re-paid by adjustment (net = 95.20)
- C004: ordinary two-line claim (control case)
- C005: 0.10 + 0.20 - 0.30, which is not exactly 0 in floating point

## enrollment.csv
- M01: one span fully contains another
- M02: adjacent spans (Jan 31, then Feb 1) that should merge
- M03: a real gap that should stay as two spans
- M04: overlapping spans listed out of order

## visits.csv
- P1: two visits with identical arrival times (tie)
- P2: rows out of chronological order
