load_raw_csvs <- function() {
    neotoma <- readr::read_csv('data/raw/neotoma_crossref_fixed.csv',
        show_col_types = FALSE) %>%
        mutate(label = "Neotoma", source = "Neotoma") %>%
        select(doi, label, source) %>%
        unique()

    first_labeled <- readr::read_csv('data/raw/pollen_doc_labels.csv',
        show_col_types = FALSE) %>%
        rename(label = Label) %>%
        mutate(source = "PubMed") %>%
        select(doi, label, source) %>%
        bind_rows(readr::read_csv('data/raw/project_2_labeled_data.csv',
        show_col_types = FALSE) %>%
        rename(label = Label) %>%
        mutate(source = "PubMed") %>%
        select(doi, label, source))

    output <- neotoma %>%
        bind_rows(first_labeled) %>%
        unique()

    if (file.exists("data/crossref_meta.rds")) {
        more_meta <- readRDS("data/crossref_meta.rds")
    } else {
        more_meta <- cr_works(doi = unique(output$doi))
        saveRDS(more_meta, "data/crossref_meta.rds")
    }

    meta_data <- more_meta$data %>%
        unique()

    out_full <- output %>%
        inner_join(meta_data, by = "doi") %>%
        select(doi, label, `source.x`, `container.title`, `subject`) %>%
        rename(source = "source.x", journal = "container.title") %>%
        tidyr::separate_longer_delim(subject, stringr::regex(",")) %>%
        mutate(subject = stringr::str_trim(subject))
    
    return(out_full)

}