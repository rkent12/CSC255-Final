weapon = {}

function weapon.makePhysicsObejectWeapon(name, x, y, w, h, bodyType, color)
    local new_phys_obj = {}
    new_phys_obj.body = love.physics.newBody(world, x, y, bodyType)
    new_phys_obj.color = color
    new_phys_obj.shape = love.physics.newRectangleShape(0, 0, w, h)
    new_phys_obj.fixture = love.physics.newFixture(new_phys_obj.body, new_phys_obj.shape)
    new_phys_obj.name = name 
    new_phys_obj.fixture:setCategory(2)
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

function weapon.makePhysicsObjectProjectile(name, x, y, r, duration, i) 
    local new_phys_obj = {}
    new_phys_obj.i = i
    new_phys_obj.body = love.physics.newBody(world, x, y, "dynamic")
    new_phys_obj.shape = love.physics.newCircleShape(0, 0, r)
    new_phys_obj.fixture = love.physics.newFixture(new_phys_obj.body, new_phys_obj.shape)
    new_phys_obj.fixture:setCategory(2)
    new_phys_obj.fixture:setUserData(new_phys_obj)
    new_phys_obj.name = name
    new_phys_obj.image = love.graphics.newImage("assets/monkey/extra/Projectile.png")
    

    function new_phys_obj.draw(direction)
        if(direction == "left")then
            love.graphics.setColor(1.0, 1.0, 1.0)
            love.graphics.draw(new_phys_obj.image,
                new_phys_obj.body:getX(),
                new_phys_obj.body:getY(),
                3, -0.5, 0.5)
        elseif(direction == "right")then
            love.graphics.setColor(1.0, 1.0, 1.0)
            love.graphics.draw(new_phys_obj.image,
                new_phys_obj.body:getX(),
                new_phys_obj.body:getY(),
                3, 0.5, 0.5)
        end
    end
    return new_phys_obj
end

