{
  lib,
  pkgs,
  ...
}: {
  extraPlugins = [pkgs.vimPlugins.julia-vim];
  globals.latex_to_unicode_keymap = true;

  plugins = {
    lsp.servers.julials.enable = true;
    lsp.servers.julials.package = null;

    conform-nvim.settings = {
      formatters_by_ft.julia = ["julia"];
      formatters.julia = {
        command = "julia";
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
