test_that("spans collapse as expected", {
  out <- collapse_enrollment(read_enrollment_fixture())

  expected <- data.frame(
    member_id  = c("M01", "M02", "M03", "M03", "M04"),
    start_date = as.Date(c("2026-01-01", "2026-01-01", "2026-01-01",
                           "2026-03-01", "2026-01-01")),
    end_date   = as.Date(c("2026-03-31", "2026-04-30", "2026-01-31",
                           "2026-03-31", "2026-06-30"))
  )
  expect_equal(out, expected)
})

test_that("output does not depend on input row order", {
  enroll <- read_enrollment_fixture()
  for (seed in 1:5) {
    expect_identical(collapse_enrollment(enroll),
                     collapse_enrollment(shuffle_rows(enroll, seed)))
  }
})

test_that("a span ending before it starts is an error", {
  bad <- data.frame(member_id = "M99",
                    start_date = as.Date("2026-02-01"),
                    end_date = as.Date("2026-01-01"))
  expect_error(collapse_enrollment(bad), "end_date before start_date")
})
