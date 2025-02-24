local mod = get_mod("DutchSpice")

return {
	name = "DutchSpice",
	description = mod:localize("mod_description"),
	is_togglable = false,
	options = {
		widgets = {
			{
				setting_id = "enhanced_specials",
                type = "checkbox",
                default_value = true
            },
			{
				setting_id = "auras_and_mutators",
                type = "checkbox",
                default_value = true
            },
			{
				setting_id = "elves",
                type = "checkbox",
                default_value = false
            },
		}
	}
}
