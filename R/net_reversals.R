#' Net reversals and adjustments to one amount per claim line
#'
#' Sums every record for a claim line (original payment, reversals, and
#' adjustments), rounds to cents, and drops lines that net to zero.
#' Run [dedupe_claims()] first: an exact duplicate payment would otherwise
#' be counted twice.
#'
#' @param claims A data frame with `claim_id`, `line_num`, `member_id`,
#'   and `paid_amt`.
#' @return One row per claim line with a nonzero `net_paid`.
#' @export
net_reversals <- function(claims) {
  required <- c("claim_id", "line_num", "member_id", "paid_amt")
  missing_cols <- setdiff(required, names(claims))
  if (length(missing_cols) > 0) {
    stop("Missing columns: ", paste(missing_cols, collapse = ", "),
         call. = FALSE)
  }
  net <- stats::aggregate(paid_amt ~ claim_id + line_num + member_id,
                          data = claims, FUN = sum)
  # Floating point: 0.10 + 0.20 - 0.30 is 5.55e-17, not 0. Round to cents.
  net$paid_amt <- round(net$paid_amt, 2)
  net <- net[net$paid_amt != 0, , drop = FALSE]
  net <- net[order(net$claim_id, net$line_num), , drop = FALSE]
  names(net)[names(net) == "paid_amt"] <- "net_paid"
  rownames(net) <- NULL
  net
}
