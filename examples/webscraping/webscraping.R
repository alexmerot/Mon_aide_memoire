# Codes pour l'exemple du web-scraping.
#
# Permet d'extraire la classification des oiseaux présents dans la Réserve
# Naturelle de la Haute Chaîne du Jura. Les données ainsi recueillies sont
# sauvegardées au format CSV pour pouvoir être utilisées dans la section 2.2.
#
# Cela permet d'éviter que le code soit exécuté à chaque fois que l'aide-mémoire
# est généré.


library("rvest")
library("dplyr")

# Données du PDF
avifaune_jura <- readr::read_csv("examples/faune-RNN-jura/avifaune_jura.csv")

# Fonction permettant de récupérer la classification des oiseaux.
get_bird_classification <- function(bird, taxon = c("Ordre", "Famille")) {
  wiki_link <- "https://fr.wikipedia.org/wiki/Wikip%C3%A9dia:Accueil_principal"

  # On ouvre une session sur la page d'accueil de Wikipédia
  session <- html_session(wiki_link)

  # On écrit dans la barre de recherche le nom de l'oiseau
  form <- html_form(session)
  form_modified <- set_values(form[[1]], search = bird)

  # On entre sur la page wikipédia de l'oiseau
  wiki_bird <- submit_form(session, form_modified, submit = "go")

  tbl_classification <- wiki_bird %>%
    # On récupère le nœud HTML contenant le tableau
    html_node(xpath = "//table[@class='taxobox_classification']") %>%
    # On extrait le tableau
    html_table() %>%
    # Puis on met en forme ce tableau
    magrittr::set_colnames(c("niveau_classification", "nom_classification")) %>%
    filter(niveau_classification %in% taxon) %>%
    tidyr::pivot_wider(
      names_from = niveau_classification,
      values_from = nom_classification
    )

  tbl_classification$nom <- bird

  return(tbl_classification)
}

noms_latin <- stringr::str_extract_all(avifaune_jura$nom_latin, r"(^\w+\s+\w+)")

classification_oiseaux <- purrr::map(noms_latin, get_bird_classification) %>%
  bind_rows()

avifaune_jura <- avifaune_jura %>%
  mutate(nom = unlist(noms_latin)) %>%
  left_join(classification_oiseaux, by = "nom") %>%
  select(-nom) %>%
  relocate(Ordre:last_col())

readr::write_csv(avifaune_jura, file = "examples/webscraping/classification_avifaune.csv")
