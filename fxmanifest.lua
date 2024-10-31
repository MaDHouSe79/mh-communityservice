fx_version 'cerulean'
games { 'gta5' }

description 'QB Community Service'
version '1.0.0'


shared_scripts {
	'@qb-core/shared/locale.lua',
    'locales/en.lua', -- Change to the language you want
	'config.lua',
}

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
	'server/update.lua'
}
