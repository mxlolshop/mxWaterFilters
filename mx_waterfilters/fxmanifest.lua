fx_version 'cerulean'
game 'gta5'

description 'mxWaterFilters'
version '1.0'

shared_scripts { 
	"config.lua" 
}

server_scripts {
    'server/*'
}

client_scripts {
    'client/*'
}

lua54 'yes'

escrow_ignore {
	"config.lua",
	'client/*',
	'server/*',
}