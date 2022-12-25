resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'CEBA_HUD'

ui_page 'html/ui.html'

client_scripts {
	'client.lua'
}

-- server_scripts {
-- 	'server.lua'
-- }

files {
	'html/ui.html',
	'html/pixa.png',
	'html/style.css',
	'html/grid.css',
	'html/main.js',
	'html/img/speaker1.png',
	'html/img/speaker2.png',
	'html/img/speaker3.png',
	'html/img/underwater.png',
	'html/img/car.png',
	'html/img/fuel.png',
	'html/img/locked.png',
	'html/img/unlocked.png',
	'html/img/onoff.png',
	'html/img/kamza.png',
	'html/HarmoniaSansProCyr-Bold.ttf',
	'html/HarmoniaSansProCyr-Light.ttf',
	'html/HarmoniaSansProCyr-Regular.ttf'
}

exports {
	'TurnRadar'
}