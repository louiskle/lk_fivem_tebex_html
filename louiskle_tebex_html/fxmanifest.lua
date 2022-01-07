fx_version('bodacious')
game('gta5')

server_scripts({
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'config.lua'
})

--client_script('@korioz/lib.lua')
client_scripts({
	'client/main.lua',
	'config.lua'
})

ui_page('html/ui.html')

files({
	'html/ui.html',
	'html/css/app.css',
	'html/js/app.js',
	'html/fonts/*',
	'html/img/*',
	'html/img/arme/*',
	'html/img/vehicle/*',
})

dependency('es_extended')
