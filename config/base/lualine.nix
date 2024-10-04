{ icons, ... }:
let
  separators = {
    left = "";
    right = "";
  };
in
{
  plugins.lualine = {
    enable = true;
    settings.options = {
      always_divide_middle = true;
      icons_enable = true;
      component_separators = separators;
      section_separators = separators;
      disabled_filetypes = [
        "Outline"
        "neo-tree"
        "dashboard"
      ];
    };
  };

  extraConfigLua = # lua
    ''
      local components = {}
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if vim.b.gitsigns_status_dict then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end

      components.diff = {
        "diff",
        source = diff_source,
        symbols = {
          added = "${icons.git.LineAdded}" .. " ",
          modified = "${icons.git.LineModified}" .. " ",
          removed = "${icons.git.LineRemoved}" .. " ",
        },
      }
      components.branch = {
        "b:gitsigns_head",
        icon = "${icons.git.Branch}",
        color = { gui = "bold" },
      }
      components.diff = {
        "diff",
        source = diff_source,
        symbols = {
          added = "${icons.git.LineAdded}" .. " ",
          modified = "${icons.git.LineModified}" .. " ",
          removed = "${icons.git.LineRemoved}" .. " ",
        },
      }
      components.diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
          error = "${icons.diagnostics.BoldError}" .. " ",
          warn = "${icons.diagnostics.BoldWarning}" .. " ",
          info = "${icons.diagnostics.BoldInformation}" .. " ",
          hint = "${icons.diagnostics.BoldHint}" .. " ",
        },
      }
      components.copilot =  function()
        local lsp_clients = vim.lsp.get_active_clients()
        for _, client in ipairs(lsp_clients) do
          if client.name == "copilot" then
            return "%#SLGreen#" .. "${icons.kind.Copilot}"
          end
        end
         return ""
      end
      components.indicator = function()
        local noice = require("noice")
        return {
          noice.api.statusline.mode.get,
          cond = noice.api.statusline.mode.has,
          color = { fg = "#ff9e64" },
        }
      end
      components.location = { "location", color = { fg = "#000000" }, }
      components.filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } }
      components.fileformat = { "fileformat", cond = nil, padding = { left = 1, right = 1 }, color = "SLGreen" }
      components.lsp = {
        function()
          local clients = vim.lsp.get_active_clients()
          local lsp_names = {}
          if next(clients) == nil then
            return "Ls Inactive"
          end
          for _, client in ipairs(clients) do
            if client.name ~= "copilot" and client.name ~= "null-ls" then
              table.insert(lsp_names, client.name)
            end
          end

          local formatters = require("conform").list_formatters()
          local con_names = {}

          for _, formatter in ipairs(formatters) do
            if formatter.available then
              table.insert(con_names, formatter.name)
            end
          end
          local names = {}
          vim.list_extend(names, lsp_names)
          vim.list_extend(names, con_names)
          return "[" .. table.concat(vim.fn.uniq(names), ", ") .. "]"
        end
      };


      local sections = {
        lualine_a = { components.mode },
        lualine_b = { components.fileformat, "encoding" },
        lualine_c = { components.branch, components.diff, components.diagnostics },
        lualine_x = {
          components.indicator(),
          components.filetype,
          components.lsp,
        },
        lualine_y = { "progress" },
        lualine_z = { components.location, components.copilot },
      }

      local lualine = require("lualine")
      local config = lualine.get_config()
      config.sections = sections
      require("lualine").setup(config)
    '';
}
