test_that("exact duplicate lines are removed", {
  claims <- read_claims_fixture()
  out <- dedupe_claims(claims)

  expect_equal(nrow(out), nrow(claims) - 1)
  expect_equal(sum(out$claim_id == "C001"), 1)
})

test_that("output does not depend on input row order", {
  claims <- read_claims_fixture()
  for (seed in 1:5) {
    expect_identical(dedupe_claims(claims),
                     dedupe_claims(shuffle_rows(claims, seed)))
  }
})
