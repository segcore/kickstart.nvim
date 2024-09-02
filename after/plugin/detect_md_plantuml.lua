local function check_for_header(path, bufnr)
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
    if string.match(content, "^```plantuml") then
        return 'plantuml'
    end
    return 'markdown'
end
vim.schedule(function()
    vim.filetype.add({
        extension = {
            md = check_for_header,
        },
    })
end)
