local bs = {
    UpdateBarter = "bsUpdateBarter",
    keyStillDown = "bsKeyStillDown"
}

function bs.inspect(table)
    local inspect = require("inspect").inspect
    local bsF = debug.getinfo(1, "nSl")
    local bsC = debug.getinfo(2, "nSl")
    mwse.log("%s", inspect(table))
end


return bs