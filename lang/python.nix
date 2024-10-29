{
  lib,
  pkgs,
  ...
}: {
  plugins.lsp.servers = {
    ruff.enable = true;
    pyright = {
      enable = true;
      settings = {
        pyright.disableOrganizeImports = true;
        python.analysis.ignore = ["*"];
      };
    };
  };

  plugins.conform-nvim.settings = {
    formatters_by_ft.python = ["black"];
    formatters.black = {
      command = "${lib.getExe pkgs.black}";
    };
  };
}
