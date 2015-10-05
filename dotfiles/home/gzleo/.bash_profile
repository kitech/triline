
source /etc/profile

# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    ###### ????????
    # . ~/.bashrc
    false
fi

# User specific environment and startup programs
. $HOME/myscripts/etc/mybash_profile

#export PYTHONPATH=$PYTHONPATH:.
#export PYTHONDONTWRITEBYTECODE=1  #禁止生成.pyc
#
#export RUBYLIB=.:$HOME/opensource/rubyjitqt/lib
#export PATH=$PATH:$HOME/.gem/ruby/2.2.0/bin:$HOME/bin:$HOME/golib/bin
#export LD_LIBRARY_PATH=$HOME/mylib:$LD_LIBRARY_PATH
#export GOPATH=$HOME/golib:$GOPATH:$PWD

#JAVA_OPTS="-Xmx128M -Xms16M -Xss2M"
#JAVA_HOME=/usr/lib/jvm/default
#AKKA_LIB=$HOME/jars/akka-2.3.8/lib/akka
#export CLASSPATH=$AKKA_LIB/akka-actor_2.11-2.3.8.jar:$AKKA_LIB/akka-actor_2.11-2.3.8.jar:$AKKA_LIB/config-1.2.1.jar
# use -Djava.ext.dirs=...替代
#JAR_EXTS=$JAVA_HOME/jre/lib/ext:$AKKA_LIB

#export DTPXY=127.0.0.1:8117

#alias git=$HOME/myscripts/egit.sh
