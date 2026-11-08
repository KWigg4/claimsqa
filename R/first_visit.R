#' Earliest visit per patient, with a deterministic tiebreaker
#'
#' When two visits share the same arrival time, `visit_id` breaks the tie.
#' Without that tiebreaker, the chosen visit depends on input row order,
#' which can differ between two extracts of identical data.
#'
#' @param visits A data frame with `pat_id`, `visit_id`, and `arrival`.
#' @return One row per patient.
#' @export
first_visit <- function(visits) {
  out <- visits[order(visits$pat_id, visits$arrival , visits$visit_id
  )
    , ,
                drop = FALSE]
  out <- out[!duplicated(out$pat_id), , drop = FALSE]
  rownames(out) <- NULL
  out
}
