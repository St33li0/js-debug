fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'JS-Debug'
version '0.1.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'shared/functions.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'config.lua'
}

server_scripts {
    'server/server.lua',
    'config.lua'
}

export 'TriggerDebug'
server_export 'TriggerDebug'