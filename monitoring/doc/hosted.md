## Hosted on monitoring.minetest.land

The central minetest monitoring server can be used to display the metrics.
Install the mod and add the following settings to your `minetest.conf`:

```
secure.http_mods = monitoring
monitoring.prometheus_push_url = https://monitoring.minetest.land/push/metrics/job/minetest/instance/my-server-name
```

The last part of the push_url is the name of the instance.
If the server name is `my-awesome-server` then the url should look like this:

```
monitoring.prometheus_push_url = https://monitoring.minetest.land/push/metrics/job/minetest/instance/my-awesome-server
```

The stats can now be seen at [monitoring.minetest.land](https://monitoring.minetest.land/d/YUpouLmWk/overview?tab=visualization&orgId=1&refresh=5s&var-instance=creative1)
