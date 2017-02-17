local M = {}

function M.HomePosition()
       return GetAncient(GetTeam()):GetLocation();
end

return M;