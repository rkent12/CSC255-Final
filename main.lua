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
    love.window.setFullscreen(true,"desktop")
    W = love.graphics.getWidth()
    H = love.graphics.getHeight()
    GameState = 1

    require("modules/physics_helper")
    require("modules/player")
    require("modules/weapon")

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81*64, true)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    backgroundImg = love.graphics.newImage("assets/monkey/extra/Background.png")
    -- Background Image From - https://s4m-ur4i.itch.io/pixelart-clouds-background

    monkeyAnis = player.loadMonkeyAnimations(animationsInfo)
    -- Monkey Animations From - 
    aniNum = 8

    ground = physics_helper.makePhysicsObjectRect("ground", W/2, H-10, W*2, 20, "static", {0.2, 0.3, 0.2})
    platform1 = physics_helper.makePhysicsObjectRect("platform1", 750, H-175, W/6, 50, "static", {0.8, 0.9, 0.8})
    platform2 = physics_helper.makePhysicsObjectRect("platform2", 200, H-325, W/6, 50, "static", {0.8, 0.9, 0.8})
    platform3 = physics_helper.makePhysicsObjectRect("platform3", W-750, H-175, W/6, 50, "static", {0.8, 0.9, 0.8})
    platform4 = physics_helper.makePhysicsObjectRect("platform4", W-200, H-325, W/6, 50, "static", {0.8, 0.9, 0.8})
    platform5 = physics_helper.makePhysicsObjectRect("platform5", 1280, H-475, 1250, 50, "static", {0.8, 0.9, 0.8})

    player1 = player.makePhysicsObjectPlayer("player", W/2, H-30, 50, 80, "dynamic", {0.76, 0.18, 0.05})
    player2 = player.makePhysicsObjectPlayer("player2", W/5, H-30, 50, 80, "dynamic", {0.5, 0.5, 0})

    player1.currentAni = monkeyAnis[animationKeys[aniNum]]
    player2.currentAni = monkeyAnis[animationKeys[aniNum]]

    weapon1 = weapon.makePhysicsObejectWeapon("gun", W/2-20, H-30, 40, 20, "dynamic", {0.5, 0, 0.5})
    joint = love.physics.newWeldJoint(player1.body, weapon1.body, W/2, H-30, false)

    projectile_list = {}
    locked = false
    shootTimer = 0

end

function love.mousepressed(mouse_x, mouse_y)
    if((mouse_x>W/2-62.5 and mouse_x<W/2+62.5) and (mouse_y>H/2-40 and mouse_y<H/2+40))then
        changeState(2)
    end
end

function changeState(state)
    GameState = state
  end

function love.update(dt)
    -- dx = 0
    -- dy = 0
    world:update(dt)

    mouse_x = love.mouse.getX()
    mouse_y = love.mouse.getY()

    -- monkeyAnis[animationKeys[current_index]].update(dt)
    -- player1.currentAni = monkeyAnis[animationKeys[aniKey]]

    if (GameState == 1)then
        -- print("Loading Game")
    elseif (GameState == 2)then
        -- print("Starting Game")
        player1.currentAni.update(dt)
        player2.currentAni.update(dt)

        if love.keyboard.isDown("right") then
            player1.update()
            player1.body:applyForce(275, 0)
            player1.body:setLinearDamping(0.2)
        elseif love.keyboard.isDown("left") then
            player1.update()
            player1.body:applyForce(-275, 0)
            player1.body:setLinearDamping(0.15)
        end
        if love.keyboard.isDown("up") then
            if(player1.grounded) then
                player1.update()
                local x, y = player1.body:getLinearVelocity()
                player1.body:setLinearVelocity(x, -500)
            end
        end
        if love.keyboard.isDown("escape") then
            love.event.quit(true)
        end
        if love.keyboard.isDown("f")then
            if not locked then
                player1.update()
                locked = true
                shootTimer = 0
                projectile = weapon.makePhysicsObjectProjectile("projectile", weapon1.body:getX()-15, weapon1.body:getY(), 5, 5)
                projectile.body:applyLinearImpulse(-35,-2)
                table.insert(projectile_list, projectile)
            end
        elseif locked then
            shootTimer = shootTimer + dt
            if shootTimer > 0.25 then
                locked = false
            end
        end
    elseif (GameState == 3) then

    end
end

function love.draw()
    if (GameState == 1) then
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.draw(backgroundImg, 0, 0, 0, 7, 4.3)
        love.graphics.setColor(0.5, 0, 0.5)
        love.graphics.printf("MONKEY GAME", W/2-300, H/2-70, 600, "center")

        love.graphics.setColor(0.5, 0, 0.5)
        startBtn = love.graphics.rectangle("fill", W/2-62.5, H/2-40, 125, 40, 8)
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.printf("Start Game", W/2-60, H/2-30, 125,"center")
    elseif (GameState == 2) then
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.draw(backgroundImg, 0, 0, 0, 7, 4.3)

        ground.draw()
        platform1.draw()
        platform2.draw()
        platform3.draw()
        platform4.draw()
        platform5.draw()
        player1.draw()
        player2.draw()
        weapon1.draw()

        if(projectile_list~=nil) then
            for i, projectile in pairs(projectile_list)do
                projectile.draw()
            end
        end

        -- monkeyAnis[animationKeys[current_index]].draw()
        -- love.graphics.print(animationKeys[current_index], 100, 100)
    elseif (GameState == 3) then

    end

end
