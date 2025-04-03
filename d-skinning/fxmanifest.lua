fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_scripts {
    '@rsg-core/shared/locale.lua',
    'config.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

dependencies {
    'rsg-core',
    'rsg-inventory',
    'ox_lib',
    'rsg-target',
}
exports {}

escrow_ignore {
    'config.lua',

  }


lua54 'yes'
