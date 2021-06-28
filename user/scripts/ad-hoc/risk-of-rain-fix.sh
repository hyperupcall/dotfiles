#!/usr/bin/env bash

main() {
	local userData="/storage/vault/rodinia/Steam/userdata/226447983/632360"
	local userProfile="$userData/remote/UserProfiles"

	cat "$userProfile/748d1c3d-02d1-4d90-94fd-5a225aea981c.xml"
}

main "$@"