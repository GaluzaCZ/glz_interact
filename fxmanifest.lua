fx_version 'cerulean'
game 'gta5'

name "glz_interact"
description "Script that interact with entities and have many actions with them"
author "GalužaCZ#8828"
version "1.0"

lua54 'yes'

shared_scripts {
	'config.lua',
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'shared/*.lua',
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}

dependencies {
	'es_extended',
	'ox_target',
	'ox_inventory'
}