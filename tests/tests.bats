#!/usr/bin/env bats

# ---- helper ----
run_in_bashrc() {
    HOME="$BATS_TEST_TMPDIR/home" \
    bash -ic "source scripts/bashrc; $1"
}

# ---- tests ----

@test "bashrc loads" {
    run bash -ic 'source scripts/bashrc'
    [ "$status" -eq 0 ]
}

@test "rm moves file to trash" {
    mkdir -p "$BATS_TEST_TMPDIR/home"

    run run_in_bashrc '
        touch test.txt
        rm test.txt

		[[ ! -f test.txt ]] || exit 1
		[[ -f "$HOME/.trash/test.txt" ]] || exit 1
    '

    [ "$status" -eq 0 ]
}
