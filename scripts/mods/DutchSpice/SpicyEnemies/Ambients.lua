local mod = get_mod("DutchSpice")

local HEAVY_WEIGHT = 10
local MEDIUM_WEIGHT = 5
local LIGHT_WEIGHT = 2

mod:echo("Beastmen modified")

--Beastmen Ambients
BreedPacks.skaven_beastmen = {
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_clan_rat
    }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor_archer
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor_dummy
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    roof_spawning_allowed = true,
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    3,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    3,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    4,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    3,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    4,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    7,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm = {
                {
                    7,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_2 = {
                {
                    7,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_3 = {
                {
                    7,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    7,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    3,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    3,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    3,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    3,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    4,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    5,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    3,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm = {
                {
                    5,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_2 = {
                {
                    5,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_3 = {
                {
                    5,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            }
        }
    },
    patrol_overrides = {
        patrol_chance = 1
    }
}
BreedPacks.chaos_beastmen = {
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor_archer
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_raider
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_ungor_archer
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_ungor_archer
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_warrior,
            Breeds.chaos_raider,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_warrior,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor_dummy
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_warrior,
            Breeds.chaos_raider,
            Breeds.chaos_raider,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor_archer
        }
    },
    roof_spawning_allowed = true,
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    3,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    3,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    3,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    3,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    3,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    3,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    4,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    7,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    3,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    3,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm = {
                {
                    7,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_2 = {
                {
                    7,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_3 = {
                {
                    7,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    4,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    2,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    4,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    2,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    5,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    6,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    4,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm = {
                {
                    5,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_2 = {
                {
                    5,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_3 = {
                {
                    5,
                    "chaos_raider",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "chaos_warrior",
                    Breeds.chaos_marauder
                },
                {
                    5,
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    1,
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            }
        }
    },
    patrol_overrides = {
        patrol_chance = 1
    }
}
BreedPacks.beastmen = {
    {
        spawn_weight = 1,
        members = {
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor_archer
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor_archer
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor_dummy,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.beastmen_bestigor_dummy,
            Breeds.beastmen_bestigor_dummy,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    roof_spawning_allowed = true,
    patrol_overrides = {
        patrol_chance = 1
    },
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    {
                        1,
                        1
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        1,
                        2
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    {
                        1,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    {
                        2,
                        4
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                }
            },
            cataclysm = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                }
            },
            cataclysm_2 = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                }
            },
            cataclysm_3 = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    {
                        0,
                        1
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        0,
                        0
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    {
                        0,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    {
                        1,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        3,
                        4
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    {
                        1,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_2 = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_3 = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            }
        }
    }
}
BreedPacks.beastmen_elites = {
    {
        spawn_weight = 1,
        members = {
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor
        }
    },
    {
        spawn_weight = 5,
        members = {
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor
        }
    },
    {
        spawn_weight = 5,
        members = {
            Breeds.beastmen_ungor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_bestigor_dummy,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_bestigor_dummy,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor
        }
    },
    {
        spawn_weight = 5,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor
        }
    },
    {
        spawn_weight = 5,
        members = {
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor
        }
    },
    roof_spawning_allowed = true,
    patrol_overrides = {
        patrol_chance = 1
    },
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    {
                        1,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        3,
                        4
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    {
                        2,
                        4
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                }
            },
            cataclysm = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                }
            },
            cataclysm_2 = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                }
            },
            cataclysm_3 = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    {
                        0,
                        1
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        0,
                        0
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    {
                        0,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    {
                        1,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        3,
                        4
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_ungor_archer",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    {
                        1,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_2 = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_3 = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            }
        }
    }
}
BreedPacks.beastmen_light = {
    {
        spawn_weight = 1,
        members = {
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_ungor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_ungor_archer,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = 5,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 5,
        members = {
            Breeds.beastmen_ungor_archer,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_ungor_archer,
            Breeds.beastmen_ungor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor_archer
        }
    },
    {
        spawn_weight = 5,
        members = {
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor_archer,
            Breeds.beastmen_ungor,
            Breeds.beastmen_bestigor
        }
    },
    {
        spawn_weight = 5,
        members = {
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor_archer,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_bestigor,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor_dummy,
            Breeds.beastmen_gor,
            Breeds.beastmen_gor,
            Breeds.beastmen_ungor,
            Breeds.beastmen_ungor_archer
        }
    },
    roof_spawning_allowed = true,
    patrol_overrides = {
        patrol_chance = 1
    },
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        0,
                        1
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    {
                        3,
                        4
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        0,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        5
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    {
                        5,
                        6
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        1,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        4,
                        6
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    {
                        7,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        10,
                        12
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm = {
                {
                    {
                        7,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        10,
                        12
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_2 = {
                {
                    {
                        7,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        10,
                        12
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_3 = {
                {
                    {
                        7,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        4,
                        5
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        10,
                        12
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    {
                        1,
                        2
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        0,
                        1
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            hard = {
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        0,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            harder = {
                {
                    {
                        3,
                        4
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        1,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        3,
                        4
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            hardest = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        1,
                        2
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_2 = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            },
            cataclysm_3 = {
                {
                    {
                        4,
                        5
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                },
                {
                    {
                        2,
                        3
                    },
                    "beastmen_bestigor",
                    Breeds.beastmen_gor
                },
                {
                    {
                        6,
                        8
                    },
                    "beastmen_gor",
                    Breeds.beastmen_ungor
                }
            }
        }
    }
}
BreedPacks.standard = {
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_marauder_tutorial,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_marauder_tutorial,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_raider,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_dummy_slave,
            Breeds.skaven_dummy_slave,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_dummy_clan_rat,
            Breeds.skaven_dummy_clan_rat,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_raider,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder_tutorial,
            Breeds.chaos_marauder,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic
        }
    },
    roof_spawning_allowed = true,
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    1,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hard = {
                {
                    2,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            harder = {
                {
                    2,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    2,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hardest = {
                {
                    7,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    7,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm = {
                {
                    7,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    7,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_2 = {
                {
                    7,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    7,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_3 = {
                {
                    7,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    7,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    0,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    0,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hard = {
                {
                    1,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            harder = {
                {
                    2,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    2,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hardest = {
                {
                    5,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    5,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm = {
                {
                    5,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    5,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_2 = {
                {
                    5,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    5,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_3 = {
                {
                    5,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    5,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            }
        }
    },
    patrol_overrides = {
        patrol_chance = 1
    }
}
BreedPacks.standard_no_elites = {
    {
        spawn_weight = 10,
        members = {
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = 3.5,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 2,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = 2,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 4,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = 3.5,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 4,
        members = {
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder,
            Breeds.chaos_marauder
        }
    },
    {
        spawn_weight = 2.5,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 10,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = 2,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    roof_spawning_allowed = true,
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    1,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hard = {
                {
                    2,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            harder = {
                {
                    2,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    2,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hardest = {
                {
                    {
                        6,
                        8
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        6,
                        8
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm = {
                {
                    {
                        6,
                        8
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        6,
                        8
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_2 = {
                {
                    {
                        6,
                        8
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        6,
                        8
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_3 = {
                {
                    {
                        6,
                        8
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        6,
                        8
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    0,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    0,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hard = {
                {
                    1,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            harder = {
                {
                    2,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    2,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hardest = {
                {
                    {
                        4,
                        5
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        4,
                        5
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm = {
                {
                    {
                        4,
                        5
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        4,
                        5
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_2 = {
                {
                    {
                        4,
                        5
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        4,
                        5
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_3 = {
                {
                    {
                        4,
                        5
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        4,
                        5
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            }
        }
    },
    patrol_overrides = {
        patrol_chance = 1
    }
}
BreedPacks.skaven = {
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    roof_spawning_allowed = true,
    patrol_overrides = {
        patrol_chance = 1
    },
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    2,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hard = {
                {
                    {
                        2,
                        3
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            harder = {
                {
                    {
                        5,
                        6
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hardest = {
                {
                    {
                        12,
                        14
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm = {
                {
                    {
                        12,
                        14
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm_2 = {
                {
                    {
                        12,
                        14
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm_3 = {
                {
                    {
                        12,
                        14
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    0,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hard = {
                {
                    {
                        0,
                        1
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            harder = {
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hardest = {
                {
                    {
                        4,
                        6
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm = {
                {
                    {
                        4,
                        6
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm_2 = {
                {
                    {
                        4,
                        6
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm_3 = {
                {
                    {
                        4,
                        6
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            }
        }
    }
}
BreedPacks.shield_rats = {
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_with_shield
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_with_shield,
            Breeds.skaven_storm_vermin_commander
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_with_shield,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_with_shield,
            Breeds.skaven_storm_vermin_with_shield,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_dummy_slave,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_dummy_slave,
            Breeds.skaven_storm_vermin_with_shield,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_dummy_slave,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_with_shield,
            Breeds.skaven_storm_vermin_with_shield,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield,
            Breeds.skaven_clan_rat_with_shield
        }
    },
    roof_spawning_allowed = true,
    patrol_overrides = {
        patrol_chance = 1
    },
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    {
                        2,
                        3
                    },
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        0,
                        1
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hard = {
                {
                    {
                        6,
                        8
                    },
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            harder = {
                {
                    {
                        10,
                        15
                    },
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        2,
                        3
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        3,
                        4
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hardest = {
                {
                    100,
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        4,
                        5
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        5,
                        7
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm = {
                {
                    100,
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        4,
                        5
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        5,
                        7
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm_2 = {
                {
                    100,
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        4,
                        5
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        5,
                        7
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm_3 = {
                {
                    100,
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        4,
                        5
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        5,
                        7
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    {
                        0,
                        1
                    },
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    0,
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    0,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hard = {
                {
                    {
                        0,
                        4
                    },
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    0,
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        0,
                        1
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            harder = {
                {
                    {
                        0,
                        6
                    },
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        0,
                        1
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        0,
                        1
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hardest = {
                {
                    100,
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm = {
                {
                    100,
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm_2 = {
                {
                    100,
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            cataclysm_3 = {
                {
                    100,
                    "skaven_clan_rat_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_with_shield",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        1,
                        2
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            }
        }
    }
}
BreedPacks.plague_monks = {
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk,
            Breeds.skaven_plague_monk,
            Breeds.skaven_storm_vermin_commander,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat,
            Breeds.skaven_clan_rat
        }
    },
    roof_spawning_allowed = true,
    patrol_overrides = {
        patrol_chance = 1
    },
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    2,
                    "skaven_plague_monk",
                    Breeds.skaven_clan_rat
                },
                {
                    1,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hard = {
                {
                    {
                        4,
                        6
                    },
                    "skaven_plague_monk",
                    Breeds.skaven_clan_rat
                },
                {
                    2,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            harder = {
                {
                    {
                        5,
                        8
                    },
                    "skaven_plague_monk",
                    Breeds.skaven_clan_rat
                },
                {
                    3,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hardest_bajs = {
                {
                    {
                        6,
                        7
                    },
                    "skaven_plague_monk",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        6,
                        7
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    {
                        0,
                        1
                    },
                    "skaven_plague_monk",
                    Breeds.skaven_clan_rat
                },
                {
                    0,
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hard = {
                {
                    {
                        0,
                        3
                    },
                    "skaven_plague_monk",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        0,
                        1
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            harder = {
                {
                    {
                        2,
                        3
                    },
                    "skaven_plague_monk",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        0,
                        1
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            },
            hardest_bajs = {
                {
                    {
                        3,
                        4
                    },
                    "skaven_plague_monk",
                    Breeds.skaven_clan_rat
                },
                {
                    {
                        2,
                        3
                    },
                    "skaven_storm_vermin_commander",
                    Breeds.skaven_clan_rat
                }
            }
        }
    }
}
BreedPacks.marauders_shields = {
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.chaos_marauder_with_shield
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_marauder_with_shield
        }
    },
    {
        spawn_weight = LIGHT_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder_with_shield
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder_with_shield,
            Breeds.skaven_dummy_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_raider,
            Breeds.chaos_marauder_with_shield
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder_with_shield,
            Breeds.skaven_dummy_clan_rat,
            Breeds.skaven_dummy_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_raider,
            Breeds.chaos_marauder_with_shield,
            Breeds.skaven_dummy_clan_rat
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_marauder_with_shield,
            Breeds.skaven_dummy_clan_rat,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_raider,
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = MEDIUM_WEIGHT,
        members = {
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_marauder_with_shield,
            Breeds.skaven_dummy_clan_rat,
            Breeds.skaven_dummy_clan_rat,
            Breeds.chaos_fanatic,
            Breeds.chaos_fanatic
        }
    },
    {
        spawn_weight = HEAVY_WEIGHT,
        members = {
            Breeds.chaos_raider,
            Breeds.chaos_raider,
            Breeds.chaos_raider,
            Breeds.chaos_marauder_with_shield,
            Breeds.chaos_marauder_with_shield,
            Breeds.skaven_dummy_clan_rat,
            Breeds.skaven_dummy_clan_rat,
            Breeds.chaos_fanatic
        }
    },
    roof_spawning_allowed = false,
    patrol_overrides = {
        patrol_chance = 1
    },
    zone_checks = {
        clamp_breeds_hi = {
            normal = {
                {
                    {
                        4,
                        6
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    1,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hard = {
                {
                    {
                        6,
                        8
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        2,
                        3
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            harder = {
                {
                    {
                        8,
                        12
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        3,
                        4
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hardest = {
                {
                    {
                        8,
                        10
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        7,
                        9
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm = {
                {
                    {
                        8,
                        10
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        7,
                        9
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_2 = {
                {
                    {
                        8,
                        10
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        7,
                        9
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_3 = {
                {
                    {
                        8,
                        10
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        7,
                        9
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            }
        },
        clamp_breeds_low = {
            normal = {
                {
                    {
                        2,
                        3
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    0,
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hard = {
                {
                    {
                        3,
                        5
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        0,
                        1
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            harder = {
                {
                    {
                        4,
                        6
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        1,
                        2
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            hardest = {
                {
                    {
                        8,
                        12
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        3,
                        4
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm = {
                {
                    {
                        8,
                        12
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        3,
                        4
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_2 = {
                {
                    {
                        8,
                        12
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        3,
                        4
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            },
            cataclysm_3 = {
                {
                    {
                        8,
                        12
                    },
                    "chaos_marauder_with_shield",
                    Breeds.chaos_marauder
                },
                {
                    {
                        3,
                        4
                    },
                    "chaos_raider",
                    Breeds.chaos_marauder
                }
            }
        }
    }
}




