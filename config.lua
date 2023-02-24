Config = {}

Config.Locale = GetConvar('esx:locale', GetConvar('qb_locale', GetConvar('ox:locale', 'en')))

Config.HandsUp = {
    Enable = true,
    DefaultKey = 'X',
    Command = 'glz:handsup'
}

Config.Carry = {
    Enable = true,
    Command = 'carry'
}

Config.Shuff = {
    Enable = true,
    Command = 'shuff'
}

Config.ReviveTime = 10 * 1000 -- How long will takes to revive player in milliseconds

---@type table<string, { name: string, countMin: integer, countMax: integer, percentage: integer}[]>
Config.Loot = {
    Peds = {
        {'money', 20, 250, 95},
        {'phone', 1, 1, 60},
        {'weed', 1, 3, 2},
        {'bandage', 1, 2, 20},
        {'radio', 1, 1, 5},
    },
    Bins = {
        {'money', 1, 20, 40},
        {'weed', 1, 1, 2},
        {'lockpick', 1, 1, 2},
        {'burger', 1, 2, 60},
        {'cola', 1, 2, 60},
        {'water', 1, 2, 70},
        {'seed_weed', 1, 1, 2},
        {'coca_seed', 1, 1, 1},
    }
}

Config.Dumpsters = {`p_dumpster_t`, `prop_cs_dumpster_01a`, `prop_dumpster_01a`, `prop_dumpster_02a`, `prop_dumpster_02b`, `prop_dumpster_3a`, `prop_dumpster_4a`, `prop_dumpster_4b`, `bkr_prop_fakeid_binbag_01`, `hei_heist_kit_bin_01`, `hei_prop_heist_binbag`, `ng_proc_binbag_01a`, `ng_proc_binbag_02a`, `p_binbag_01_s`, `p_rub_binbag_test`, `prop_bin_01a`, `prop_bin_02a`, `prop_bin_03a`, `prop_bin_04a`, `prop_bin_05a`, `prop_bin_06a`, `prop_bin_07a`, `prop_bin_07b`, `prop_bin_07c`, `prop_bin_07d`, `prop_bin_08a`, `prop_bin_08open`, `prop_bin_09a`, `prop_bin_10a`, `prop_bin_10b`, `prop_bin_11a`, `prop_bin_11b`, `prop_bin_12a`, `prop_bin_13a`, `prop_bin_14a`, `prop_bin_14b`} -- I am too lazy to add all bins, here is list where i searched https://gta-objects.xyz/objects/search?text=bin