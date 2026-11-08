#' Remove exact duplicate claim lines
#'
#' Duplicate rows are common when the same claim arrives in two extract files.
#' The output is sorted on key columns so its row order never depends on the
#' order of the input.
#'
#' @param claims A data frame of claim lines.
#' @return `claims` with exact duplicate rows removed.
#' @export
dedupe_claims <- function(claims) {
  out <- claims[!duplicated(claims), , drop = FALSE]
  out <- out[order(out$claim_id, out$line_num, out$svc_date, out$paid_amt), ,
             drop = FALSE]
  rownames(out) <- NULL  # row names carry input order; drop them
  out
}
