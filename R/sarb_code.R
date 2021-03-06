#' SARB code
#'
#' @description Request SARB data using the designated code with format KBPXXXX. This function is the worker function of the `sarbR` package and is used to interact with an API linked to the main dataabse
#' @param code SARB quaterly bulletin code
#' @param token an API token generated by \code{sarbR::\link[sarbR]{token_request}}
#' @examples
#' \dontrun{
#' sarb_code(code = "KBP6045J", token = "9eadf0a7a345a0cd286d81e74c555715")
#'
#' Sys.setenv("sarb.token" = "9eadf0a7a345a0cd286d81e74c555715")
#' options(sarb.token = "9eadf0a7a345a0cd286d81e74c555715")
#'
#' sarb_code(code = "KBP6045J")
#'}
#' @return tibble
#' @export
#' @import httr
#' @importFrom jsonlite fromJSON
#' @importFrom glue glue
#'

sarb_code <- function(code, token = NULL){

  token <- token %||%
    getOption("sarb.token") %||%
    ifelse(Sys.getenv("sarb.token") != "", Sys.getenv("sarb.token"), NULL) %||%
    stop("Token not specified")

  res <- GET(
    glue("api.daeconomist.com/service/sarbr/sarb?code={code}"),
    authenticate(get("user"), get("passw")),
    add_headers(token = token),
    config(ssl_verifypeer = 0)
  )

  if(res$status_code != 200)
    stop(content(res))

  res <- jsonlite::fromJSON(content(res, "text", encoding = "UTF-8"))

  res %>%
    as_tibble()
}
