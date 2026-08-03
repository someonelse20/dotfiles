return {
  'olimorris/codecompanion.nvim',
  version = '^19.0.0',
  opts = {
    interactions = {
      chat = {
        adapter = {'openclaw'},
      },
      inline = {
        adapter = 'openclaw',
      },
      cmd = {
        adapter = 'openclaw',
      },
    },
    adapters = {
      acp = {
        opencode = function()
          return require('codecompanion.adapters').extend('opencode', {
            env = {
              url = 'unix:///var/run/opencode.sock',
              api_key = 'OPENCODE_API_KEY',
            },
          })
        end,
        openclaw = function()
          local helpers = require 'codecompanion.adapters.acp.helpers'
          return {
            name = 'assistant',
            formatted_name = 'assistant',
            type = 'acp',
            roles = {
              llm = 'assistant',
              user = 'user',
            },
            commands = {
              default = {
                'openclaw',
                'acp',
              },
            },
            defaults = {
              mcpServers = {},
              timeout = 20000, -- 20 seconds
            },
            parameters = {
              protocolVersion = 1,
              clientCapabilities = {
                fs = { readTextFile = true, writeTextFile = true },
              },
              clientInfo = {
                name = 'CodeCompanion.nvim',
                version = '1.0.0',
              },
            },
            handlers = {
              setup = function(self)
                return true
              end,
              auth = function(self)
                return true
              end,
              form_messages = function(self, messages, capabilities)
                return helpers.form_messages(self, messages, capabilities)
              end,
              on_exit = function(self, code) end,
            },
          }
        end,
      },
      http = {
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            env = {
              url = 'http://192.168.40.28:11434',
              api_key = 'OLLAMA_API_KEY',
            },
            headers = {
              ['Content-Type'] = 'application/json',
              ['Authorization'] = 'Bearer ${api_key}',
            },
            parameters = {
              sync = true,
            },
          })
        end,
        lmstudio = function()
          return require('codecompanion.adapters').extend('openai', {
            url = 'http://192.168.40.28:1234/v1/chat/completions',
            env = {},
            schema = {
              model = {
                order = 1,
                mapping = 'parameters',
                type = 'enum',
                desc = 'ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.',
                default = 'qwen/qwen3.5-9b',
                choices = {
                  'qwen/qwen3.5-9b',
                },
              },
            },
          })
        end,
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
