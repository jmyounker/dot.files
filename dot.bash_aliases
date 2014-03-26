
proj() {
    local file
    file=$(~/bin/projtool "$@")
    if [[ -r $file ]]; then
        source $file
    fi
}
