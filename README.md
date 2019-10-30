# AutoEADLocation

Automatically apply a resources public url as the EAD Location value.

**Warning: this will overwrite any existing EAD Location value.**

## Batch update

The plugin will set the EAD Location on create / update events. Use
SQL to initially prepare all records:

```sql
-- w/o slugs
UPDATE resource SET ead_location = CONCAT_WS(
  '/',
  $public_proxy_url,
  'repositories',
  repo_id,
  'resources',
  id
), system_mtime = NOW();
```

Where `$public_proxy_url` matches `AppConfig[:public_proxy_url]`.
