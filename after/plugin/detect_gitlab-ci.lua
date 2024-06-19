-- For gitlab-ci-ls
vim.filetype.add({
    filename = {
        ['.gitlab-ci.yml'] = 'yaml.gitlab',
        ['.gitlab-ci.yaml'] = 'yaml.gitlab',
    },
})
