local function log_available_science_packs()
    local available_science_packs = {}
    
    -- Get all available recipes that represent science packs
    for _, item in pairs(game.item_prototypes) do
        if item.subgroup.name == "science-pack" then
            table.insert(available_science_packs, item.name)
        end
    end
    
    -- Write to a file
    local log_file_content = table.concat(available_science_packs, "\n")
    game.write_file("available_science_packs.txt", log_file_content, false) -- overwrite the file
end

script.on_init(function()
    log_available_science_packs()
end)

local function log_science_consumption()
    local science_packs = {}

    -- Get the currently active research
    local current_research = game.forces.player.current_research
    if current_research then
        local all_packs_available = true

        -- Get the required science packs for the current research
        for _, ingredient in pairs(current_research.research_unit_ingredients) do
            science_packs[ingredient.name] = false
        end

        -- Check if the labs are consuming these science packs
        local labs = game.surfaces[1].find_entities_filtered{type="lab"}
        for _, lab in pairs(labs) do
            local inventory = lab.get_inventory(defines.inventory.lab_input)
            for i = 1, #inventory do
                local stack = inventory[i]
                if stack.valid_for_read and stack.count > 0 and science_packs[stack.name] ~= nil then
                    science_packs[stack.name] = true
                end
            end
        end

        -- Check if all required science packs are being consumed
        for _, is_consumed in pairs(science_packs) do
            if not is_consumed then
                all_packs_available = false
                break
            end
        end

        -- Write to the log file if all science packs are available and being consumed
        if all_packs_available then
            local log_file_content = ""
            for pack_name, is_consumed in pairs(science_packs) do
                if is_consumed then
                    log_file_content = log_file_content .. pack_name .. "\n"
                end
            end
            game.write_file("science_log.txt", log_file_content, false) -- false to overwrite the file
        else
            game.write_file("science_log.txt", "", false) -- Write an empty file if not all science packs are available
        end
    else
        game.write_file("science_log.txt", "", false) -- Write an empty file if no research is active
    end
end

script.on_event(defines.events.on_tick, function(event)
    if event.tick % 60 == 0 then -- log every second (60 ticks)
        log_science_consumption()
    end
end)

-- Clear the science log file upon closing the game
script.on_event(defines.events.on_game_created_from_scenario, function()
    game.write_file("science_log.txt", "", false)
end)
