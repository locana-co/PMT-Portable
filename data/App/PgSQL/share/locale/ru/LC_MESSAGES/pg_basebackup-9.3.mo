��    �      �  �   \	      p     q     �  !   �  
   �  -   �     �  3     K   ;  <   �  >   �  3     V   7  <   �  ?   �  M     k   Y  J   �  Y     +   j  B   �  *   �  8     5   =  r   s  1   �  3     K   L  -   �  F   �  \     P   j  4   �  8   �  4   )  1   ^  @   �  1   �       (   #  '   L  &   t  (   �  -   �  '   �  "         =  $   ^  2   �  ,   �  +   �  .     (   >  #   g  5   �  9   �  4   �  7   0  =   h  "   �  &   �  #   �  /     >   D  Y   �  &   �  &     2   +  1   ^  0   �     �     �  8   �  2   8      k  &   �  '   �  .   �  +   
  #   6  A   Z  2   �  &   �  &   �  /     +   M  4   y  /   �  !   �  1      )   2  (   \  2   �  3   �  0   �  %     +   C     o  2   �     �  ,   �  ,   �  #   +   W   O   9   �   A   �   #   #!  9   G!     �!  !   �!  &   �!  A   �!  !   *"  "   L"  9   o"  1   �"  ,   �"     #  '   #  D   C#  8   �#  6   �#     �#  E   $  G   W$  z   �$  c   %  %   ~%  2   �%  6   �%  #   &  %   2&  R   X&  ,   �&  4   �&  >   '  o   L'  k   �'  4   ((  %   ](  (   �(  ;   �(  
   �(  &   �(     )  /   ")     R)  /   a)    �)  ,   �+      �+  <   �+     4,  W   J,     �,  N   �,  �   -  r   �-  k   .  P   m.  v   �.  �   5/  E   �/  q   0  �   z0  j   ?1  �   �1  C   C2  k   �2  \   �2  b   P3  G   �3  �   �3  P   �4  B   (5  m   k5  9   �5  �   6  �   �6  �   �7  `   �8  p   9  c   �9  l   �9  �   \:  U   �:  a   =;  L   �;  N   �;  J   ;<  7   �<  F   �<  ?   =  9   E=  C   =  G   �=  U   >  I   a>  Z   �>  U   ?  ?   \?  9   �?  _   �?  `   6@  b   �@  b   �@  ]   ]A  S   �A  I   B  ]   YB  u   �B  �   -C  �   �C  u   LD  ?   �D  b   E  ]   eE  a   �E  A   %F  C   gF  {   �F  j   'G  @   �G  C   �G  R   H  O   jH  M   �H  E   I  o   NI  n   �I  K   -J  F   yJ  U   �J  P   K  Y   gK  b   �K  U   $L  a   zL  M   �L  I   *M  N   tM  d   �M  W   (N  ;   �N  F   �N     O  m   O  3   �O  I   �O  Z   	P  >   dP  �   �P  v   FQ  �   �Q  6   FR  `   }R  0   �R  T   S  H   dS  }   �S  0   +T  4   \T  j   �T  s   �T  ]   pU  "   �U  Z   �U  �   LV  Z   �V  z   (W  !   �W  �   �W  z   FX  �   �X  �   �Y  L   LZ  h   �Z  O   [  >   R[  V   �[  �   �[  V   �\  h   �\  s   c]  �   �]  �   �^  K   �_  D   �_  G   `  s   c`     �`  [   �`     Ba  p   _a     �a  h   �a        �   J   d          )             :           �   .   f   q   Y          h   A   O   B   �   	   s   �   (       n                      p       L   P   ?         b      6   E   W   *         �   C              �           l   �   {   �   4   G   Z   "           v   +              V       k                          x   i   9      �          `   5   �   �              m       r   ,           -   T   %       H      ]   M       =       F   1   X   z   3   _   �   #   e   |       g   ^   I   ;   2          �       U      [           
   <           �   7   �   �          '      ~   �             o   S   @       K   R   c       t   8   �   $      N   Q   }   D   /   \   j       �          0   y   !      u   �   w      �       >       &   a           
Connection options:
 
General options:
 
Options controlling the output:
 
Options:
 
Report bugs to <pgsql-bugs@postgresql.org>.
   %s [OPTION]...
   -?, --help             show this help, then exit
   -D, --directory=DIR    receive transaction log files into this directory
   -D, --pgdata=DIRECTORY receive base backup into directory
   -F, --format=p|t       output format (plain (default), tar)
   -P, --progress         show progress information
   -R, --write-recovery-conf
                         write recovery.conf after backup
   -U, --username=NAME    connect as specified database user
   -V, --version          output version information, then exit
   -W, --password         force password prompt (should happen automatically)
   -X, --xlog-method=fetch|stream
                         include required WAL files with specified method
   -Z, --compress=0-9     compress tar output with given compression level
   -c, --checkpoint=fast|spread
                         set fast or spread checkpointing
   -d, --dbname=CONNSTR   connection string
   -h, --host=HOSTNAME    database server host or socket directory
   -l, --label=LABEL      set backup label
   -n, --no-loop          do not loop on connection lost
   -p, --port=PORT        database server port number
   -s, --status-interval=INTERVAL
                         time between status packets sent to server (in seconds)
   -v, --verbose          output verbose messages
   -w, --no-password      never prompt for password
   -x, --xlog             include required WAL files in backup (fetch mode)
   -z, --gzip             compress tar output
 %*s/%s kB (%d%%), %d/%d tablespace %*s/%s kB (%d%%), %d/%d tablespaces %*s/%s kB (%d%%), %d/%d tablespace (%s%-*.*s) %*s/%s kB (%d%%), %d/%d tablespaces (%s%-*.*s) %*s/%s kB (100%%), %d/%d tablespace %*s %*s/%s kB (100%%), %d/%d tablespaces %*s %s receives PostgreSQL streaming transaction logs.

 %s takes a base backup of a running PostgreSQL server.

 %s: COPY stream ended before last file was finished
 %s: WAL streaming can only be used in plain mode
 %s: can only write single tablespace to stdout, database has %d
 %s: cannot specify both --xlog and --xlog-method
 %s: child %d died, expected %d
 %s: child process did not exit normally
 %s: child process exited with error %d
 %s: child thread exited with error %u
 %s: could not access directory "%s": %s
 %s: could not close compressed file "%s": %s
 %s: could not close directory "%s": %s
 %s: could not close file "%s": %s
 %s: could not connect to server
 %s: could not connect to server: %s
 %s: could not create archive status file "%s": %s
 %s: could not create background process: %s
 %s: could not create background thread: %s
 %s: could not create compressed file "%s": %s
 %s: could not create directory "%s": %s
 %s: could not create file "%s": %s
 %s: could not create pipe for background process: %s
 %s: could not create symbolic link from "%s" to "%s": %s
 %s: could not create timeline history file "%s": %s
 %s: could not determine seek position in file "%s": %s
 %s: could not determine server setting for integer_datetimes
 %s: could not fsync file "%s": %s
 %s: could not get COPY data stream: %s %s: could not get backup header: %s %s: could not get child thread exit status: %s
 %s: could not get transaction log end position from server: %s %s: could not identify system: got %d rows and %d fields, expected %d rows and %d fields
 %s: could not initiate base backup: %s %s: could not open directory "%s": %s
 %s: could not open timeline history file "%s": %s
 %s: could not open transaction log file "%s": %s
 %s: could not pad transaction log file "%s": %s
 %s: could not parse file mode
 %s: could not parse file size
 %s: could not parse next timeline's starting point "%s"
 %s: could not parse transaction log location "%s"
 %s: could not read COPY data: %s %s: could not read directory "%s": %s
 %s: could not read from ready pipe: %s
 %s: could not receive data from WAL stream: %s %s: could not rename file "%s" to "%s": %s
 %s: could not rename file "%s": %s
 %s: could not seek to beginning of transaction log file "%s": %s
 %s: could not send command to background pipe: %s
 %s: could not send copy-end packet: %s %s: could not send feedback packet: %s %s: could not send replication command "%s": %s %s: could not set compression level %d: %s
 %s: could not set permissions on directory "%s": %s
 %s: could not set permissions on file "%s": %s
 %s: could not stat file "%s": %s
 %s: could not stat transaction log file "%s": %s
 %s: could not wait for child process: %s
 %s: could not wait for child thread: %s
 %s: could not write %u bytes to WAL file "%s": %s
 %s: could not write timeline history file "%s": %s
 %s: could not write to compressed file "%s": %s
 %s: could not write to file "%s": %s
 %s: directory "%s" exists but is not empty
 %s: disconnected
 %s: disconnected; waiting %d seconds to try again
 %s: final receive failed: %s %s: finished segment at %X/%X (timeline %u)
 %s: got WAL data offset %08x, expected %08x
 %s: incompatible server version %s
 %s: incompatible server version %s; streaming is only supported with server version %s
 %s: integer_datetimes compile flag does not match server
 %s: invalid checkpoint argument "%s", must be "fast" or "spread"
 %s: invalid compression level "%s"
 %s: invalid output format "%s", must be "plain" or "tar"
 %s: invalid port number "%s"
 %s: invalid status interval "%s"
 %s: invalid tar block header size: %d
 %s: invalid xlog-method option "%s", must be "fetch" or "stream"
 %s: no data returned from server
 %s: no target directory specified
 %s: no transaction log end position returned from server
 %s: not renaming "%s%s", segment is not complete
 %s: only tar mode backups can be compressed
 %s: out of memory
 %s: received interrupt signal, exiting
 %s: received transaction log record for offset %u with no file open
 %s: replication stream was terminated before stop point
 %s: segment file "%s" has incorrect size %d, skipping
 %s: select() failed: %s
 %s: server reported unexpected history file name for timeline %u: %s
 %s: server reported unexpected next timeline %u, following timeline %u
 %s: server returned unexpected response to BASE_BACKUP command; got %d rows and %d fields, expected %d rows and %d fields
 %s: server stopped streaming timeline %u at %X/%X, but reported next timeline %u to begin at %X/%X
 %s: starting background WAL receiver
 %s: starting log streaming at %X/%X (timeline %u)
 %s: starting timeline %u is not present in the server
 %s: streaming header too small: %d
 %s: switched to timeline %u at %X/%X
 %s: system identifier does not match between base backup and streaming connection
 %s: this build does not support compression
 %s: too many command-line arguments (first is "%s")
 %s: transaction log file "%s" has %d bytes, should be 0 or %d
 %s: unexpected response to TIMELINE_HISTORY command: got %d rows and %d fields, expected %d rows and %d fields
 %s: unexpected result set after end-of-timeline: got %d rows and %d fields, expected %d rows and %d fields
 %s: unexpected termination of replication stream: %s %s: unrecognized link indicator "%c"
 %s: unrecognized streaming header: "%c"
 %s: waiting for background process to finish streaming ...
 Password:  Try "%s --help" for more information.
 Usage:
 cannot duplicate null pointer (internal error)
 out of memory
 transaction log start point: %s on timeline %u
 Project-Id-Version: PostgreSQL 9 current
Report-Msgid-Bugs-To: pgsql-bugs@postgresql.org
POT-Creation-Date: 2015-01-14 00:17+0000
PO-Revision-Date: 2015-07-27 15:35+0300
Last-Translator: Alexander Lakhin <exclusion@gmail.com>
Language-Team: Russian <pgtranslation-translators@pgfoundry.org>
Language: ru
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=3; plural=n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;
X-Generator: Lokalize 1.5
 
Параметры подключения:
 
Общие параметры:
 
Параметры, управляющие выводом:
 
Параметры:
 
Об ошибках сообщайте по адресу <pgsql-bugs@postgresql.org>.
   %s [ПАРАМЕТР]...
   -?, --help             показать эту справку и выйти
   -D, --directory=ПУТЬ   сохранять файлы журналов транзакций в данный каталог
   -D, --pgdata=КАТАЛОГ   сохранить базовую копию в указанный каталог
   -F, --format=p|t       формат вывода (p (по умолчанию) - простой, t - tar)
   -P, --progress         показывать прогресс операции
   -R, --write-recovery-conf
                         записать recovery.conf после копирования
   -U, --username=NAME    connect as specified database user
  -U, --username=ИМЯ     имя пользователя баз данных
   -V, --version          показать версию и выйти
   -W, --password         запрашивать пароль всегда (обычно не требуется)
   -X, --xlog-method=fetch|stream
                         включить в копию требуемые файлы WAL, используя
                         заданный метод
   -Z, --compress=0-9     установить уровень сжатия выходного архива
   -c, --checkpoint=fast|spread
                         режим быстрых или распределённых контрольных точек
   -d, --dbname=СТРОКА    строка подключения
   -h, --host=ИМЯ         имя сервера баз данных или каталог сокетов
   -l, --label=МЕТКА      установить метку резервной копии
   -n, --no-loop          прерывать работу при потере соединения
   -p, --port=ПОРТ        номер порта сервера БД
   -s, --status-interval=ИНТЕРВАЛ
                         интервал между передаваемыми серверу
                         пакетами состояния (в секундах)
   -v, --verbose          выводить подробные сообщения
   -w, --no-password      не запрашивать пароль
   -x, --xlog             включить в копию требуемые файлы WAL (режим fetch)
   -z, --gzip             сжать выходной tar
 %*s/%s КБ (%d%%), табличное пространство %d/%d %*s/%s КБ (%d%%), табличное пространство %d/%d %*s/%s КБ (%d%%), табличное пространство %d/%d %*s/%s КБ (%d%%), табличное пространство %d/%d (%s%-*.*s) %*s/%s КБ (%d%%), табличное пространство %d/%d (%s%-*.*s) %*s/%s КБ (%d%%), табличное пространство %d/%d (%s%-*.*s) %*s/%s КБ (100%%), табличное пространство %d/%d %*s %*s/%s КБ (100%%), табличное пространство %d/%d %*s %*s/%s КБ (100%%), табличное пространство %d/%d %*s %s получает транслируемые журналы транзакций PostgreSQL.

 %s делает базовую резервную копию работающего сервера PostgreSQL.

 %s: поток COPY закончился до завершения последнего файла
 %s: потоковая передача WAL поддерживается только в режиме plain
 %s: в stdout можно вывести только одно табличное пространство, всего в СУБД их %d
 %s: указать и --xlog, и --xlog-method одновременно нельзя
 %s: завершился дочерний процесс %d вместо ожидаемого %d
 %s: дочерний процесс завершён ненормально
 %s: дочерний процесс завершился с ошибкой %d
 %s: дочерний поток завершился с ошибкой %u
 %s: нет доступа к каталогу "%s": %s
 %s: не удалось закрыть сжатый файл "%s": %s
 %s: не удалось закрыть каталог "%s": %s
 %s: не удалось закрыть файл "%s": %s
 %s: не удалось подключиться к серверу
 %s: не удалось подключиться к серверу: %s
 %s: не удалось создать файл статуса архива "%s": %s
 %s: не удалось создать фоновый процесс: %s
 %s: не удалось создать фоновый поток выполнения: %s
 %s: не удалось создать файл сжатого архива "%s": %s
 %s: не удалось создать каталог "%s": %s
 %s: не удалось создать файл "%s": %s
 %s: не удалось создать канал для фонового процесса: %s
 %s: не удалось создать символическую ссылку "%s" в "%s": %s
 %s: не удалось создать файл истории линии времени "%s": %s
 %s: не удалось определить текущую позицию в файле "%s": %s
 %s: не удалось получить настройку сервера integer_datetimes
 %s: не удалось синхронизировать с ФС файл "%s": %s
 %s: не удалось получить поток данных COPY: %s %s: не удалось получить заголовок резервной копии: %s %s: не удалось получить состояние завершения дочернего потока: %s
 %s: не удалось получить конечную позицию в журнале транзакций с сервера: %s %s: не удалось идентифицировать систему, получено строк: %d, полей: %d (ожидалось: %d и %d)
 %s: не удалось инициализировать базовое резервное копирование: %s %s: не удалось открыть каталог "%s": %s
 %s: не удалось открыть файл истории линии времени "%s": %s
 %s: не удалось открыть файл журнала транзакций "%s": %s
 %s: не удалось дополнить файл журнала транзакций "%s": %s
 %s: не удалось разобрать режим файла
 %s: не удалось разобрать размер файла
 %s: не удалось разобрать начальную точку следующей линии времени "%s"
 %s: не удалось разобрать положение в журнале транзакций "%s"
 %s: не удалось прочитать данные COPY: %s %s: не удалось прочитать каталог "%s": %s
 %s: не удалось прочитать из готового канала: %s
 %s: не удалось получить данные из потока WAL: %s %s: не удалось переименовать файл "%s" в "%s": %s
 %s: не удалось переименовать файл "%s": %s
 %s: не удалось перейти к началу файла журнала транзакций "%s": %s
 %s: не удалось отправить команду в канал фонового процесса: %s
 %s: не удалось отправить пакет "конец COPY": %s %s: не удалось отправить пакет отзыва: %s %s: не удалось передать команду репликации "%s": %s %s: не удалось установить уровень сжатия %d: %s
 %s: не удалось установить права для каталога "%s": %s
 %s: не удалось установить права доступа для файла "%s": %s
 %s: не удалось получить информацию о файле "%s": %s
 %s: не удалось проверить файл журнала транзакций "%s": %s
 %s: сбой при ожидании дочернего процесса: %s
 %s: сбой при ожидании дочернего потока: %s
 %s: не удалось записать %u байт в файл WAL "%s": %s
 %s: не удалось записать файл истории линии времени "%s": %s
 %s: не удалось записать файл сжатого архива "%s": %s
 %s: не удалось записать файл "%s": %s
 %s: каталог "%s" существует, но он не пуст
 %s: отключение
 %s: отключение; через %d сек. последует повторное подключение
 %s: ошибка в конце передачи: %s %s: завершён сегмент %X/%X (линия времени %u)
 %s: получено смещение данных WAL %08x, но ожидалось %08x
 %s: несовместимая версия сервера %s
 %s: несовместимая версия сервера %s; потоковая передача поддерживается только с версией %s
 %s: флаг компиляции integer_datetimes не соответствует настройке сервера
 %s: неверный аргумент режима контрольных точек "%s", должен быть "fast" или "spread"
 %s: неверный уровень сжатия "%s"
 %s: неверный формат вывода "%s", должен быть "plain" или "tar"
 %s: неверный номер порта "%s"
 %s: неверный интервал сообщений о состоянии "%s"
 %s: неверный размер заголовка блока tar: %d
 %s: неверный аргумент для xlog-method - "%s", допускается только "fetch" или "stream"
 %s: сервер не вернул данные
 %s: целевой каталог не указан
 %s: сервер не вернул конечную позицию в журнале транзакций
 %s: файл "%s%s" не переименовывается, так как это не полный сегмент
 %s: сжимать можно только резервные копии в архиве tar
 %s: нехватка памяти
 %s: получен сигнал прерывания, работа завершается
 %s: получена запись журнала транзакций по смещению %u, но файл не открыт
 %s: поток репликации закончился до точки останова
 %s: файл сегмента "%s" имеет неправильный размер %d, файл пропускается
 %s: ошибка в select(): %s
 %s: сервер сообщил неожиданное имя файла истории для линии времени %u: %s
 %s: сервер неожиданно сообщил линию времени %u после линии времени %u
 %s: сервер вернул неожиданный ответ на команду BASE_BACKUP; получено строк: %d, полей: %d, а ожидалось строк: %d, полей: %d
 %s: сервер прекратил передачу линии времени %u в %X/%X, но сообщил, что следующая линии времени %u начнётся в %X/%X
 %s: запуск фонового процесса считывания WAL
 %s: начало передачи журнала с позиции %X/%X (линия времени %u)
 %s: на сервере нет начальной линии времени %u
 %s: заголовок потока слишком мал: %d
 %s: переключение на линию времени %u (позиция %X/%X)
 %s: системный идентификатор базовой резервной копии отличается от идентификатора потоковой передачи
 %s: эта сборка программы не поддерживает сжатие
 %s: слишком много аргументов командной строки (первый: "%s")
 %s: файл журнала транзакций "%s" имеет размер %d Б, а должен - 0 или %d
 %s: сервер вернул неожиданный ответ на команду TIMELINE_HISTORY; получено строк: %d, полей: %d, а ожидалось строк: %d, полей: %d
 %s: сервер вернул неожиданный набор данных после конца линии времени - получено строк: %d, полей: %d, а ожидалось строк: %d, полей: %d
 %s: неожиданный конец потока репликации: %s %s: нераспознанный индикатор связи "%c"
 %s: нераспознанный заголовок потока: "%c"
 %s: ожидание завершения потоковой передачи фоновым процессом...
 Пароль:  Для дополнительной информации попробуйте "%s --help".
 Использование:
 попытка дублирования нулевого указателя (внутренняя ошибка)
 нехватка памяти
 стартовая точка журнала транзакций: %s на линии времени %u
 