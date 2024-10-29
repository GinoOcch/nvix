{
  lib,
  pkgs,
  ...
}: let
  jl_ls = with pkgs; (
    julia.withPackages
    [
      "LanguageServer"
      "JuliaFormatter"
    ]
  );
in {
  extraPlugins = [pkgs.vimPlugins.julia-vim];
  globals.latex_to_unicode_keymap = true;

  plugins = {
    lsp.servers.julials.enable = true;
    lsp.servers.julials.package = jl_ls;

    conform-nvim.settings = {
      formatters_by_ft.julia = ["julia"];
      formatters.julia = {
        command = "${lib.getExe jl_ls}";
        args = ["--startup-file=no" "--color=no" "-e" "using JuliaFormatter;  print(format_text(String(read(stdin))))"];
      };
    };

    julia-cell = {
      enable = true;
      settings.delimit_cells_by = "tags";

      keymaps = {
        silent = true;
        clear = "<Leader>jl";
        executeCell = "<Leader>jc";
        executeCellJump = "<Leader>jC";
        nextCell = "<Leader>jn";
        prevCell = "<Leader>jp";
        run = "<Leader>jr";
      };
    };
  };
}
