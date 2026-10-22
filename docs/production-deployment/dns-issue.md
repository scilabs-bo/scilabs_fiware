# Fixing DNS Issue

## Problem

The server was unable to resolve domain names, resulting in errors such as:

- `Temporary failure resolving 'de.archive.ubuntu.com'` when running `apt update`.
- `ping: google.com: Temporary failure in name resolution` when attempting to ping a domain.

We check if name resolving was working with:

```sh
dig www.google.de
```

This resulted in no answer - but we could reach servers on the internet via the ip:

```sh
ping 8.8.8.8
```

This system uses the resolved service so we then checked to service output for errors:

```sh
journalctl -fu systemd-resolved
```

and found:

```
Negative trust anchors: home.arpa 10.in-addr.arpa 16.172.in-addr.arpa 17.172.in-addr.arpa 18.172.in-addr.arpa 19.172.in-addr.arpa 20.172.in-addr.arpa 21.172.in-addr.arpa 22.172.in-addr.arpa 23.172.in-addr.arpa 24.172.in-addr.arpa 25.172.in-addr.arpa 26.172.in-addr.arpa 27.172.in-addr.arpa 28.172.in-addr.arpa 29.172.in-addr.arpa 30.172.in-addr.arpa 31.172.in-addr.arpa 170.0.0.192.in-addr.arpa 171.0.0.192.in-addr.arpa 168.192.in-addr.arpa d.f.ip6.arpa ipv4only.arpa corp home internal intranet lan local private test
```

Next we checked the automatic generated config for resolved at `/etc/resolv.conf ` and found:

```
nameserver 127.0.0.53
options edns0 trust-ad
search example.com
```

## Fix

We did set the DNS server in `/etc/systemd/resolved.conf`:

```
DNS=8.8.8.8
```

and restarted the resolved service with:

```
sudo systemctl restart systemd-resolved
```

Now `dig` gets answers and resolved is working.
