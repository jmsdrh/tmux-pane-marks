#!/usr/bin/env bash

get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"

	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

MARKS_TABLE="tmux_pane_marks_marks_table"

create_marks_table() {
	local marks_prefix=$(get_tmux_option @tmux_pane_marks_prefix "M-m")

	tmux bind -T root "$marks_prefix" switch-client -T "$MARKS_TABLE" >/dev/null 2>&1
}

create_mark() {
	local key=$1
	local marked_pane="@tmux_pane_marks_key_$key"

	tmux bind -T $MARKS_TABLE $key run "tmux set -g '$marked_pane' #{pane_id}" >/dev/null 2>&1
}

JUMPS_TABLE="tmux_pane_marks_jumps_table"
JUMPS_PREFIX=$(get_tmux_option @tmux_pane_marks_jumps_prefix "")

create_jumps_table() {
	if test -n "$JUMPS_PREFIX"; then
		tmux bind -T root "$JUMPS_PREFIX" switch-client -T "$JUMPS_TABLE" >/dev/null 2>&1
	fi
}

jump_to_mark() {
	local key=$1
	local jumps_mod=$(get_tmux_option @tmux_pane_marks_jumps_mod "M")
	local marked_pane="@tmux_pane_marks_key_$key"
	local pane_present="\$(tmux lsp -aF'##{pane_id}' -f'##{m:*#{$marked_pane}*,##{pane_id}}' 2>/dev/null)"

	if test -n "$JUMPS_PREFIX"; then
		tmux bind -T "$JUMPS_TABLE" "$key" run "if test -n '$pane_present'; then tmux switch-client -t '#{$marked_pane}' >/dev/null 2>&1; fi"
	else
		tmux bind -n "$jumps_mod-$key" run "if test -n \"$pane_present\"; then tmux switch-client -t '#{$marked_pane}' >/dev/null 2>&1; fi"
	fi
}

keys_option_is_set() {
	local keys_option=$(get_tmux_option @tmux_pane_marks_keys "")

	if test -n "$keys_option"; then
		return 0
	fi
	return 1
}

create_keybindings() {
	local keys_option=$(get_tmux_option @tmux_pane_marks_keys "")

	if test -n "$keys_option"; then
		local keys=$(echo "$keys_option" | grep -o .)
	fi

	if test -n "$keys"; then
		echo "$keys" | while read key; do
			create_mark $key
			jump_to_mark $key
		done
	fi
}

main() {
	if keys_option_is_set; then
		create_keybindings
		create_marks_table
		create_jumps_table
	fi
}
main
