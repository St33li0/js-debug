fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'JS-Debug'
version '0.1.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'shared/functions.lua',
}

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

export {
    'TriggerDebug',
    'Timer',
}
server_export {
    'TriggerDebug',
    'Timer',
}