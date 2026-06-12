#!/usr/bin/env bats
bats_require_minimum_version 1.5.0

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

@test "fb returns binary name on ubuntu (dpkg)" {
    run run_in_bashrc '
        dpkg() {
            echo "/usr/bin/bats"
            echo "/usr/share/doc/bats"
        }
        export -f dpkg

        fb bats
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"bats"* ]]
}

@test "fbp returns binary path on ubuntu (dpkg)" {
    run run_in_bashrc '
        dpkg() {
            echo "/usr/bin/bats"
            echo "/usr/share/doc/bats"
        }
        export -f dpkg
        fbp bats
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"/usr/bin/bats"* ]]
}

@test "whoowns returns package ownership info on ubuntu" {
    run run_in_bashrc '
        whoowns bats
    '

    [ "$status" -eq 0 ]

    # must contain bats package in output
    [[ "$output" == *"bats:"* ]]

    # must mention a real file path
    [[ "$output" == *"/usr/"* ]]
}

@test "listfiles returns package file list on ubuntu" {
    run run_in_bashrc '

        listfiles bats
    '

    [ "$status" -eq 0 ]
    [[ -n "$output" ]]

    # should contain at least one known bats path fragment
    [[ "$output" == *"bats"* ]]
    [[ "$output" == *"/usr/"* || "$output" == *"/lib/"* ]]
}

@test "pkginfo returns package metadata on ubuntu" {
    run run_in_bashrc '

        pkginfo bats
    '

    [ "$status" -eq 0 ]

    # core fields that should always exist
    [[ "$output" == *"Package: bats"* ]]
    [[ "$output" == *"Version:"* ]]
    [[ "$output" == *"Description:"* ]]
}

@test "packagereason shows install metadata on ubuntu" {
    run run_in_bashrc '

        packagereason bats
    '

    [ "$status" -eq 0 ]

    # core apt metadata section exists
    [[ "$output" == *"==> apt show bats"* ]]
    [[ "$output" == *"Package: bats"* ]]

    # install reason section exists
    [[ "$output" == *"Install Reason"* ]]
    [[ "$output" == *"Manually installed"* || "$output" == *"dependency"* ]]

    # structural sections exist
    [[ "$output" == *"Install log entry"* ]]
    [[ "$output" == *"Reverse dependencies"* ]]
}

@test "ld runs successfully on ubuntu" {
    run run_in_bashrc '

        ld bats
    '

    [ "$status" -eq 0 ]

    # output may be empty OR non-empty, both valid
    # but must not error or produce stderr failures
}

@test "myip returns a public IP from ipinfo.io" {
    run run_in_bashrc '
        myip
    '

    [ "$status" -eq 0 ]

    # must not be empty
    [[ -n "$output" ]]

    # must not contain curl errors
    [[ "$output" != *"curl"* ]]
    [[ "$output" != *"error"* ]]
}

@test "ex rejects unknown extension" {
    run run_in_bashrc '
        touch test.unknown
        ex test.unknown
    '

    [ "$status" -eq 0 ]

    [[ "$output" == *"cannot be extracted via extract()"* ]]
}

@test "ex handles missing file" {
    run run_in_bashrc '

        ex does_not_exist.zip
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"not a valid file"* ]]
}

@test "ex calls unzip for zip files (mocked)" {
    run run_in_bashrc '
        unzip() {
            echo "unzip called with: $1"
        }
        export -f unzip

        touch test.zip
        ex test.zip
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"unzip called with"* ]]
}

@test "ex routes tar.gz correctly" {
    run run_in_bashrc '
        tar() {
            echo "tar args: $*"
        }
        export -f tar

        touch test.tar.gz
        ex test.tar.gz
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"tar args"* ]]
}

@test "um handles missing reflector gracefully" {
    run run_in_bashrc '
        sudo() {
            echo "sudo called"
        }

        reflector() {
            sleep 0.2
            echo "reflector called"
        }
        export -f reflector

        um
    '

    [ "$status" -eq 0 ]

    [[ "$output" == *"Finding fastest Arch mirrors"* ]]
    [[ "$output" == *"Mirrorlist updated successfully"* || "$output" == *"Failed"* ]]
}

@test "pstats computes update stats from log (mocked)" {
    run run_in_bashrc '

        # fake pacman log
        cat > "$BATS_TEST_TMPDIR/pacman.log" <<EOF
[ALPM] upgraded bash 5.2
[ALPM] upgraded vim 9.0
[ALPM] upgraded bash 5.2
EOF

        # override log path
        ln -sf "$BATS_TEST_TMPDIR/pacman.log" /tmp/pacman.log
        pstats
    '

    [ "$status" -eq 0 ]

    [[ "$output" == *"Total package updates"* ]]
    [[ "$output" == *"Unique packages updated"* ]]
}

@test "lf lists functions with descriptions" {
    run run_in_bashrc '
        mkdir -p "$HOME"
        cp scripts/bashrc "$HOME/.bashrc"
        lf
    '

    [ "$status" -eq 0 ]
}

