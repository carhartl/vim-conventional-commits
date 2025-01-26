let s:commit_types = [
  \ 'build: ',
  \ 'chore: ',
  \ 'ci: ',
  \ 'docs: ',
  \ 'feat: ',
  \ 'fix: ',
  \ 'perf: ',
  \ 'refactor: ',
  \ 'revert: ',
  \ 'style: ',
  \ 'test: ',
  \ ]

augroup conventional
  au FileType gitcommit 1 | startinsert! | set completefunc=s:complete_commit_types | inoremap <Tab> <C-R>=<sid>smart_tab()<CR>
  au FileType gitcommit inoreabbrev <buffer> BB BREAKING CHANGE:
augroup END

fun! s:complete_commit_types(findstart, base)
  if a:findstart
    " Locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    let res = []
    for t in s:commit_types
      if t =~ '^' .. a:base
        call add(res, t)
      endif
    endfor
    return res
  endif
endfun

fun! s:smart_tab()
  " Empty commit message/first line contains some characters tab
  " => pop up autocomplete/complete the started word right away
  if line(".") == 1 && getline('.') =~ '\v^[a-z]{0,7}$'
    return "\<C-X>\<C-U>"
  else
    return "\<Tab>"
  endif
endfun
