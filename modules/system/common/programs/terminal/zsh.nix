{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.zsh.enable = true;
  environment.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    ZDOTDIR = "$HOME/.config/zsh";
  };
  hj = {
    rum.programs.zsh = {
      enable = true;
      initConfig = ''
        # enable vi mode
        bindkey -v
        export KEYTIMEOUT=1
        export ZDOTDIR="$HOME/.config/zsh"
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.cargo/bin:$PATH"
        # history
        SAVEHIST=2000
        HISTSIZE=5000

        # aliases
        alias ls=lsd
        ## git
        alias lg='lazygit'
        alias g='git'
        alias gs='git status'
        alias ga='git add'
        alias gc='git commit'
        alias gca='git commit --amend'
        alias gcm='git commit --message'
        alias gk='git checkout'
        alias gd='git diff'
        alias gf='git fetch'
        alias gl='git log'
        alias gp='git push'
        alias gpf='git push --force-with-lease'
        alias gr='git reset'
        alias gt='git stash'
        alias gtp='git stash pop'
        alias gu='git pull'

        ## bat
        alias man='batman'
        alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

        # TODO: switch to the hjr module once integrations get upstreamed
        # zoxide integration
        eval "$(zoxide init zsh)"

        . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
      '';

      plugins = {
        nix-zsh-completions = {
          source = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
          completions = ["${pkgs.nix-zsh-completions}/share/zsh/site-functions"];
        };
        zsh-completions.completions = ["${pkgs.zsh-completions}/share/zsh/site-functions"];
        zsh-fzf-tab = {
          source = "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh";
          config = ''
            source <(fzf --zsh)

            # use lsd for fzf preview
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd'
            zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd'
            # disable sort when completing `git checkout`
            zstyle ':completion:*:git-checkout:*' sort false
            # set descriptions format to enable group support
            # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
            zstyle ':completion:*:descriptions' format '[%d]'
            # set list-colors to enable filename colorizing
            zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
            # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
            zstyle ':completion:*' menu no
            # preview directory's content with eza when completing cd
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
            # custom fzf flags
            # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
            zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
            # To make fzf-tab follow FZF_DEFAULT_OPTS.
            # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
            zstyle ':fzf-tab:*' use-fzf-default-opts yes
            # switch group using `<` and `>`
            zstyle ':fzf-tab:*' switch-group '<' '>'
          '';
        };
        zsh-autosuggestions = {
          source = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
          config = ''
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=gray,underline"
          '';
        };
        zsh-syntax-highlighting = {
          source = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
          config = ''
                          typeset -gA ZSH_HIGHLIGHT_STYLES
            ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
            ZSH_HIGHLIGHT_STYLES[default]=none
            ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e05f65,bold'
            ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#74bee9,bold'
            ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#78dba9,underline'
            ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#78dba9,bold'
            ZSH_HIGHLIGHT_STYLES[precommand]='fg=#78dba9,underline'
            ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#70a5eb,bold'
            ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#78dba9,underline'
            ZSH_HIGHLIGHT_STYLES[path]='bold'
            ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
            ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
            ZSH_HIGHLIGHT_STYLES[globbing]='fg=#70a5eb,bold'
            ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#70a5eb,bold'
            ZSH_HIGHLIGHT_STYLES[command-substitution]='none'
            ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#c68aee,bold'
            ZSH_HIGHLIGHT_STYLES[process-substitution]='none'
            ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#c68aee,bold'
            ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#78dba9'
            ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#78dba9'
            ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
            ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#70a5eb,bold'
            ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f1cf8a'
            ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f1cf8a'
            ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#f1cf8a'
            ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#c68aee'
            ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#c68aee,bold'
            ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#c68aee,bold'
            ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#c68aee,bold'
            ZSH_HIGHLIGHT_STYLES[assign]='none'
            ZSH_HIGHLIGHT_STYLES[redirection]='fg=#70a5eb,bold'
            ZSH_HIGHLIGHT_STYLES[comment]='fg=#3c474d,bold'
            ZSH_HIGHLIGHT_STYLES[named-fd]='none'
            ZSH_HIGHLIGHT_STYLES[numeric-fd]='none'
            ZSH_HIGHLIGHT_STYLES[arg0]='fg=#74bee9'
            ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#e05f65,bold'
            ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#70a5eb,bold'
            ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#78dba9,bold'
            ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#c68aee,bold'
            ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#f1cf8a,bold'
            ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=#74bee9,bold'
            ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
          '';
        };
      };
    };
  };
}
