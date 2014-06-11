rem run tick processes under console2
rem set correct path to console
c:
cd \q
c:\apps\console2\console ^
 -t ticker -r "/k w32\q.exe ws/tick/ticker.q -p 5010" ^
 -t rdb -r "/k w32\q.exe ws/tick/cx.q rdb -p 5011" ^
 -t hlcv -r "/k w32\q.exe ws/tick/cx.q hlcv -p 5014" ^
 -t last -r "/k w32\q.exe ws/tick/cx.q last -p 5015" ^
 -t tq -r "/k w32\q.exe ws/tick/cx.q tq -p 5016" ^
 -t vwap -r "/k w32\q.exe ws/tick/cx.q vwap -p 5017" ^
 -t show -r "/k w32\q.exe ws/tick/cx.q show" ^
 -t feed -r "/k w32\q.exe ws/tick/feed.q localhost:5010 -t 107"