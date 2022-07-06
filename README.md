# Tests

Get URLs out of the database in *random* order and dump to `urls.txt`.

```sql
SELECT access_url 
FROM resources 
WHERE restricted = false 
ORDER BY random()
LIMIT 100;
```

Clean up by removing `"` and header (can be scripted)

## Curl
See https://unix.stackexchange.com/questions/281991/pass-a-list-of-urls-contained-in-a-file-to-curl

https://stackoverflow.com/questions/6136022/script-to-get-the-http-status-code-of-a-list-of-urls 

`curl -L -o - -I https://knightscholar.geneseo.edu/context/kimball-square-dances/article/1000/type/native/viewcontent`

need to check `--parallel` 

https://man7.org/linux/man-pages/man1/curl.1.html 



## Webchk

https://github.com/amgedr/webchk

### Install

`pip3 install webchk`

### Running

`webchk -i urls.txt -o webchk-results.txt`

Results look like  `https://digital.denverlibrary.org/digital/collection/p16079coll36/id/2771 ... 200 OK (0.453)` and does follow redirects.

## http-status-check
https://github.com/spatie/http-status-check

### Install
`composer global require spatie/http-status-check`

### Run
`http-status-check scan https://id.lib.uh.edu/ark:/84475/do55290997h`

Would not run

## Script

From https://stackoverflow.com/questions/6136022/script-to-get-the-http-status-code-of-a-list-of-urls

```bash
#!/bin/bash
while read LINE; do
  curl -o /dev/null --silent --head --write-out "%{http_code} $LINE\n" "$LINE"
done < urls.txt
```

**Time: ./curl-check.sh  0.65s user 0.30s system 79% cpu 1.200 total**

`xargs -n1 -P 10 curl -o /dev/null --silent --head --write-out '%{url_effective};%{http_code};%{time_total};%{time_namelookup};%{time_connect};%{size_download};%{speed_download}\n' < urls.txt | tee results.csv`

**Time: ./curl-parallel-check.sh  0.64s user 0.30s system 247% cpu 0.377 total**

```bash
#!/bin/bash
while read LINE; do
    wget --server-response --spider --quiet "$LINE" 2>&1 | awk 'NR==1{print $2}'
done < urls.txt
```

**./wget-check.sh  1.76s user 0.78s system 4% cpu 1:02.20 total**