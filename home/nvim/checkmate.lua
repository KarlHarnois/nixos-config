local function lowercase_leader_prefix(lhs)
  return (lhs:gsub("<leader>T", "<leader>t", 1))
end

local function remapped_keys(defaults)
  local keys = {}
  for lhs, mapping in pairs(defaults.keys) do
    keys[lowercase_leader_prefix(lhs)] = mapping
  end
  return keys
end

local function remapped_metadata(defaults)
  local metadata = vim.deepcopy(defaults.metadata)
  for _, tag in pairs(metadata) do
    if tag.key then
      tag.key = lowercase_leader_prefix(tag.key)
    end
  end
  return metadata
end

local defaults = require("checkmate.config.defaults")

require("checkmate").setup({
  keys = remapped_keys(defaults),
  metadata = remapped_metadata(defaults),
})
