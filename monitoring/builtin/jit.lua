local jit_version = monitoring.gauge("jit_version", "luajit version")
local jit_enabled = monitoring.gauge("jit_enabled", "luajit enabled")

if jit then
	if jit.version_num then
		jit_version.set(jit.version_num)
	else
		jit_version.set(0)
	end

	local enabled = jit.status()

	if enabled then
		jit_enabled.set(1)
	else
		jit_enabled.set(0)
	end
else
	jit_version.set(0)
	jit_enabled.set(0)
end
