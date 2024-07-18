local ops = require("mongodbOps")
local db = require("dbOps")

local row = ops.rawRow()
local action = ops.rawAction()

local batchDetailsLogId = row["batch_details_log_id"]
local storageDetailsId = row["storage_details_id"]
local batchDetailsId = row["batch_details_id"]
local storageType = row["storage_type"]
local beforeQuantity = row["before_quantity"]
local quantity = row["quantity"]
local afterQuantity = row["after_quantity"]
local batchDetailsLogDesc = row["batch_details_log_desc"]
local createTime = row["create_time"]


local result = {}
result["_class"] = "com.infuq.model.BatchLog"

result['batchDetailsLogId'] = batchDetailsLogId
result['storageType'] = storageType
result['beforeQuantity'] = beforeQuantity
result['quantity'] = quantity
result['afterQuantity'] = afterQuantity
result['batchDetailsLogDesc'] = batchDetailsLogDesc
result['createTime'] = createTime



if action == "insert" then
    if storageDetailsId ~= nil then
        local sql = string.format("SELECT * FROM wisp_test.store_storage_details WHERE storage_details_id = %s", storageDetailsId)
        local rs = db.selectOne(sql)
        if next(rs) ~= nil then
            local goodsNo = rs["goods_no"]
            local goodsName = rs["goods_name"]
            local storageId = rs["storage_id"]
            local warehouseId = rs["warehouse_id"]
            result["goodsNo"] = goodsNo
            result["goodsName"] = goodsName

            local sql = string.format("SELECT * FROM wisp_test.store_storage WHERE storage_id = %s", storageId)
            local rs = db.selectOne(sql)
            if next(rs) ~= nil then
                local storageNo = rs["storage_no"]
                result["storageNo"] = storageNo
            end

            local sql = string.format("SELECT * FROM wisp_test.warehouse WHERE warehouse_id = %s", warehouseId)
            local rs = db.selectOne(sql)
            if next(rs) ~= nil then
                local warehouseName = rs["warehouse_name"]
                local linkman = rs["linkman"]
                result["warehouseName"] = warehouseName
                result["linkman"] = linkman
            end
        end
    end

    if batchDetailsId ~= nil then
        local sql = string.format("SELECT * FROM wisp_test.store_batch_details WHERE batch_details_id = %s", batchDetailsId)
        local rs = db.selectOne(sql)
        if next(rs) ~= nil then
            local batchId = rs["batch_id"]

            local sql = string.format("SELECT * FROM wisp_test.store_batch WHERE batch_id = %s", batchId)
            local rs = db.selectOne(sql)
            if next(rs) ~= nil then
                local batchNo = rs["batch_no"]
                result["batchNo"] = batchNo
            end
        end
    end


    ops.INSERT("batchLog", result)
elseif action == "delete" then

else

end
