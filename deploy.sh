#!/bin/bash

usage() {
  cat << EOF

Usage: deploy.sh -a [reference architecture] -t [PostgreSQL type] -v [version] -p [project name] 
Ex:  
./deploy.sh -a EDB-RA-2 -t EPAS -v 14 -p test

Parameters:
   -a: EDB-RA-1, EDB-RA-2, EDB-RA-3
   -t: PG or EPAS
   -v: 10, 11, 12, 13 or 14
   -p: project name (default test)
EOF
}

# ************
# *** MAIN ***
# ************

test -f ~/.edb_repo_user && source ~/.edb_repo_user

if [ "$#" -eq 0 ]; then
  usage;
  exit 1;
fi

while getopts "h:a:t:v:p:" optname; do
  case "${optname}" in
    "h")
      usage
      exit 0;
      ;;
    "a")
      REF_ARCHITECTURE="${OPTARG}"
      ;;
    "t")
      PG_TYPE="${OPTARG}"
      ;;
    "v")
      PG_VERSION="${OPTARG}"
      ;;
    "p")
      PROJECT_NAME="${OPTARG}"
      ;;
    "?")
      usage;
      exit 1;
      ;;
    *)
    # Should not occur
      echo "Unknown error while processing options inside deploy_test.sh"
      ;;
  esac
done

if [ "${REF_ARCHITECTURE}" != "EDB-RA-1" ] && [ "${REF_ARCHITECTURE}" != "EDB-RA-2" ] && [ "${REF_ARCHITECTURE}" != "EDB-RA-3" ]; then
  echo "Architecture not equal to EDB-RA-1, EDB-RA-2 or EDB-RA-3"
  usage
  exit 1;
else
  if [ "${REF_ARCHITECTURE}" == "EDB-RA-1" ]; then
    cp ./baremetal-edb-ra-1.json baremetal-edb-ra.json
  elif [ "${REF_ARCHITECTURE}" == "EDB-RA-2" ]; then
    cp ./baremetal-edb-ra-2.json baremetal-edb-ra.json
  elif [ "${REF_ARCHITECTURE}" == "EDB-RA-3" ]; then
    cp ./baremetal-edb-ra-3.json baremetal-edb-ra.json
  fi
fi

if [ "${PG_TYPE}" != "PG" ] && [ "${PG_TYPE}" != "EPAS" ]; then
  echo "Type must be PG or EPAS"
  usage
  exit 1;
fi

if [[ "${PG_VERSION}" -lt 10 || "${PG_VERSION}" -gt 14 ]]; then
  echo "Version must be 10, 11, 12, 13 or 14"
  usage
  exit 1;
fi

if [ -z "${PROJECT_NAME}" ]; then
  echo "Enter project name"
  usage
  exit 1;
fi

if [ -z "${user}" ]; then
  echo ""
  echo "Export user variable with EDB Repo user. Ex:"
  echo "export user=<user_name>"
  echo ""
  #usage
  exit 1;
fi

if [ -z "${password}" ]; then
  echo ""
  echo "Export password variable with EDB Repo password. Ex:"
  echo "export password=<password>"
  echo ""
  #usage
  exit 1;
fi

start=$SECONDS
. ./scripts/delete_ssh_local_keys.sh
. ./scripts/add_ssh_local_keys.sh

# Deploy test project
edb-deployment baremetal remove ${PROJECT_NAME}
edb-deployment baremetal configure -K ./.vagrant/machines/pg1/vmware_desktop/private_key \
                                   -a ${REF_ARCHITECTURE} \
                                   -u "${user}:${password}" \
                                   -t ${PG_TYPE} \
                                   -v ${PG_VERSION} \
                                   -s ./baremetal-edb-ra.json \
                                   ${PROJECT_NAME}
PWD=$(pwd)
edb-deployment baremetal deploy -P ${PWD}/custom_config.yaml ${PROJECT_NAME}
edb-deployment baremetal passwords ${PROJECT_NAME}
# Redeploy without rebuild all platform
#edb-deployment baremetal deploy -P ${PWD}/custom_config.yaml -S -n ${PROJECT_NAME}

end=$SECONDS
echo "****************************"
echo "*** Deployment finished. ***"
echo "****************************"
echo "Duration: $((end-start)) seconds."

