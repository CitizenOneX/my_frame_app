local data = require('data.min')
local battery = require('battery.min')
local code = require('code.min')
local sprite = require('sprite.min')

-- Phone to Frame flags
ROCKET_SPRITE = 0x20
MOVE_MSG = 0x10

-- register the message parsers so they are automatically called when matching data comes in
data.parsers[ROCKET_SPRITE] = sprite.parse_sprite
data.parsers[MOVE_MSG] = code.parse_code


-- Main app loop
function app_loop()
	-- clear the display
	frame.display.text(" ", 1, 1)
	frame.display.show()
    local last_batt_update = 0

	while true do
		-- process any raw data items, if ready
		local items_ready = data.process_raw_items()

		-- one or more full messages received
		if items_ready > 0 then

			if (data.app_data[MOVE_MSG] ~= nil) then

				-- show the sprite
				local spr = data.app_data[ROCKET_SPRITE]
				frame.display.bitmap(math.random(1, 640-85), math.random(1, 400-150), spr.width, 2^spr.bpp, 0, spr.pixel_data)
				frame.display.show()

				data.app_data[MOVE_MSG] = nil
			end
		end

        -- periodic battery level updates, 120s for a camera app
        last_batt_update = battery.send_batt_if_elapsed(last_batt_update, 120)
		frame.sleep(0.1)
	end
end

-- run the main app loop
app_loop()