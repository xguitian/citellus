#!/bin/bash

# Copyright (C) 2017  Pablo Iranzo Gómez (Pablo.Iranzo@redhat.com)
# Based on the code of Jean-Francois Saucier (jsaucier@redhat.com)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# description: Checks if OSP12 deployment is using containers and valid sosreport version

# Load common functions
[ -f "${CITELLUS_BASE}/common-functions.sh" ] && . "${CITELLUS_BASE}/common-functions.sh"

exitoudated(){
    echo $"outdated sosreport package ${VERSION}: Containerized deployments require updated release" >&2
    exit $RC_FAILED
}
RELEASE=$(discover_osp_version)
if [[ "${RELEASE}" -ge "12" ]]; then
    # Sosreport with container support is 3.4-9 or later
    is_required_rpm sos

    VERSION=$(is_rpm sos)

    MAJOR=$(echo ${VERSION} | sed -n -r -e 's/^sos.*-([0-9]+).[0-9]+-[0-9]+.*$/\1/p')
    MID=$(echo ${VERSION} | sed -n -r -e 's/^sos.*-[0-9]+.([0-9]+)-[0-9]+.*$/\1/p')
    MINOR=$(echo ${VERSION} | sed -n -r -e 's/^sos.*-[0-9]+.[0-9]+-([0-9]+).*$/\1/p')

    if [[ "${MAJOR}" -ge "3" ]]; then
        if [[ "${MID}" -ge "4" ]]; then
            if [[ "${MINOR}" -lt "9" ]]; then
                exitoudated
            fi
        else
            exitoudated
        fi
    else
        exitoudated
    fi
    exit $RC_OKAY
else
    echo "works only on OSP12 and later" >&2
    exit $RC_SKIPPED
fi