#!/usr/bin/env bash

set -euo pipefail

. patchfile

script_dir="$(dirname "$(readlink -f "${0}")")"

if [ $# -eq 0 ]; then
  exec tmpdir "$0" %%TMPDIR
fi

function show_usage() {
  cat <<EOF
Usage: $(basename "$0") [<tmpdir>]"

Generate a new baseline patchwork under <tmpdir>, based on the patchfile in the
working directory. Compare that patchwork to the patchwork under the working directory
and generate a fancy patch (all timestamps set to epoch, all paths to <tmpdir>
replaced by /home/archimedes).  The patch is written to \${PATCHNAME}.patch,
where PATCHNAME is set in the patchfile.

NB! This relies on the assumption that <tmpdir> is in /tmp/ and starts with
kudos, e.g. <tmpdir> is /tmp/kudos123. The tmpdir utility can help you get
there.
EOF
}

if [ "$#" -ne 1 ] ; then
  show_usage
  exit 1
fi

basename="$(echo "${HTTPS_REMOTE}" | perl -pe 's/.*[\/:](.*?).git/\1/')"
if [ -z "$basename" ]; then
  echo "Couldn't resolve remote basename :-/"
  exit 1
fi

basedir=$1
PATCHNAME="${PATCHNAME}.patch"

${script_dir}/gen-patchwork.sh --baseline "${basedir}"

function clean() {
  if [ -f "$1/${basename}/Makefile" ]; then
    make -C "$1/${basename}" clean
  fi
}

clean "${basedir}"
clean "."

prefix="(?:\\+{3}|---)"
ts="\\d{4}-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d\\.\\d{9} \\+\\d{4}"
epoch="1970-01-01 00:00:00.000000000 +0000"

set +e

diff -ruN "${basedir}/${basename}/" "./${basename}/" | \
  perl -pe "s/^(${prefix} .+? *)${ts}$/\\1 $epoch/" | \
  perl -pe "s/ \/.*?\/${basename}\// a\/${basename}\//" | \
  perl -pe "s/ \.\/${basename}\// b\/${basename}\//" \
  > "${PATCHNAME}"

diffcode=$?

set -e

if [ "${diffcode}" -ne 1 ]; then
  if [ "${diffcode}" -eq 0 ]; then
    echo "Looks like you made no changes!"
  else
    cat <<EOF

Oh-oh.. diff pipeline returned ${diffcode}..

This is likely because you have some binary/metadata files lying
around in your kudos.

Take a look at ${PATCHNAME}, it should've been produced anyway.
EOF
  fi
  exit ${diffcode}
else
  exit 0
fi
