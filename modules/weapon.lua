weapon = {}

function weapon.makePhysicsObejectWeapon(name, x, y, w, h, bodyType, color)
    local new_phys_obj = {}
    new_phys_obj.body = love.physics.newBody(world, x, y, bodyType)
    new_phys_obj.color = color
    new_phys_obj.shape = love.physics.newRectangleShape(0, 0, w, h)
    new_phys_obj.fixture = love.physics.newFixture(new_phys_obj.body, new_phys_obj.shape)
    new_phys_obj.name = name 
    new_phys_obj.fixture:setUserData(new_phys_obj)

    function new_phys_obj.draw()
        if(new_phys_obj.image ~= nil) then
            -- draw the image
            love.graphics.setColor({1,0,1,0.4})
            love.graphics.polygon("fill", 
                new_phys_obj.body:getWorldPoints(
                    new_phys_obj.shape:getPoints())) 
            love.graphics.setColor(1,1,1)
            local x = new_phys_obj.body:getX()
            local y = new_phys_obj.body:getY()
            local rot = new_phys_obj.body:getAngle()

            love.graphics.draw(new_phys_obj.image, x, y, rot,
                w/new_phys_obj.image:getWidth(), 
                h/new_phys_obj.image:getHeight(),
                new_phys_obj.image:getWidth()/2,
                new_phys_obj.image:getHeight()/2)

        else             
            love.graphics.setColor(new_phys_obj.color)
            love.graphics.polygon("fill", 
                new_phys_obj.body:getWorldPoints(
                    new_phys_obj.shape:getPoints())) 
        end
    end
    return new_phys_obj
end

function weapon.makePhysicsObjectProjectile(x, y, r, duration) 
    local new_phys_obj = {}
    new_phys_obj.body = love.physics.newBody(world, x, y, "dynamic")
    new_phys_obj.shape = love.physics.newCircleShape(0, 0, r)
    new_phys_obj.fixture = love.physics.newFixture(new_phys_obj.body, new_phys_obj.shape)
    new_phys_obj.fixture:setUserData(new_phys_obj)
    new_phys_obj.fixture:setMask(1)

    function new_phys_obj.draw()
        love.graphics.setColor(1.0, 1.0, 1.0)
        print("Runnin")
        love.graphics.circle("fill", 
            new_phys_obj.body:getX(), 
            new_phys_obj.body:getY(), 
            r)
    end
    return new_phys_obj
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