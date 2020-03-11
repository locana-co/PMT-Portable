REM PMT-Portable.bat
REM Kicking it old school with some REM statements. 

REM set TOOLS_ROOT=%D:
REM set POSTGRESQL_ROOT=%TOOLS_ROOT%\pgsql
set POSTGRESQL_ROOT=../data/App/PgSQL/bin

PATH=%POSTGRESQL_ROOT%\bin;%PATH%
 
title "PostgreSQL"
 
@ECHO ON
REM The script sets environment variables helpful for PostgreSQL
@SET PATH="%POSTGRESQL_ROOT%\bin";%PATH%
@SET PGDATA=%POSTGRESQL_ROOT%\data
@SET PGDATABASE=postgres
@SET PGUSER=postgres
@SET PGPORT=5439
@SET PGLOCALEDIR=%POSTGRESQL_ROOT%\share\locale
REM Next line MUST be uncommented the first time to init the server, it can then be commented.
"%POSTGRESQL_ROOT%\bin\initdb" -U postgres -A trust
"%POSTGRESQL_ROOT%\bin\pg_ctl" -D "%POSTGRESQL_ROOT%/data" -l %POSTGRESQL_ROOT%/logfile start
ECHO "Click enter to stop"
pause
"%POSTGRESQL_ROOT%\bin\pg_ctl" -D "%POSTGRESQL_ROOT%/data" stop

