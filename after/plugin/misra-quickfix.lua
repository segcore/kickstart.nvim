local M = {}

local html_unescape = function(text)
  text = string.gsub(text, '&lt;', '<')
  text = string.gsub(text, '&gt;', '>')
  text = string.gsub(text, '&amp;', '&')
  text = string.gsub(text, '&nbsp;', ' ')
  return text
end

local parse_line = function(result, input_line)
  local file_pattern = '([-_/%w%.]+)'
  local words = '([^<]*)'
  local pattern = '<span class="pos">' .. file_pattern .. ':(%d+).(%d+)-(%d+).(%d+):'
    .. '</span></a><button class="preview%-button"></button> <span class="reports%-message">'
    .. words

  for file, line1, col1, line2, col2, text in string.gmatch(input_line, pattern) do
    table.insert(result, {
      filename = file,
      lnum = line1,
      end_lnum = line2,
      col = col1,
      end_col = col2,
      valid = true,
      text = html_unescape(text),
    })
  end
end

local parse_file_to_table = function(buffer)
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
  local result = {}
  for _, line in ipairs(lines) do
    parse_line(result, line)
  end
  return result
end

local parse_file_to_qf = function(buffer)
  local result = parse_file_to_table(buffer)
  if next(result) then
    vim.fn.setqflist(result)
    vim.cmd("copen")
  end
end

vim.keymap.set('n', '<leader>M', function() parse_file_to_qf(0) end,
  { desc = 'Quickfix: Misra from current file' })

M._parse_line = parse_line
M.html_unescape = html_unescape
M.parse_file_to_table = parse_file_to_table
M.parse_file_to_qf = parse_file_to_qf
return M
