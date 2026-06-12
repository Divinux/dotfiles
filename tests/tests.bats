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

        # check file exists in trash with timestamp suffix
        shopt -s nullglob
        files=( "$HOME/.trash/test.txt."* )

        [[ ${#files[@]} -gt 0 ]] || exit 1
    '

    [ "$status" -eq 0 ]
}

@test "bu creates timestamped backup file" {
    mkdir -p "$BATS_TEST_TMPDIR/work"

    run run_in_bashrc '
        cd "$BATS_TEST_TMPDIR/work"
        echo "hello" > test.txt
        bu test.txt

        shopt -s nullglob
        files=( test.txt-*.bu )

        [[ ${#files[@]} -ge 1 ]] || exit 1
        [[ -f "${files[0]}" ]] || exit 1
    '

    [ "$status" -eq 0 ]
}