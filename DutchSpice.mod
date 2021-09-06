return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`DutchSpice` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("DutchSpice", {
			mod_script       = "scripts/mods/DutchSpice/DutchSpice",
			mod_data         = "scripts/mods/DutchSpice/DutchSpice_data",
			mod_localization = "scripts/mods/DutchSpice/DutchSpice_localization",
		})
	end,
	packages = {
		"resource_packages/DutchSpice/DutchSpice",
	},
}
