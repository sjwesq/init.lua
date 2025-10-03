function fzfbridge#runwrap(dict)
  call fzf#run(fzf#wrap(a:dict))
endfunction
