# $1: program name
# $2: optimize (or null)
# $3: opt-flag (or null)

CMD=""
if [ "$3" != "" ]
then
  CMD="$CMD klee-flag "
else
  CMD="$CMD klee-original "
fi

CMD="$CMD \
  --use-cache=false \
  --use-cex-cache=false \
  --libc=uclibc \
  --search=dfs"

if [ "$2" != "" ]; then
  CMD="$CMD --$2"
  if [ "$3" != "" ]; then
    CMD="$CMD --opt-flag=$3"
  fi
fi
CMD="$CMD $1.bc"

${CMD}
