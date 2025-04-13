set number
syntax on
:colorscheme jellybeans

inoremap <c-b> <Esc>:w<cr>:Lex<cr>:vertical resize 30<cr>
nnoremap <c-b> <Esc>:Lex<cr>:vertical resize 30<cr>

nnoremap <C-l> :botright vertical terminal cgpt --no-history<CR><C-\><C-n>:vertical resize 50<CR>i
inoremap <C-l> <Esc>:botright vertical terminal cgpt --no-history<CR><C-\><C-n>:vertical resize 50<CR>i
