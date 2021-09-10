
export FJS_GL_DBGLEV=2
export FGLIMAGEPATH=../pics/fa5.txt:../pics:../pics/products
export FGLRESOURCEPATH=../etc

PROG=${1:-menu.42r}
shift

fglrun $PROG $!
