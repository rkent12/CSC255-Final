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
    wallLeft = physics_helper.makePhysicsObjectRect("wallLeft", 0, H/2, 1, H, "static", {0, 0, 0})
    wallRight = physics_helper.makePhysicsObjectRect("wallRight", W-1, H/2, 1, H+100, "static", {0, 0, 0})

    backgroundImg = love.graphics.newImage("assets/monkey/extra/Background.png")
    -- Background Image From - https://s4m-ur4i.itch.io/pixelart-clouds-background

    platformImg = love.graphics.newImage("assets/monkey/extra/Platform.png")
    -- Platform Image From - https://opengameart.org/content/dirt-platform

    monkeyAnis = player.loadMonkeyAnimations(animationsInfo)
    -- Monkey Animations From - https://cartoonsmart.com/super-monkey-royalty-free-game-art/

    theme = love.audio.newSource("assets/monkey/sounds/awesomeness.wav", "static")
    laser = love.audio.newSource("assets/monkey/sounds/laser.wav", "static")
    sword = love.audio.newSource("assets/monkey/sounds/sword.wav", "static")

    aniNum = 8

    ground = physics_helper.makePhysicsObjectRect("ground", W/2, H-10, W*2, 20, "static", {0.2, 0.3, 0.2})

    platform1 = physics_helper.makePhysicsObjectRect("platform1", 750, H-175, W/6, 50, "static", {0.8, 0.9, 0.8}, platformImg)
    platform2 = physics_helper.makePhysicsObjectRect("platform2", 200, H-325, W/6, 50, "static", {0.8, 0.9, 0.8}, platformImg)
    platform3 = physics_helper.makePhysicsObjectRect("platform3", W-750, H-175, W/6, 50, "static", {0.8, 0.9, 0.8}, platformImg)
    platform4 = physics_helper.makePhysicsObjectRect("platform4", W-200, H-325, W/6, 50, "static", {0.8, 0.9, 0.8}, platformImg)
    platform5 = physics_helper.makePhysicsObjectRect("platform5", 1280, H-475, 1250, 50, "static", {0.8, 0.9, 0.8}, platformImg)

    player1 = player.makePhysicsObjectPlayer("player", W/2+900, H-30, 50, 80, "dynamic", -0.3, 0.3, {0.76, 0.18, 0.05})
    player2 = player.makePhysicsObjectPlayer("player2", W/2-900, H-30, 50, 80, "dynamic", 0.3, 0.3, {0.5, 0.5, 0})

    player1.currentAni = monkeyAnis[animationKeys[aniNum]]
    player2.currentAni = monkeyAnis[animationKeys[aniNum]]

    -- weapon1 = weapon.makePhysicsObejectWeapon("gun", W/2-20, H-30, 40, 20, "dynamic", {0.5, 0, 0.5})
    -- joint = love.physics.newWeldJoint(player1.body, weapon1.body, W/2, H-30, false)

    projectile_list = {}
    locked = false
    jumpLock = false
    shootTimer = 0
    musicTimer = 0

end

function love.mousepressed(mouse_x, mouse_y)
    if((mouse_x>W/2-62.5 and mouse_x<W/2+62.5) and (mouse_y>H/2-40 and mouse_y<H/2))then
        player1.health = 3
        player2.health = 3
        player1.body.setX(player1.body, W/2+900)
        player2.body.setX(player2.body, W/2-900)
        if(projectile_list~=nil) then
            for i, projectile in pairs(projectile_list)do
                table.remove(projectile_list, i)
            end
        end

        changeState(2)
    elseif((mouse_x>W/2-62.5 and mouse_x<W/2+62.5) and (mouse_y>H/2+15 and mouse_y<H/2+55))then
        love.event.quit(true)
    elseif((mouse_x>W/2-62.5 and mouse_x<W/2+62.5) and (mouse_y>H/2+70 and mouse_y<H/2+110)) then
        changeState(5)
    end
end

function changeState(state)
    GameState = state
  end

