-- physics_helper
physics_helper = {}

function physics_helper.makePhysicsObjectRect(name, x, y, w, h, bodyType, color, image)
    local new_phys_obj = {}
    new_phys_obj.body = love.physics.newBody(world, x, y, bodyType)
    new_phys_obj.color = color
    new_phys_obj.name = name
    new_phys_obj.image = image

    new_phys_obj.shape = love.physics.newRectangleShape(0,0,w,h)
    new_phys_obj.fixture = love.physics.newFixture(new_phys_obj.body, new_phys_obj.shape)
    new_phys_obj.grounded = false

    new_phys_obj.fixture:setUserData(new_phys_obj)

    function new_phys_obj.draw()
        if(new_phys_obj.image ~= nil) then
            -- draw the image
            -- love.graphics.setColor({1,0,1,0.4})
            -- love.graphics.polygon("fill", 
            --     new_phys_obj.body:getWorldPoints(
            --         new_phys_obj.shape:getPoints())) 
            love.graphics.setColor(1,1,1)
            local x = new_phys_obj.body:getX()
            local y = new_phys_obj.body:getY()
            local rot = new_phys_obj.body:getAngle()

            love.graphics.draw(new_phys_obj.image, x, y, rot,
                w/new_phys_obj.image:getWidth(), 
                h/new_phys_obj.image:getHeight(),
                new_phys_obj.image:getWidth()/2,
                new_phys_obj.image:getHeight()/2 + 65)

        else             
            love.graphics.setColor(new_phys_obj.color)
            love.graphics.polygon("fill", 
                new_phys_obj.body:getWorldPoints(
                    new_phys_obj.shape:getPoints())) 
        end
    end
    return new_phys_obj
end

function physics_helper.makePhysicsObjectCircle(name, x, y, r, bodyType, color)
    local new_phys_obj = {}
    new_phys_obj.body = love.physics.newBody(world, x, y, bodyType)
    new_phys_obj.color = color
    new_phys_obj.shape = love.physics.newCircleShape(0,0,r)
    new_phys_obj.fixture = love.physics.newFixture(new_phys_obj.body, new_phys_obj.shape)
    new_phys_obj.name = name
    new_phys_obj.fixture:setUserData(new_phys_obj)

    new_phys_obj.grounded = false

    function new_phys_obj.draw()
        love.graphics.setColor(new_phys_obj.color)
        love.graphics.circle("fill",
            new_phys_obj.body:getX(),
            new_phys_obj.body:getY(),
            r
        )
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
    local groundTable = getTableIfNameMatches("ground", a, b)
    local wallLeftTable = getTableIfNameMatches("wallLeft", a, b)
    local wallRightTable = getTableIfNameMatches("wallRight", a, b)
    local playerTable = getTableIfNameMatches("player", a, b)
    local player2Table = getTableIfNameMatches("player2", a, b)
    local projectileTable = getTableIfNameMatches("projectile", a, b)
    local platform1Table = getTableIfNameMatches("platform1", a, b)
    local platform2Table = getTableIfNameMatches("platform2", a, b)
    local platform3Table = getTableIfNameMatches("platform3", a, b)
    local platform4Table = getTableIfNameMatches("platform4", a, b)
    local platform5Table = getTableIfNameMatches("platform5", a, b)


    if(playerTable~=nil) then
        -- player is not touching this ground anymore
        if (player2Table~=nil) then
            playerTable.grounded = true
            locked = false
        elseif (groundTable~=nil) then
            playerTable.grounded = true
            locked = false
        elseif (wallLeftTable~=nil) then
            playerTable.grounded = true
            locked = false
        elseif (wallRightTable~=nil) then
            playerTable.grounded = true
            locked = false
        elseif (platform1Table~=nil) then
            playerTable.grounded = true
            locked = false
        elseif (platform2Table~=nil) then
            playerTable.grounded = true
            locked = false
        elseif (platform3Table~=nil) then
            playerTable.grounded = true
            locked = false
        elseif (platform4Table~=nil) then
            playerTable.grounded = true
            locked = false
        elseif (platform5Table~=nil) then
            playerTable.grounded = true
            locked = false
        end
    end
    if(player2Table~=nil)then
        if (playerTable~=nil) then
            player2Table.grounded = true
            locked = false
        elseif (groundTable~=nil) then
            player2Table.grounded = true
            locked = false
        elseif (wallLeftTable~=nil) then
            player2Table.grounded = true
            locked = false
        elseif (wallRightTable~=nil) then
            player2Table.grounded = true
            locked = false
        elseif (platform1Table~=nil) then
            player2Table.grounded = true
            locked = false
        elseif (platform2Table~=nil) then
            player2Table.grounded = true
            locked = false
        elseif (platform3Table~=nil) then
            player2Table.grounded = true
            locked = false
        elseif (platform4Table~=nil) then
            player2Table.grounded = true
            locked = false
        elseif (platform5Table~=nil) then
            player2Table.grounded = true
            locked = false
        end
    end
    if(projectileTable~=nil)then
        if (player2Table~=nil) then
            table.remove(projectile_list, projectileTable.i)
        elseif (groundTable~=nil) then
            table.remove(projectile_list, projectileTable.i)
        elseif (wallLeftTable~=nil) then
            table.remove(projectile_list, projectileTable.i)
        elseif (wallRightTable~=nil) then
            table.remove(projectile_list, projectileTable.i)
        end
    end
    -- if(playerTable ~= nil) then 
    --     playerTable.color = {math.random(),math.random(),math.random()}
    -- end
