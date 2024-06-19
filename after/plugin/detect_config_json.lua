local function check_for_json(path, bufnr)
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
    if string.match(content, "^{") then
        return 'json'
    end
end
vim.filetype.add({
    extension = {
        config = check_for_json,
        txt = check_for_json,
    },
})
