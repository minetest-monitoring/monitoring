
local export_json = function()
  local json_data = minetest.write_json(monitoring.metrics, true)
  local path = minetest.get_worldpath().."/monitoring.json";

  local file = io.open( path, "w" );
  if(file) then
     file:write(json_data);
     file:close();
  else
     print("[monitoring] Error: Savefile could not be written");
  end

end


monitoring.json_init = function()
  local timer = 0
  minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer < 5 then return end
    timer=0

    export_json()
  end)
end