end

function endContact(a, b, coll)
    local groundTable = getTableIfNameMatches("ground", a, b)
    local playerTable = getTableIfNameMatches("player", a, b)
    local player2Table = getTableIfNameMatches("player2", a, b)
    local projectileTable = getTableIfNameMatches("projectile", a, b)
    local weaponsTable = getTableIfNameMatches("weapon", a, b)
    local wallLeftTable = getTableIfNameMatches("wallLeft", a, b)
    local wallRightTable = getTableIfNameMatches("wallRight", a, b)
    local platform1Table = getTableIfNameMatches("platform1", a, b)
    local platform2Table = getTableIfNameMatches("platform2", a, b)
    local platform3Table = getTableIfNameMatches("platform3", a, b)
    local platform4Table = getTableIfNameMatches("platform4", a, b)
    local platform5Table = getTableIfNameMatches("platform5", a, b)

    if(playerTable~=nil) then
        -- player is not touching this ground anymore
        if (player2Table~=nil) then
            playerTable.grounded = false
            locked = true
        elseif (groundTable~=nil) then
            playerTable.grounded = false
            locked = true
        elseif (wallLeftTable~=nil) then
            playerTable.grounded = false
            locked = true
        elseif (wallRightTable~=nil) then
            playerTable.grounded = false
            locked = true
        elseif (platform1Table~=nil) then
            playerTable.grounded = false
            locked = true
        elseif (platform2Table~=nil) then
            playerTable.grounded = false
            locked = true
        elseif (platform3Table~=nil) then
            playerTable.grounded = false
            locked = true
        elseif (platform4Table~=nil) then
            playerTable.grounded = false
            locked = true
        elseif (platform5Table~=nil) then
            playerTable.grounded = false
            locked = true
        end
    end
    if(player2Table~=nil)then
        if (playerTable~=nil) then
            player2Table.grounded = false
            locked = true
        elseif (groundTable~=nil) then
            player2Table.grounded = false
            locked = true
        elseif (wallLeftTable~=nil) then
            player2Table.grounded = false
            locked = true
        elseif (wallRightTable~=nil) then
            player2Table.grounded = false
            locked = true
        elseif (platform1Table~=nil) then
            player2Table.grounded = false
            locked = true
        elseif (platform2Table~=nil) then
            player2Table.grounded = false
            locked = true
        elseif (platform3Table~=nil) then
            player2Table.grounded = false
            locked = true
        elseif (platform4Table~=nil) then
            player2Table.grounded = false
            locked = true
        elseif (platform5Table~=nil) then
            player2Table.grounded = false
            locked = true
        end
    end
    if(projectileTable~=nil)then
        if (player2Table~=nil) then
            if(player2Table.swinging)then
                player2Table.health = player2Table.health
            else
                player2Table.health = player2Table.health - 1
            end
        elseif (playerTable~=nil) then
            if(playerTable.swinging)then
                playerTable.health = playerTable.health
            else
                playerTable.health = playerTable.health - 1
            end
        elseif (groundTable~=nil) then
            print("cleared")
        elseif (wallLeftTable~=nil) then
            print("cleared")
        elseif (wallRightTable~=nil) then
            print("cleared")
        end
    end
    -- if(player2Table~=nil and projectileTable~=nil)then
    --     table.remove(projectile_list, projectileTable.i)
    -- end
    -- if(projectileTable~=nil and groundTable~=nil)then
    --     table.remove(projectile_list, projectileTable.i)
    -- end
    -- if(projectileTable~=nil and wallLeftTable~=nil)then
    --     table.remove(projectile_list, projectileTable.i)
    -- end
    -- if(projectileTable~=nil and wallRightTable~=nil)then
    --     table.remove(projectile_list, projectileTable.i)
    -- end

    
end

function preSolve(a, b, coll)
	
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	
end