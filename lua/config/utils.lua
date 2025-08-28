local utils = {}

function utils.is_plugin_registered(name)
  return require("lazy.core.config").plugins[name] ~= nil
end

return utils