function love.update(dt)
    -- dx = 0
    -- dy = 0
    world:update(dt)

    love.audio.setVolume(0.12)
    love.audio.play(theme)

    mouse_x = love.mouse.getX()
    mouse_y = love.mouse.getY()

    if love.keyboard.isDown("escape") then
        love.event.quit(true)
    end


    -- monkeyAnis[animationKeys[current_index]].update(dt)
    -- player1.currentAni = monkeyAnis[animationKeys[aniKey]]

    if (GameState == 1)then
        -- print("Loading Game")
    elseif (GameState == 2)then
        -- print("Starting Game")
        player1.currentAni.update(dt)
        player2.currentAni.update(dt)

        
        if (player1.health < 1)then
            changeState(3)
        elseif (player2.health < 1)then
            changeState(4)
        end

        if love.keyboard.isDown("w") then
            if(player1.grounded) then
                player1.update()
                local x, y = player1.body:getLinearVelocity()
                player1.body:setLinearVelocity(x, -600)
            end

        elseif love.keyboard.isDown("d") and love.keyboard.isDown("f") then
            if not locked then
                player1.update()
                player1.body:applyForce(275, 0)
                player1.body:setLinearDamping(0.35)
                player1.update()
                locked = true
                shootTimer = 0
                projectile = weapon.makePhysicsObjectProjectile("projectile", player1.body:getX()+45, player1.body:getY()+15, 5, 5, #projectile_list + 1)
                projectile.body:applyLinearImpulse(35,-2)
                table.insert(projectile_list, projectile)
                love.audio.setVolume(0.3)
                love.audio.play(laser)
            end

        elseif love.keyboard.isDown("d") and love.keyboard.isDown("e") then
            player1.update()
            player1.body:applyForce(275, 0)
            player1.body:setLinearDamping(0.35)
            love.audio.setVolume(0.3)
            love.audio.play(sword)

        elseif love.keyboard.isDown("a") and love.keyboard.isDown("f") then
            if not locked then
                player1.update()
                player1.body:applyForce(-275, 0)
                player1.body:setLinearDamping(0.35)
                player1.update()
                locked = true
                shootTimer = 0
                projectile = weapon.makePhysicsObjectProjectile("projectile", player1.body:getX()-15, player1.body:getY()+15, 5, 5, #projectile_list + 1)
                projectile.body:applyLinearImpulse(-35,-2)
                table.insert(projectile_list, projectile)
                love.audio.setVolume(0.3)
                love.audio.play(laser)
            end

        elseif love.keyboard.isDown("a") and love.keyboard.isDown("e") then
            player1.update()
            player1.body:applyForce(-275, 0)
            player1.body:setLinearDamping(0.35)
            love.audio.setVolume(0.3)
            love.audio.play(sword)

        elseif love.keyboard.isDown("d")then
            player1.update()
            player1.body:applyForce(275, 0)
            player1.body:setLinearDamping(0.35)

        elseif love.keyboard.isDown("a") then
            player1.update()
            player1.body:applyForce(-275, 0)
            player1.body:setLinearDamping(0.35)

        elseif love.keyboard.isDown("f")then
            if not locked then
                if(player1.scaleX == -0.3)then
                    player1.update()
                    locked = true
                    shootTimer = 0
                    projectile = weapon.makePhysicsObjectProjectile("projectile", player1.body:getX()-40, player1.body:getY()+15, 5, 5, #projectile_list + 1)
                    projectile.body:applyLinearImpulse(-35, -2)
                    table.insert(projectile_list, projectile)
                    love.audio.setVolume(0.3)
                    love.audio.play(laser)
                elseif(player1.scaleX == 0.3)then
                    player1.update()
                    locked = true
                    shootTimer = 0
                    projectile = weapon.makePhysicsObjectProjectile("projectile", player1.body:getX()+40, player1.body:getY()+15, 5, 5, #projectile_list + 1)
                    projectile.body:applyLinearImpulse(35,-2)
                    table.insert(projectile_list, projectile)
                    love.audio.setVolume(0.3)
                    love.audio.play(laser)
                end
            end
        elseif locked then
            shootTimer = shootTimer + dt
            if shootTimer > 0.25 then
                locked = false
            end
            
        elseif love.keyboard.isDown("e")then
            player1.update()
            love.audio.setVolume(0.3)
            love.audio.play(sword)
        else
            player1.update()
        end

        if love.keyboard.isDown("u") then
            if(player2.grounded) then
                player2.update()
                local x, y = player2.body:getLinearVelocity()
                player2.body:setLinearVelocity(x, -600)
            end

        elseif love.keyboard.isDown("k") and love.keyboard.isDown("l") then
            if not locked then
                player2.update()
                player2.body:applyForce(275, 0)
                player2.body:setLinearDamping(0.2)
                player2.update()
                locked = true
                shootTimer = 0
                projectile = weapon.makePhysicsObjectProjectile("projectile", player2.body:getX()+45, player2.body:getY()+15, 5, 5, #projectile_list + 1)
                projectile.body:applyLinearImpulse(35,-2)
                table.insert(projectile_list, projectile)
                love.audio.setVolume(0.3)
                love.audio.play(laser)
            end

        elseif love.keyboard.isDown("k") and love.keyboard.isDown("i") then
            player2.update()
            player2.body:applyForce(275, 0)
            player2.body:setLinearDamping(0.2)
            love.audio.setVolume(0.3)
            love.audio.play(sword)

        elseif love.keyboard.isDown("h") and love.keyboard.isDown("l") then
            if not locked then
                player2.update()
                player2.body:applyForce(-275, 0)
                player2.body:setLinearDamping(0.2)
                player2.update()
                locked = true
                shootTimer = 0
                projectile = weapon.makePhysicsObjectProjectile("projectile", player2.body:getX()-15, player2.body:getY()+15, 5, 5, #projectile_list + 1)
                projectile.body:applyLinearImpulse(-35,-2)
                table.insert(projectile_list, projectile)
                love.audio.setVolume(0.3)
                love.audio.play(laser)
            end

        elseif love.keyboard.isDown("h") and love.keyboard.isDown("i") then
            player2.update()
            player2.body:applyForce(-275, 0)
            player2.body:setLinearDamping(0.2)
            love.audio.setVolume(0.3)
            love.audio.play(sword)

        elseif love.keyboard.isDown("k")then
            player2.update()
            player2.body:applyForce(275, 0)
            player2.body:setLinearDamping(0.2)

        elseif love.keyboard.isDown("h") then
            player2.update()
            player2.body:applyForce(-275, 0)
            player2.body:setLinearDamping(0.2)

        elseif love.keyboard.isDown("l")then
            if not locked then
                if(player2.scaleX == -0.3)then
                    player2.update()
                    locked = true
                    shootTimer = 0
                    projectile = weapon.makePhysicsObjectProjectile("projectile", player2.body:getX()-40, player2.body:getY()+15, 5, 5, #projectile_list + 1)
                    projectile.body:applyLinearImpulse(-35, -2)
                    table.insert(projectile_list, projectile)
                    love.audio.setVolume(0.3)
                    love.audio.play(laser)
                elseif(player2.scaleX == 0.3)then
                    player2.update()
                    locked = true
                    shootTimer = 0
                    projectile = weapon.makePhysicsObjectProjectile("projectile", player2.body:getX()+40, player2.body:getY()+15, 5, 5, #projectile_list + 1)
                    projectile.body:applyLinearImpulse(35,-2)
                    table.insert(projectile_list, projectile)
                    love.audio.setVolume(0.3)
                    love.audio.play(laser)
                end
            end
        elseif locked then
            shootTimer = shootTimer + dt
            if shootTimer > 0.25 then
                locked = false
            end
            
        elseif love.keyboard.isDown("i")then
            player2.update()
            love.audio.setVolume(0.3)
            love.audio.play(sword)
        else
            player2.update()
        end

    elseif (GameState == 3) then
        print ("Player 2 Win")
    elseif (GameState == 4) then
        print ("Player 1 Win")
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
        quitBtn = love.graphics.rectangle("fill", W/2-62.5, H/2+15, 125, 40, 8)
        instructBtn = love.graphics.rectangle("fill", W/2-62.5, H/2+70, 125, 40, 8)
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.printf("Start Game", W/2-60, H/2-30, 125,"center")
        love.graphics.printf("Quit", W/2-50, H/2+25, 100, "center")
        love.graphics.printf("Instructions", W/2-50, H/2 + 80, 100, "center")


    elseif (GameState == 2) then
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.draw(backgroundImg, 0, 0, 0, 7, 4.3)

        ground.draw()
        wallLeft.draw()
        wallRight.draw()
        platform1.draw()
        platform2.draw()
        platform3.draw()
        platform4.draw()
        platform5.draw()
        player1.draw()
        player2.draw()
        -- weapon1.draw()

        if(projectile_list~=nil) then
            for i, projectile in pairs(projectile_list)do
                if(player1.scaleX == 0.3)then
                    projectile.draw("left")
                elseif(player1.scaleX == -0.3)then
                    projectile.draw("right")
                end
            end
        end

    elseif (GameState == 3) then
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.draw(backgroundImg, 0, 0, 0, 7, 4.3)
        love.graphics.setColor(0.5, 0, 0.5)
        love.graphics.printf("Player 2 is the Winner!", W/2 - 100, H/2-135, 200, "center")
        love.graphics.printf("Thanks For Playing Monkey Game", W/2 - 100, H/2-107, 200, "center")
        love.graphics.printf("By Ryan Kent", W/2-300, H/2-70, 600, "center")
        startNewBtn = love.graphics.rectangle("fill", W/2-62.5, H/2-40, 125, 40, 8)
        quitBtn = love.graphics.rectangle("fill", W/2-62.5, H/2+15, 125, 40, 8)
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.printf("Start New Game", W/2-60, H/2-30, 125,"center")
        love.graphics.printf("Quit", W/2-50, H/2+25, 100, "center")

    elseif (GameState == 4) then
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.draw(backgroundImg, 0, 0, 0, 7, 4.3)
        love.graphics.setColor(0.5, 0, 0.5)
        love.graphics.printf("Player 1 is the Winner!", W/2 - 100, H/2-135, 200, "center")
        love.graphics.printf("Thanks For Playing Monkey Game", W/2 - 100, H/2-107, 200, "center")
        love.graphics.printf("By Ryan Kent", W/2-300, H/2-70, 600, "center")
        startNewBtn = love.graphics.rectangle("fill", W/2-62.5, H/2-40, 125, 40, 8)
        quitBtn = love.graphics.rectangle("fill", W/2-62.5, H/2+15, 125, 40, 8)
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.printf("Start New Game", W/2-60, H/2-30, 125,"center")
        love.graphics.printf("Quit", W/2-50, H/2+25, 100, "center")
    elseif (GameState == 5) then
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.draw(backgroundImg, 0, 0, 0, 7, 4.3)


        love.graphics.setColor(0.5, 0, 0.5)
        startNewBtn = love.graphics.rectangle("fill", W/2-62.5, H/2-40, 125, 40, 8)
        quitBtn = love.graphics.rectangle("fill", W/2-62.5, H/2+15, 125, 40, 8)
        love.graphics.printf("There are two players, player 1 can be controlled by WASD & EF, player 2 is UHJK and IL", W/2-130, H/2-232, 250, "center")
        love.graphics.printf("Players can shoot by using F or L, and swing the sword by holding E or I. Swinging the sword blocks bullets, bullets harm the other player", W/2-130, H/2-180, 250, "center")
        love.graphics.printf("Each player can be hit 3 times by bullets before they lose", W/2-75, H/2-110, 150, "center")

        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.printf("Start Game", W/2-60, H/2-30, 125,"center")
        love.graphics.printf("Quit", W/2-50, H/2+25, 100, "center")

    end
end
