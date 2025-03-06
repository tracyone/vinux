require("CopilotChat").setup {
  -- Default model to use
  model = 'gpt-4o',
  
  -- Default agent to use
  agent = 'copilot',
  
  -- Default context or array of contexts to use
  context = nil,
  
  -- Default sticky prompt or array of sticky prompts to use at start of every new chat
  sticky = nil,
  
  -- GPT result temperature
  temperature = 0.3,
  
  -- Do not write to chat buffer and use history
  headless = false,
  
  -- Callback to use when ask response is received
  callback = nil,
  
  -- Default selection
  
  auto_insert_mode = true, -- Automatically enter insert mode when opening window and on new prompt

  selection = function(source)
    return require("CopilotChat.select").visual(source) or require("CopilotChat.select").buffer(source)
  end,

  -- Window options
  window = {
    layout = 'float', -- Use floating window
    width = 0.5, -- Fractional width of parent
    height = 0.5, -- Fractional height of parent
    relative = 'editor', -- Relative to the editor
    border = 'rounded', -- Rounded border
    row = vim.api.nvim_get_option('lines') / 2 - 4,
    col = vim.api.nvim_get_option('columns') / 2, -- column position of the window, default is centered
    title = 'Copilot Chat', -- Title of chat window
    zindex = 1, -- Z-index for window layering
    winblend = 30, -- transparency level (0-100)
  },

  mappings = {
      complete = {
          insert = '<Tab>',
      },
      close = {
          normal = 'q',
          insert = '<C-c>',
      },
      reset = {
          normal = '',
          insert = '',
      },
      submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
      },
      toggle_sticky = {
          detail = 'Makes line under cursor sticky or deletes sticky line.',
          normal = 'gr',
      },
      accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
      },
      jump_to_diff = {
          normal = 'gj',
      },
      quickfix_answers = {
          normal = 'gqa',
      },
      quickfix_diffs = {
          normal = 'gqd',
      },
      yank_diff = {
          normal = 'gy',
          register = '"', -- Default register to use for yanking
      },
      show_diff = {
          normal = 'gd',
          full_diff = false, -- Show full diff instead of unified diff when showing diff window
      },
      show_info = {
          normal = 'gi',
      },
      show_context = {
          normal = 'gc',
      },
      show_help = {
          normal = 'gh',
      },
  },
}
return module
