test:
	bats compression.bats

create:
	mkdir -p .hidden/foxtrot/parent/subdir
	touch .hidden/foxtrot/parent/one
	touch .hidden/foxtrot/parent/two
	touch .hidden/foxtrot/parent/three
	touch .hidden/foxtrot/parent/four
	touch .hidden/foxtrot/parent/subdir/once
	touch .hidden/foxtrot/parent/subdir/twice
	touch .hidden/foxtrot/parent/subdir/thrice

compress:
	cd .hidden/foxtrot/parent && zip -FS -r ../../output-shallow.zip ./**
	cd .hidden/foxtrot && zip -FS -r ../output.zip ./**

remove:
	rm -rv .hidden/foxtrot
	rm -rv .hidden/golf
