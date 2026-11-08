test_that("net_reversals matches the verified expected output", {
  out <- net_reversals(dedupe_claims(read_claims_fixture()))

  expected <- data.frame(
    claim_id  = c("C001", "C003", "C004", "C004"),
    line_num  = c(1L, 1L, 1L, 2L),
    member_id = c("M01", "M03", "M04", "M04"),
    net_paid  = c(100.00, 95.20, 45.00, 30.00)
  )
  expect_equal(out, expected)
})

test_that("fully reversed lines drop out", {
  out <- net_reversals(dedupe_claims(read_claims_fixture()))
  expect_false("C002" %in% out$claim_id)
})

test_that("floating point near-zero nets are treated as zero", {
  # 0.10 + 0.20 - 0.30 is about 5.55e-17 without rounding
  out <- net_reversals(dedupe_claims(read_claims_fixture()))
  expect_false("C005" %in% out$claim_id)
})

test_that("skipping dedupe double counts the duplicate payment", {
  # Documents why the pipeline order matters
  raw <- net_reversals(read_claims_fixture())
  expect_equal(raw$net_paid[raw$claim_id == "C001"], 200)
})

test_that("missing columns give an informative error", {
  claims <- read_claims_fixture()
  claims$paid_amt <- NULL
  expect_error(net_reversals(claims), "Missing columns: paid_amt")
})
