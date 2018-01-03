vnstat
======

[vnStat][1] is a console-based network traffic monitor for Linux and BSD that keeps
a log of network traffic for the selected interface(s).

###
```bash
docker run -d --name vnstat --restart=always --net host lihaixin/vnstat
docker  exec vnstat bash
>>> vnstat --help
>>> vnstati --help
>>> exit
```

[1]: http://humdi.net/vnstat/
