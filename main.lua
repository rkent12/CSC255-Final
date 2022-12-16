function makeAnimation(duration, fps, images)
    local ani = {}
    ani.images = images

    -- for i=0,8 do
    --     table.insert(ani.images, love.graphics.newImage("explosion_frames-" .. i .. ".png"))
    -- end

    ani.duration = duration
    ani.fps = fps

    ani.index = 1
    ani.scale = 0.7

    ani.time = ani.duration / ani.fps

    function ani.update(dt)
        ani.time = ani.time - dt
    
        if(ani.time <= 0) then
            ani.time = ani.duration / ani.fps
            ani.index = ani.index + ani.duration

            if(ani.index > #ani.images) then
                -- loop the animation
                ani.index = 1
            --     tmp_anim.x = math.random(0,W)
            --     tmp_anim.y = math.random(0,H)
            --     tmp_anim.scale = math.random(1,5)
            end
        end
    end
    function ani.draw()
        love.graphics.draw(
            ani.images[ani.index], 
            50, 50, 0,
            ani.scale, ani.scale)
    end

    return ani
end
-- =================================================================================================================================
function loadMonkeyAnimations(framesInfo)
    local anis = {}
    for dir, numFrames in pairs(framesInfo) do
        local images = {}
        for i=0, numFrames do -- For each frame in each directory
            local index = ""
            for j=0, 2-#tostring(i) do -- For adding leading 0's 
                index = index .. "0"
            end
            index = index .. i
            path = "assets/monkey/animations/" .. dir .. "/" .. dir .. "_" .. index .. ".png"
            table.insert(images, love.graphics.newImage(path)) -- Loads all images into images table
        end
        anis[dir] = makeAnimation(1, 30, images)
    end
    return anis
end

function love.keypressed(key)
    if key == "a" then
        current_index = current_index - 1
    elseif key == "d" then
        current_index = current_index + 1
    end
end
animationKeys = {
    "Throwing",
    "Climbing",
    "Dying",
    "Falling Down",
    "Firing",
    "Happy",
    "Hurt",
    "Idle",
    "Idle Blinking",
    "Jump Loop",
    "Jump Start",
    "Run Firing",
    "Run Slashing",
    "Run Throwing",
    "Running",
    "Slashing",
    "Sliding"
}

animationsInfo = {}
animationsInfo["Running"] = 17
animationsInfo["Run Throwing"] = 17
animationsInfo["Run Slashing"] = 17
animationsInfo["Run Firing"] = 17
animationsInfo["Jump Start"] = 5
animationsInfo["Jump Loop"] = 5
animationsInfo["Hurt"] = 11
animationsInfo["Happy"] = 11
animationsInfo["Firing"] = 8
animationsInfo["Falling Down"] = 5
animationsInfo["Dying"] = 14
animationsInfo["Climbing"] = 11
animationsInfo["Idle"] = 11
animationsInfo["Idle Blinking"] = 11
animationsInfo["Slashing"] = 11
animationsInfo["Sliding"] = 5
animationsInfo["Throwing"] = 11
current_index = 1
aniKey = "Idle"
speed = 100

function love.load()
    love.window.setMode(650, 650) -- set the window dimensions to 650 by 650
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()

    require("helpers/physics_helper")
    
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81*64, true)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    monkeyAnis = loadMonkeyAnimations(animationsInfo)

    ground = physics_helper.makePhysicsObjectRect("ground", W/2, H-10, W, 20, "static", {0.2, 0.9, 0.2})

    player =  physics_helper.makePhysicsObjectPlayer("player", W/2, H-30, 50, 50, "dynamic", {0.76, 0.18, 0.05})
    -- player.image = monkeyAnis[animationKeys[current_index]]

    weapon1 = physics_helper.makePhysicsObejectWeapon("gun", W/2-20, H-30, 40, 20, "dynamic", {0.5, 0, 0.5})
    joint = love.physics.newWeldJoint(player.body, weapon1.body, W/2, H-30, false)

    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

    projectile_list = {}
    i = 1

end

function love.update(dt)
    -- dx = 0
    -- dy = 0
    world:update(dt)

    monkeyAnis[animationKeys[current_index]].update(dt)

    if love.keyboard.isDown("right") then
        player.body:applyForce(200, 0)
    elseif love.keyboard.isDown("left") then
        player.body:applyForce(-200, 0)
    end
    if love.keyboard.isDown("up") then
        if(player.grounded) then    
            local x, y = player.body:getLinearVelocity()
            player.body:setLinearVelocity(x, -400)
        end
    end
    if love.keyboard.isDown("f") then
        projectile_list[i] = physics_helper.makePhysicsObjectProjectile(weapon1.body:getX(), weapon1.body:getY(), 20, 5)
        i = i + 1
    end 
    -- if(player.x == 0 and player.y == 0)then
    --     aniKey = "Idle"
    -- else 
    --     aniKey = "Running"
    -- end
end

function love.draw()

    ground.draw()
    player.draw()
    weapon1.draw()

    if(project_list~=nil) then
        for n=1, #project_list do
            project_list[n].draw()
        end
    end 

    -- monkeyAnis[animationKeys[current_index]].draw()
    -- love.graphics.print(animationKeys[current_index], 100, 100)
end