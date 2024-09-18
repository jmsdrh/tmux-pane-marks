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
JUMPS_TABLE="tmux_pane_marks_jumps_table"
JUMPS_PREFIX=$(get_tmux_option @tmux_pane_marks_jumps_prefix "")
keys_option=$(get_tmux_option @tmux_pane_marks_keys "")
marks_prefix=$(get_tmux_option @tmux_pane_marks_prefix "M-m")
jumps_mod=$(get_tmux_option @tmux_pane_marks_jumps_mod "M")
alternate_key=$(get_tmux_option @tmux_pane_marks_alternate_mark_key "")

create_marks_table() {
	tmux bind -T root "$marks_prefix" switch-client -T "$MARKS_TABLE" >/dev/null 2>&1
}

create_mark() {
	local key=$1
	local marked_pane="@tmux_pane_marks_key_$key"

	tmux bind -T $MARKS_TABLE $key run "tmux set -s '$marked_pane' #{pane_id} >/dev/null 2>&1; tmux set -s @tmux_pane_marks_key_previous #{@tmux_pane_marks_key_current} >/dev/null 2>&1; tmux set -s @tmux_pane_marks_key_current #{pane_id} >/dev/null 2>&1" >/dev/null 2>&1
}

create_jumps_table() {
	if test -n "$JUMPS_PREFIX"; then
		tmux bind -T root "$JUMPS_PREFIX" switch-client -T "$JUMPS_TABLE" >/dev/null 2>&1
	fi
}

jump_to_mark() {
	local key=$1
	local marked_pane="@tmux_pane_marks_key_$key"

	if test -n "$JUMPS_PREFIX"; then
		tmux bind -T "$JUMPS_TABLE" "$key" run "m_v_pane=\$(tmux lsp -aF'##{pane_id}' -f\"##{m:#{$marked_pane},##{pane_id}}\"); m_c_pane=\$(tmux lsp -aF'##{pane_id}' -f'##{m:#{@tmux_pane_marks_key_current},##{pane_id}}'); sh -c \"if [ -n \\\"\$m_v_pane\\\" ] && [ \\\"\$m_v_pane\\\" != \\\"\$m_c_pane\\\" ]; then tmux set -s @tmux_pane_marks_key_previous \$m_c_pane >/dev/null 2>&1; tmux set -s @tmux_pane_marks_key_current \$m_v_pane >/dev/null 2>&1; tmux switch-client -t \$m_v_pane >/dev/null 2>&1; fi\""
	else
		tmux bind -n "$jumps_mod-$key" run "m_v_pane=\$(tmux lsp -aF'##{pane_id}' -f\"##{m:#{$marked_pane},##{pane_id}}\"); m_c_pane=\$(tmux lsp -aF'##{pane_id}' -f'##{m:#{@tmux_pane_marks_key_current},##{pane_id}}'); sh -c \"if [ -n \\\"\$m_v_pane\\\" ] && [ \\\"\$m_v_pane\\\" != \\\"\$m_c_pane\\\" ]; then tmux set -s @tmux_pane_marks_key_previous \$m_c_pane >/dev/null 2>&1; tmux set -s @tmux_pane_marks_key_current \$m_v_pane >/dev/null 2>&1; tmux switch-client -t \$m_v_pane >/dev/null 2>&1; fi\""
	fi
}

jump_to_previous() {
	if test -n "$JUMPS_PREFIX"; then
		tmux bind -T "$JUMPS_TABLE" "$alternate_key" run "m_v_pane=\$(tmux lsp -aF'##{pane_id}' -f'##{m:#{@tmux_pane_marks_key_previous},##{pane_id}}'); m_c_pane=\$(tmux lsp -aF'##{pane_id}' -f'##{m:#{@tmux_pane_marks_key_current},##{pane_id}}'); sh -c \"if [ -n \\\"\$m_v_pane\\\" ] && [ \\\"\$m_v_pane\\\" != \\\"\$m_c_pane\\\" ]; then tmux set -s @tmux_pane_marks_key_previous \$m_c_pane >/dev/null 2>&1; tmux set -s @tmux_pane_marks_key_current \$m_v_pane >/dev/null 2>&1; tmux switch-client -t \$m_v_pane >/dev/null 2>&1; fi\""
	else
		tmux bind -n "$jumps_mod-$alternate_key" run "m_v_pane=\$(tmux lsp -aF'##{pane_id}' -f'##{m:#{@tmux_pane_marks_key_previous},##{pane_id}}'); m_c_pane=\$(tmux lsp -aF'##{pane_id}' -f'##{m:#{@tmux_pane_marks_key_current},##{pane_id}}'); sh -c \"if [ -n \\\"\$m_v_pane\\\" ] && [ \\\"\$m_v_pane\\\" != \\\"\$m_c_pane\\\" ]; then tmux set -s @tmux_pane_marks_key_previous \$m_c_pane >/dev/null 2>&1; tmux set -s @tmux_pane_marks_key_current \$m_v_pane >/dev/null 2>&1; tmux switch-client -t \$m_v_pane >/dev/null 2>&1; fi\""
	fi
}

create_keybindings() {
	if test -n "$keys_option"; then
		local keys=$(echo "$keys_option" | grep -o .)
	fi

	if test -n "$keys"; then
		echo "$keys" | while read key; do
			create_mark $key
			jump_to_mark $key
		done
	fi

	if test -n "$alternate_key"; then
		jump_to_previous
	fi
}

main() {
	if test -n "$keys_option"; then
		create_keybindings
		create_marks_table
		create_jumps_table
	fi
}
main
