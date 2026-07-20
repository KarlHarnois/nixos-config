{
  programs.readline = {
    enable = true;

    variables = {
      completion-ignore-case = true;
      completion-prefix-display-length = 2;
      completion-query-items = 200;
      show-all-if-ambiguous = true;
      show-all-if-unmodified = true;
      menu-complete-display-prefix = true;
      mark-symlinked-directories = true;
      match-hidden-files = false;
      page-completions = false;
      skip-completed-text = true;
      colored-stats = true;
      visible-stats = true;
    };

    bindings = {
      "\\t" = "menu-complete";
      "\\e[Z" = "menu-complete-backward";
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
  };
}
