test_that("ties on arrival time are broken by visit_id", {
  out <- first_visit(read_visits_fixture())
  expect_equal(out$pat_id, c("P1", "P2"))
  expect_equal(out$visit_id, c("V001", "V004"))
})

test_that("output does not depend on input row order", {
  # Regression test: before the visit_id tiebreaker, P1's first visit
  # depended on which tied row the extract happened to list first.
  visits <- read_visits_fixture()
  for (seed in 1:5) {
    expect_identical(first_visit(visits),
                     first_visit(shuffle_rows(visits, seed)))
  }
})
