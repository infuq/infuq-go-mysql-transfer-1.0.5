local ops = require("mongodbOps")
local db = require("dbOps")

local row = ops.rawRow()
local action = ops.rawAction()

local orderNo = row["t_order_no"]
local userId = row["t_user_id"]



local result = {}
result["_class"] = "com.infuq.model.Order"

if orderNo ~= nil then
    result["orderNo"] = orderNo
end

if action == "insert" then
    if userId ~= nil then
        local sql = string.format("SELECT * FROM db0.t_user WHERE id = %s", userId)
        local rs1 = db.selectOne(sql)
        if next(rs1) ~= nil then
            local userName = rs1["t_name"]
            local userAddress = rs1["t_address"]        
            result["userName"] = userName
            result["userAddress"] = userAddress
        end
    end
    ops.INSERT("order", result)
elseif action == "delete" then

else

end
