{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (
      julia.withPackages
      [
        "DataFrames"
        "CSV"
      ]
    )
  ];

  extraPlugins = [pkgs.vimPlugins.julia-vim];
  globals.latex_to_unicode_keymap = true;

  plugins = {
    lsp.servers.julials.enable = true;
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
