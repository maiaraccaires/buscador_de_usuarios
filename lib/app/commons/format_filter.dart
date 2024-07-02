String formatFilter(String filter) {
  switch (filter) {
    case "location":
      return "Localização";
    case "language":
      return "Linguagem";
    case "repos":
      return "Repositório";
    case "followers":
      return "Seguidores";
    default:
      return "";
  }
}
