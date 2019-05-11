local metric_major = monitoring.gauge("version_major", "monitoring major version")
local metric_minor = monitoring.gauge("version_minor", "monitoring minor version")


metric_major.set( monitoring.version_major )
metric_minor.set( monitoring.version_minor )
