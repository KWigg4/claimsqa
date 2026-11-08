# Files named helper-*.R load automatically before the tests run.

read_claims_fixture <- function() {
  read.csv(
    test_path("fixtures", "claims.csv"),
    colClasses = c(claim_id = "character", line_num = "integer",
                   member_id = "character", svc_date = "Date",
                   paid_amt = "numeric", claim_status = "character")
  )
}

read_enrollment_fixture <- function() {
  read.csv(
    test_path("fixtures", "enrollment.csv"),
    colClasses = c(member_id = "character", start_date = "Date",
                   end_date = "Date")
  )
}

read_visits_fixture <- function() {
  v <- read.csv(test_path("fixtures", "visits.csv"),
                colClasses = "character")
  # Fix the time zone explicitly so results never depend on the machine.
  v$arrival <- as.POSIXct(v$arrival, tz = "UTC")
  v
}

# Reorder rows with a fixed seed, to test that output ignores input order.
shuffle_rows <- function(df, seed) {
  set.seed(seed)
  df[sample(nrow(df)), , drop = FALSE]
}