@test "lfa lists functions with descriptions" {
    run run_in_bashrc '
        mkdir -p "$HOME"
        cp scripts/bashrc "$HOME/.bashrc"
        lfa
    '

    [ "$status" -eq 0 ]
}

@test "lo fails gracefully" {
    run run_in_bashrc '
        lo
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"No orphaned packages found!"* ]]
}

@test "ro fails gracefully" {
    run run_in_bashrc '
        ro
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"No orphaned packages to remove!"* ]]
}

@test "li lists manually installed packages on ubuntu" {
    run run_in_bashrc '

        li
    '

    [ "$status" -eq 0 ]

    # Ubuntu branch header
    [[ "$output" == *"Packages installed manually (apt):"* ]]

    # must produce some output
    [[ -n "$output" ]]

    # sanity: should include at least one known system package
    [[ "$output" == *"apt"* || "$output" == *"bash"* || "$output" == *"coreutils"* ]]
}

@test "lid prints package list with descriptions (ubuntu)" {
    run run_in_bashrc '

        lid | head -n 10
    '

    [ "$status" -eq 0 ]

    # must include section header
    [[ "$output" == *"Manually installed packages"* ]]

    # must contain at least one package line (name + desc)
    [[ "$output" =~ [a-zA-Z0-9].*[a-zA-Z0-9] ]]
}

@test "lid creates cache directory" {
    run run_in_bashrc '

        lid | head -n 10 >/dev/null
        echo "${XDG_CACHE_HOME:-$HOME/.cache}/lid"
    '

    [ "$status" -eq 0 ]

    [[ "$output" == *".cache/lid"* ]]
}

@test "lid caches package descriptions" {
    run run_in_bashrc '
        cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/lid"
        rm -rf "$cache_dir"

        lid | head -n 10 >/dev/null

        files=$(find "$cache_dir" -type f)
        echo "$files" | wc -l
    '

    [ "$status" -eq 0 ]

    # ensure at least some cache files exist
    [[ -n "$output" ]]
    [[ "$output" != "0" ]]
}

@test "installdeps runs safely (ubuntu)" {
    run run_in_bashrc '
        # fake package list for test
        packagelist="bash coreutils nonexistentpkg"
		
        installdeps
    '

    [ "$status" -eq 0 ]

    # must show main flow messages
    [[ "$output" == *"Installing dependencies"* ]]
    [[ "$output" == *"Dependency installation complete"* ]]

    # must not crash on unknown package
    [[ "$output" != *"command not found"* ]]
}

@test "checkreboot detects reboot-required pkgs (mocked)" {
    FAKE_BIN="$BATS_TEST_TMPDIR/fakebin"
    mkdir -p "$FAKE_BIN"

    cat > "$FAKE_BIN/pacman" <<'EOF'
#!/bin/bash
exit 1
EOF
    chmod +x "$FAKE_BIN/pacman"

    cat > "$FAKE_BIN/dpkg" <<'EOF'
#!/bin/bash
exit 0
EOF
    chmod +x "$FAKE_BIN/dpkg"

    cat > "$FAKE_BIN/uname" <<'EOF'
#!/bin/bash
echo "6.8.0-50-generic"
EOF
    chmod +x "$FAKE_BIN/uname"

    cat > "$FAKE_BIN/grep" <<'EOF'
#!/bin/bash
echo "linux-image-6.8.0"
exit 0
EOF
    chmod +x "$FAKE_BIN/grep"

    run env PATH="$FAKE_BIN:$PATH" bash -ic '
        source scripts/bashrc
        checkreboot
    '
    [ "$status" -eq 1 ]
}

@test "checkreboot detects no affected libraries" {
    FAKE_BIN="$BATS_TEST_TMPDIR/fakebin"
    mkdir -p "$FAKE_BIN"

    # everything disabled
    for cmd in pacman dpkg grep uname; do
        cat > "$FAKE_BIN/$cmd" <<'EOF'
#!/bin/bash
exit 1
EOF
        chmod +x "$FAKE_BIN/$cmd"
    done

    run env PATH="$FAKE_BIN:$PATH" bash -ic '
        source scripts/bashrc
        checkreboot
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"No reboot is required"* ]]
}

@test "rre requires host" {
    run run_in_bashrc '
        rre
    '

    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: rre"* ]]
}

@test "rre aborts when ssh fails" {
    run run_in_bashrc '
        ssh() { return 1; }
        notify-send() { echo "notify:$*"; }

        rre testhost
    '

    [ "$status" -eq 1 ]
    [[ "$output" == *"testhost unreachable. Aborting."* ]]
}

@test "rre succeeds when host returns" {
    run run_in_bashrc '
        ssh() { return 0; }
        notify-send() { :; }

        count=0
        ping() {
            ((count++))

            case "$count" in
                1|2) return 0 ;;  # online
                3)   return 1 ;;  # offline
                4|5) return 1 ;;  # still booting
                6)   return 0 ;;  # back online
            esac
        }

        rre testhost
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"testhost is back online!"* ]]
}

