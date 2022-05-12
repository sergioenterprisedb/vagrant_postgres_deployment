#!/bin/bash

usage() {
  cat << EOF

Usage: vagrant_up.sh -a [reference architecture]

Parameters:
   -a: EDB-RA-1, EDB-RA-2, EDB-RA-3

EOF
}

# ************
# *** MAIN ***
# ************

if [ "$#" -eq 0 ]; then
  usage;
  exit 1;
fi

while getopts "h:a:" optname; do
  case "${optname}" in
    "h")
      usage
      exit 0;
      ;;
    "a")
      REF_ARCHITECTURE="${OPTARG}"
      ;;
    "?")
      usage;
      exit 1;
      ;;
    *)
    # Should not occur
      echo "Unknown error while processing options inside vagrant_up.sh"
      ;;
  esac
done

start=$SECONDS
if [ "${REF_ARCHITECTURE}" != "EDB-RA-1" ] && [ "${REF_ARCHITECTURE}" != "EDB-RA-2" ] && [ "${REF_ARCHITECTURE}" != "EDB-RA-3" ]; then
  echo "Version not equal to EDB-RA1, EDB-RA-2 or EDB-RA-3"
  usage
  exit 1;
else
  if [ "${REF_ARCHITECTURE}" == "EDB-RA-1" ]; then
    vagrant up pg1
    #vagrant up pg2 &
    vagrant up pem1 &
    vagrant up backup1 
  elif [ "${REF_ARCHITECTURE}" == "EDB-RA-2" ]; then
    vagrant up pg1
    vagrant up pg2 &
    vagrant up pg3 &
    vagrant up pem1 &
    vagrant up backup1 
  elif [ "${REF_ARCHITECTURE}" == "EDB-RA-3" ]; then
    vagrant up pg1
    vagrant up pem1 &
    vagrant up pg2 &
    vagrant up pg3 &
    vagrant up backup1 &
    vagrant up pooler-1 &
    vagrant up pooler-2 &
    vagrant up pooler-3 
  fi
fi

end=$SECONDS
echo "****************************"
echo "*** vagrant up finished. ***"
echo "****************************"
echo "Duration: $((end-start)) seconds."

