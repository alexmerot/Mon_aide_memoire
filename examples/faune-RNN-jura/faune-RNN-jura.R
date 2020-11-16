# Codes pour l'exemple sur l'extraction des données d'un PDF.
#
# Les données extraites sont exportées en RDS pour être réutilisées sans que le
# code soit exécuté à chaque fois que l'aide-mémoire est généré.

library("tabulizer")

pdf_data_jura <- "examples/faune-RNN-jura/Faune-vertebres-PG3.pdf"

jura_data <- extract_tables(pdf_data_jura) %>%
  purrr::map(as.data.frame)

saveRDS(jura_data, file = "examples/faune-RNN-jura/jura_data.RDS")

# Modification de la ligne incluant une erreur.
line_id <- which(jura_data[[3]][, 16] == "1")

jura_data[[3]][line_id,] <- list(
  "Tetrao urogallus major C. L. Brehm, 1831",
  "Grand Tétras",
  "2018",
  "oui",
  "oui",
  "VU",
  "CR",
  "oui",
  NA,
  "oui",
  NA,
  "En déclin",
  "Forte",
  "Forte",
  "1",
  ""
)

# Fonction permettant de nettoyer les données en les standardisant.
clean_extracted_data <- function(data_extracted) {
  cleaned_df <- data_extracted %>%
    janitor::row_to_names(1) %>%
    janitor::clean_names()

  # Création de la fonction qui remplacera les puces typographiques.
  replace_bullet <- function(x) {
    if (is.na(x)) {
      output = x
    } else {
      if (x == "•") {
        output = "oui"
      } else if (x == "") {
        output = "non"
      } else {
        output = x
      }
    }

    return(output)
  }

  cleaned_df <- cleaned_df %>%
    # Pour chaque colonne ayant les puces, on les remplace.
    mutate(across(where(~ any(grepl("•", .))), ~ purrr::map_chr(., replace_bullet))) %>%
    ungroup() %>%
    # Pour les colonnes où les cases vides ne représentent pas des NA, on les
    # remplacent par "—".
    mutate(across(starts_with(c("lr_", "ec_")), ~ ifelse(. == "", "—", .))) %>%
    na_if("") %>% # On remplace les cases vides restantes par des NA.
    janitor::remove_empty(c("rows", "cols")) # Suppression des lignes et colonnes vides

  rownames(cleaned_df) <- NULL # Actualisation des numéros de ligne

  return(cleaned_df)
}

# Standardisation des données.
jura_data_cleaned <- jura_data %>% purrr::map(clean_extracted_data)

avifaune_jura <- bind_rows(jura_data_cleaned[[3]], jura_data_cleaned[[4]])

readr::write_csv(avifaune_jura, file = "examples/faune-RNN-jura/avifaune_jura.csv")
