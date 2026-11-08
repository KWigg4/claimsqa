#' Collapse overlapping and adjacent enrollment spans
#'
#' Merges spans for each member when they overlap, when one contains
#' another, or when the next span starts within `gap_days` of the previous
#' end.
#'
#' @param enroll A data frame with `member_id`, `start_date`, and `end_date`
#'   (class Date).
#' @param gap_days Largest gap, in days, still treated as continuous.
#'   The default of 1 merges Jan 31 followed by Feb 1.
#' @return One row per continuous span.
#' @export
collapse_enrollment <- function(enroll, gap_days = 1) {
  if (any(enroll$end_date < enroll$start_date)) {
    stop("Some spans have end_date before start_date.", call. = FALSE)
  }
  enroll <- enroll[order(enroll$member_id, enroll$start_date,
                         enroll$end_date), , drop = FALSE]
  pieces <- lapply(split(enroll, enroll$member_id), function(m) {
    starts <- m$start_date[1]
    ends <- m$end_date[1]
    for (i in seq_len(nrow(m))[-1]) {
      k <- length(ends)
      if (as.numeric(m$start_date[i] - ends[k]) <= gap_days) {
        ends[k] <- max(ends[k], m$end_date[i])
      } else {
        starts <- c(starts, m$start_date[i])
        ends <- c(ends, m$end_date[i])
      }
    }
    data.frame(member_id = m$member_id[1], start_date = starts,
               end_date = ends)
  })
  out <- do.call(rbind, pieces)
  rownames(out) <- NULL
  out
}