@test "rre times out" {
    run run_in_bashrc '
        ssh() { return 0; }
        ping() { return 1; }
        notify-send() { :; }

        counter=/tmp/rre-counter-$$
        echo 0 > "$counter"

        date() {
            n=$(cat "$counter")
            n=$((n + 10))
            echo "$n" > "$counter"
            echo "$n"
        }

        sleep() { :; }

        rre testhost 5
    '

    [ "$status" -eq 1 ]
    [[ "$output" == *"Timeout waiting for testhost"* ]]
}

@test "lastupdate creates timestamp file on first run" {
    HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"

    run run_in_bashrc '
        lastupdate
    '

    [ "$status" -eq 0 ]
    [ -f "$HOME/.last_update" ]
}

@test "lastupdate reports missing timestamp" {
    HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"

    run run_in_bashrc '
        lastupdate
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"No previous update timestamp found"* ]]
}

@test "lastupdate shows elapsed time" {
    HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"

    run run_in_bashrc '

        echo 1000000 > "$HOME/.last_update"

        date() {
            if [[ "$1" == "+%s" ]]; then
                echo 1093780
            else
                /bin/date "$@"
            fi
        }

        lastupdate
    '

    [ "$status" -eq 0 ]

    [[ "$output" == *"1d"* ]]
    [[ "$output" == *"ago"* ]]
}

@test "gacp handles commit failure" {
    repo="$BATS_TEST_TMPDIR/repo"
    mkdir -p "$repo"
    cd "$repo"

    git init -b main >/dev/null
    git config user.email "test@example.com"
    git config user.name "test"

    touch file.txt

    git() {
        if [[ "$1" == "commit" ]]; then
            return 1
        fi
        command git "$@"
    }

    export -f git

    run -127 run_in_bashrc "
        cd '$repo'
        gacp 'fail commit'
    "

    [ "$status" -ne 0 ]
	[ "$status" -eq 127 ]
}

@test "grbp rejects invalid input" {
    run run_in_bashrc '
        grbp 0
    '

    [ "$status" -ne 0 ]
    [[ "$output" == *"Usage"* ]]
}

@test "grbp runs rebase and force push" {
    run bash -ic '
        git() {
            echo "git $*"
            return 0
        }
        export -f git

        source scripts/bashrc

        grbp 3
    '

    [ "$status" -eq 0 ]

    [[ "$output" == *"rebase -i HEAD~3"* ]]
    [[ "$output" == *"push --force-with-lease"* ]]
}

@test "colorconvert hex converts to rgb" {
    run run_in_bashrc '
        colorconvert "#ff00aa"
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"255,0,170" ]]
}

@test "colorconvert rgb converts to hex" {
    run run_in_bashrc '
        colorconvert "255,0,170"
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"#ff00aa" ]]
}

@test "colorconvert supports short hex" {
    run run_in_bashrc '
        colorconvert "#abc"
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *","* ]]   # expects rgb output like 170,187,204
}

@test "colorconvert rejects invalid input" {
    run run_in_bashrc '
        colorconvert "notacolor"
    '

    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage"* ]]
}

@test "xkcd filters by search term" {
    run run_in_bashrc '

        XKCD_COLOR_FILE="$BATS_TEST_TMPDIR/colors.txt"
        cat > "$XKCD_COLOR_FILE" <<EOF
light blue #aabbcc
dark blue #112233
red color #ff0000
EOF

        colortext() { echo "$2"; }
        export -f colortext

        xkcd blue
    '

    [ "$status" -eq 0 ]
    [[ "$output" == *"light blue"* ]]
    [[ "$output" == *"dark blue"* ]]
    [[ "$output" != *"red color"* ]]
}

@test "xkcd random mode returns output" {
    run run_in_bashrc '

        XKCD_COLOR_FILE="$BATS_TEST_TMPDIR/colors.txt"
        cat > "$XKCD_COLOR_FILE" <<EOF
a #111111
b #222222
c #333333
d #444444
EOF

        colortext() { echo "$2"; }
        export -f colortext

        xkcd ""
    '

    [ "$status" -eq 0 ]
    [[ -n "$output" ]]
}

@test "checkerrors processes journalctl output" {
    run run_in_bashrc '

        journalctl() {
            echo "boot-$2 warning: something failed"
            echo "boot-$2 info: ok"
        }

        export -f journalctl

        checkerrors
    '

    [ "$status" -eq 0 ]

    [[ "$output" == *"Boot -0"* ]]
    [[ "$output" == *"Boot -1"* ]]
    [[ "$output" == *"failed"* ]]
}

@test "draw_separator prints a separator line" {
    run run_in_bashrc '

        COLUMNS=80
        draw_separator
    '

    [ "$status" -eq 0 ]

    [[ "$output" == *":"* ]]   # timestamp contains :
    [[ -n "$output" ]]
}
