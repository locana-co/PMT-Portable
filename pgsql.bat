set SOFTWARE_ROOT=D:\pgsql\bin
 
title "pgsql"
 
start %SOFTWARE_ROOT%\psql.exe -h localhost -p 5439 -U postgres -w
exit