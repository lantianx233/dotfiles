{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs = {
    nushell = {
      enable = true;
      extraConfig = ''
        let carapace_completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
        }
        $env.config = {
         show_banner: false,
         completions: {
         case_sensitive: false # case-sensitive completions
         quick: true    # set to false to prevent auto-selecting completions
         partial: true    # set to false to prevent partial filling of the prompt
         algorithm: "fuzzy"    # prefix or fuzzy
         external: {
         # set to false to prevent nushell looking into $env.PATH to find more suggestions
         enable: true
         # set to lower can improve completion performance at the cost of omitting some options
         max_results: 100
         completer: $carapace_completer # check 'carapace_completer'
           }
         }
        }
      '';
      shellAliases = {
        sw = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
        error = "journalctl -b -p err";
        v = "nvim";
        vim = "nvim";
        c = "clear";
        cd = "z";
        rsync = "rsync -avhzP";
        rm = "rm -I";
        cp = "cp -irnv";
        mv = "mv -inv";
        bye = "shutdown now";
        la = "ls -la";
      };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
}
