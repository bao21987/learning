#! /bin/bash
echo "123"
# : 的用法
: > ./test.txt

echo "1 2 3\n4 5 6" | awk '
BEGIN {a=0;b=0;c=0;print "<tr>%"}
{a += $1; printf "haha%s\n", $1}
{b += $2; printf "haha%s\n", $2}
{c += $3; printf "haha%s\n", $3}
{printf "haha%.2f%\n", $3*100.0/$2}
END {
    printf "haha%s\n", a;
    printf "haha%s\n", b;
    printf "haha%s\n", c;
    printf "haha%.2f%\n", c*100.0/b;
    print "</tr>"}
'
sql="
      SELECT
          bucket, sum(case when (numl > 1 or numr is not null) then numl else 0 end), sum(numl)
      FROM
          (
          SELECT
             gid, rec_vid, bucket, count(1) as numl
          FROM
             dwv_mp.dwv_mp_rec
          WHERE
             dt = '20170601' and cid=0 and area='rec_0002' and p2=3 and rec_vid is not null and gid is not null
          GROUP BY
             gid, rec_vid, bucket) tl
      LEFT JOIN
          (
          SELECT
              gid, rec_vid, count(1) as numr
          FROM
              dwv_mp.dwv_mp_rec
          WHERE
              dt >= '20170527' and dt < '20170601' and cid=0 and area='rec_0002' and p2=3 and rec_vid is not null and gid is not null
          GROUP BY gid, rec_vid) tr
      ON
          tl.gid=tr.gid and tl.rec_vid=tr.rec_vid
      GROUP BY bucket;
"
echo $sql
