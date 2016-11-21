#!/usr/bin/env bash

set -euo pipefail

. patchfile

function show_usage() {
  cat <<EOF
Usage: $(basename "$0") [-b|--baseline] [<basedir>]"

Create a new patchwork under <basedir>, based on the patchfile in the current
working directory. <basedir> is assumed to be the current working directory by
default.

If -b or --baseline is specified, don't apply the patch in PATCHNAME, only
apply the patches in BASEPATCHES. This is useful for generating a patch.
EOF
}

cwd="$(pwd)"
baseline=
basedir="$(pwd)"
if [ "$#" -gt 0 ] ; then
  while [ "$#" -gt 0 ]; do
    case "$1" in
    -h | --help )
      show_usage
      exit 0
      ;;
    -b | --baseline )
      baseline=1
      shift
      ;;
    * )
      if [ "$#" -gt 1 ] ; then
        show_usage
        exit 1
      fi
      basedir=$1
      break
      ;;
    esac
  done
fi

if [ -n "${BASEPATCHES}" ] ; then
  for ((i=0; i<${#BASEPATCHES[@]}; i++));
  do
    BASEPATCHES[$i]=$(echo "${BASEPATCHES[$i]}" | perl -pe "s/$/.patch/")
  done
fi

if [ -n "${PATCHNAME}" ] ; then
  PATCHNAME="${PATCHNAME}.patch"
fi

basename="$(echo "${HTTPS_REMOTE}" | perl -pe 's/.*[\/:](.*?).git/\1/')"
if [ -z "$basename" ]; then
  echo "Couldn't resolve remote basename :-/"
  exit 1
fi
patchworkdir="${basedir}/${basename}"

if [ -d "${patchworkdir}" ]; then
  read -p "Overwrite ${patchworkdir}? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    rm -rf "${patchworkdir}"
  else
    echo "As you wish, nothing left for me to do here."
    exit 0
  fi
fi

mkdir "${patchworkdir}"
git clone "${HTTPS_REMOTE}" "${patchworkdir}"
(cd "${patchworkdir}" && git checkout "tags/${BASETAG}" -b "${BASETAG}")

rm -rf "${patchworkdir}/.git" # Just so no one tries to push this to master.

cd "${basedir}"
if [ -n "${BASEPATCHES}" ] ; then
  for ((i=0; i<${#BASEPATCHES[@]}; i++));
  do
    patch="${BASEPATCHES[$i]}"
    echo "Applying ${patch}.."
    patch -p1 < "${cwd}/${patch}"
  done
fi

if [ -z "${baseline}" ] && [ -n "${PATCHNAME}" ] ; then
  echo "Applying ${PATCHNAME}.."
  patch -p1 < "${cwd}/${PATCHNAME}"
fi
