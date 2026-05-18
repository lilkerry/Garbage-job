fx_version 'cerulean'
game 'gta5'

author 'KERRYGAMER'
description 'Garbage Job for QBX/QBCore'
version '1.0.0'

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/utils.lua',
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'qbx_core'
}

exports {
    'startGarbageJob',
    'stopGarbageJob',
    'isJobActive'
}
