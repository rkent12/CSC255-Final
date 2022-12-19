player = {}

player.animationsInfo = {}
player.animationsInfo["Running"] = 17
player.animationsInfo["Run Throwing"] = 17
player.animationsInfo["Run Slashing"] = 17
player.animationsInfo["Run Firing"] = 17
player.animationsInfo["Jump Start"] = 5
player.animationsInfo["Jump Loop"] = 5
player.animationsInfo["Hurt"] = 11
player.animationsInfo["Happy"] = 11
player.animationsInfo["Firing"] = 8
player.animationsInfo["Falling Down"] = 5
player.animationsInfo["Dying"] = 14
player.animationsInfo["Climbing"] = 11
player.animationsInfo["Idle"] = 11
player.animationsInfo["Idle Blinking"] = 11
player.animationsInfo["Slashing"] = 11
player.animationsInfo["Sliding"] = 5
player.animationsInfo["Throwing"] = 11

function player.makeAnimation(duration, fps, images)
    local ani = {}
    ani.images = images

    -- for i=0,8 do
    --     table.insert(ani.images, love.graphics.newImage("explosion_frames-" .. i .. ".png"))
    -- end

    ani.duration = duration
    ani.fps = fps

    ani.index = 1
    ani.scale = 0.3
    ani.flipScale = -0.3

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
    function ani.draw(x, y, rot, scaleX, scaleY)
        love.graphics.draw(
            ani.images[ani.index],
            x, y, 0,
            -- scale, ani.scale / scale
            scaleX , scaleY,
            ani.images[ani.index]:getWidth()/2,
            ani.images[ani.index]:getHeight()/2)
    end

    return ani
end

function player.loadMonkeyAnimations(framesInfo)
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
        anis[dir] = player.makeAnimation(1, 30, images)
    end
    return anis
end

function player.makePhysicsObjectPlayer(name, x, y, w, h, bodyType, color)
    local player = {}
    player.body = love.physics.newBody(world, x, y, bodyType)
    player.body:setFixedRotation(true)
    player.color = color

    player.shape = love.physics.newRectangleShape(0,0,w,h)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setCategory(1)
    player.grounded = true

    player.name = name
    player.score = 0
    player.scaleX = 0.3
    player.scaleY = 0.3

    player.fixture:setUserData(player)

    function player.update()
        speed = player.body:getLinearVelocity()
        if player.grounded then
            if love.keyboard.isDown("up") then
                player.aniKey = 11
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
            elseif love.keyboard.isDown("left") and love.keyboard.isDown("f")then
                player.aniKey = 12
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
                player.scaleX = -0.3
            elseif love.keyboard.isDown("left") and love.keyboard.isDown("e")then
                player.aniKey = 13
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
                player.scaleX = -0.3
            elseif love.keyboard.isDown("right") and love.keyboard.isDown("f")then
                player.aniKey = 12
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
                player.scaleX = 0.3
            elseif love.keyboard.isDown("right") and love.keyboard.isDown("e")then
                player.aniKey = 13
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
                player.scaleX = 0.3
            elseif love.keyboard.isDown("left") then
                player.aniKey = 15
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
                player.scaleX = -0.3
            elseif love.keyboard.isDown("right") then
                player.aniKey = 15
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
                player.scaleX = 0.3
            elseif love.keyboard.isDown("f") then
                player.aniKey = 5
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
            elseif love.keyboard.isDown("e") then
                player.aniKey = 16
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
            else
                player.aniKey = 8
                player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
            end
        else
            player.aniKey = 10
            player.currentAni = monkeyAnis[animationKeys[player.aniKey]]
        end
    end

    function player.draw()
        if(player.currentAni ~= nil) then
            -- draw the image
            love.graphics.setColor({1,0,1,0.4})
            love.graphics.polygon("fill", 
                player.body:getWorldPoints(
                    player.shape:getPoints())) 
            love.graphics.setColor(1,1,1)
            local x = player.body:getX()
            local y = player.body:getY()
            local rot = player.body:getAngle()

            player.currentAni.draw(x, y, rot, player.scaleX, player.scaleY)

            -- love.graphics.draw(player.image, x, y, rot,
            --     w/player.image:getWidth(),
            --     h/player.image:getHeight())

        else             
            love.graphics.setColor(player.color)
            love.graphics.polygon("fill",
                player.body:getWorldPoints(
                    player.shape:getPoints())) 
        end
    end

    return player
end

