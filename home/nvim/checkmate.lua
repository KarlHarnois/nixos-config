local function lowercase_leader_prefix(lhs)
  return (lhs:gsub("<leader>T", "<leader>t", 1))
end

local function lower_key_prefixes(config)
  local keys = {}
  for lhs, mapping in pairs(config.keys) do
    keys[lowercase_leader_prefix(lhs)] = mapping
  end
  config.keys = keys
end

local function lower_metadata_prefixes(config)
  for _, tag in pairs(config.metadata) do
    if tag.key then
      tag.key = lowercase_leader_prefix(tag.key)
    end
  end
end

local config = vim.deepcopy(require("checkmate.config.defaults"))

lower_key_prefixes(config)
lower_metadata_prefixes(config)

require("checkmate").setup(config)
