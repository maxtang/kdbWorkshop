rem run all rdb

c:
cd \q\ws\tick
for %%f in (ticker rdb hlcv last tq vwap show feed) do start "%%f" win\%%f.bat
