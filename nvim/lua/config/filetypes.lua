vim.filetype.add({
  extension = {
    templ = 'templ',
    m = 'objc',
    h = function(path, bufnr)
      local mpath, _ = path:gsub('%.h$', '.m')

      if vim.loop.fs_stat(mpath) ~= nil then
        return 'objc'
      end

      return 'c'
    end
  }
})
