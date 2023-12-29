-- vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gs", "<cmd>:tab Git<CR>", { desc = 'Open Git status in new tab' })

local my_fugitive = vim.api.nvim_create_augroup("my_fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = my_fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = {buffer = bufnr, remap = false}
        opts.desc = "git push"
        vim.keymap.set("n", "<leader>gp", function()
            vim.cmd.Git('push')
        end, opts)

        -- rebase always
        opts.desc = "git pull --rebase"
        vim.keymap.set("n", "<leader>gP", function()
            vim.cmd.Git({'pull',  '--rebase'})
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        opts.desc = "git push -u origin"
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
    end,
})
