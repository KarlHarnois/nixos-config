{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      core.editor = "nvim";

      alias = {
        w = "worktree";
        wa = "worktree add";
        wr = "worktree remove";
        aa = "add --all";
        b = "branch";
        c = "commit";
        co = "checkout";
        ds = "diff --staged";
        fp = "push origin HEAD --force-with-lease";
        p = "push origin HEAD";
        s = "status";
      };

      rebase.autosquash = true;
    };
  };
}
