get_datasetfile <- function() {
    key <- Sys.getenv("AWS_ACCESS_KEY_ID")
    secret <- Sys.getenv("AWS_SECRET_ACCESS_KEY")
    path <- paste0("s3://", key, ":", secret, "@metareview/neotomaMetadata.parquet")

    paper_dataset <- read_parquet(path) %>% as.data.frame()
    return(paper_dataset)
}
