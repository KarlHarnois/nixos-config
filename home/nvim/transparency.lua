-- Make highlight groups transparent while preserving their other attributes
local function make_transparent(name)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if ok then
		hl.bg = nil
		vim.api.nvim_set_hl(0, name, hl --[[@as vim.api.keyset.highlight]])
	end
end

local groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"Pmenu",
	"EndOfBuffer",
	"FoldColumn",
	"Folded",
	"SignColumn",
	"LineNr",
	"CursorLineNr",
	"NeoTreeNormal",
	"NeoTreeNormalNC",
	"NeoTreeVertSplit",
	"NeoTreeWinSeparator",
	"NeoTreeEndOfBuffer",
}

for _, name in ipairs(groups) do
	make_transparent(name)
end
