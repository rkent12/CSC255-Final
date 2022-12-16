player = {}

function player.makePhysicsObjectPlayer(name, x, y, w, h, bodyType, color)
    local player = {}
    player.body = love.physics.newBody(world, x, y, bodyType)
    player.body:setFixedRotation(true)
    player.color = color

    player.shape = love.physics.newRectangleShape(0,0,w,h)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setCategory(1)
    player.grounded = false

    player.name = name

    player.fixture:setUserData(player)

    function player.draw()
        if(player.image ~= nil) then
            -- draw the image
            love.graphics.setColor({1,0,1,0.4})
            love.graphics.polygon("fill", 
                player.body:getWorldPoints(
                    player.shape:getPoints())) 
            love.graphics.setColor(1,1,1)
            local x = player.body:getX()
            local y = player.body:getY()
            local rot = player.body:getAngle()

            love.graphics.draw(player.image, x, y, rot,
                w/player.image:getWidth(), 
                h/player.image:getHeight(),
                player.image:getWidth()/2,
                player.image:getHeight()/2)

        else             
            love.graphics.setColor(player.color)
            love.graphics.polygon("fill", 
                player.body:getWorldPoints(
                    player.shape:getPoints())) 
        end
    end
    return player
end

function getTableIfNameMatches(name, a, b)
    if(a:getUserData().name == name) then 
        return a:getUserData()
    elseif(b:getUserData().name == name) then
        return b:getUserData()
    else
        return nil
    end
end

function beginContact(a, b, coll)
	-- a is a fixture
    -- b is a fixture
    local playerTable = getTableIfNameMatches("player", a, b)
    local groundTable = getTableIfNameMatches("ground", a, b)
    local weaponsTable = getTableIfNameMatches("weapon", a, b)

    if(playerTable~=nil and groundTable~=nil) then
        -- player is touching the ground
        playerTable.grounded = true
        playerTable.color = {0, 1, 0}
    end
    if(playerTable~=nil and weaponsTable~=nil) then
        if(love.keyboard.isDown("f")) then
            
        end
    end

    -- if(playerTable ~= nil) then 
    --     playerTable.color = {math.random(),math.random(),math.random()}
    -- end
end

function endContact(a, b, coll)
    local playerTable = getTableIfNameMatches("player", a, b)
    local groundTable = getTableIfNameMatches("ground", a, b)
    local weaponsTable = getTableIfNameMatches("weapon", a, b)

    if(playerTable~=nil and groundTable~=nil) then
        -- player is not touching this ground anymore
        playerTable.grounded = false
        playerTable.color = {1, 0, 1}
    end
    
end

function preSolve(a, b, coll)
	
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	
end
