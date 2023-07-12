#!/usr/bin/bash
# Get the list of plugins assigned to the @vinceaggrippino-plugins user option
function get_plugins() {
    echo "$(tmux start-server \; show-options -gqv @vinceaggrippino-plugins)"
}

# Expect the plugins subdirectory to be located in the same place as this script
tmux_path="$(dirname $(readlink -f ${BASH_SOURCE[0]:-$0}))/plugins"
cd "$tmux_path"

# Initialize tmux plugins
for plugin in $(get_plugins); do
    # If the plugin directory does not exist show a message and continue
    if [[ ! -d "$plugin" ]]; then
        echo "\"$plugin\" - directory not found in $tmux_path"
        continue
    fi

    # Following the example set by Tmux Plugin Manager, this runs files with a
    # .tmux extension and redirects all output to null
    for tmux_file in ${plugin}/*.tmux; do
        # If the tmux file is not executable, skip it
        if [[ ! -x "$tmux_file" ]]; then
        echo "$tmux_file exists, but it is not executable"
        continue
    fi

    $tmux_file >/dev/null 2>&1
  done
done

