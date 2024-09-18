# tmux-pane-marks

An attempt to imitate vim marks in tmux.

<img alt="demo" src="https://github.com/jmsdrh/tmux-pane-marks/assets/27100342/10d0b607-cf61-4148-b5f9-91deac7ebe14" />


# Usage

## Mark Pane

Mark a pane with `prefix + key`. This `prefix` is different from your `tmux prefix` and is used for marks only.  
The default `prefix` is <kbd>ALT</kbd>+<kbd>m</kbd>  
Check [configuration](#configuration) for how to customize the prefix


## Jump To Pane

<kbd>ALT</kbd>+<kbd>key</kbd> navigates to the pane marked by <kbd>key</kbd>. In addition you can set a `jump prefix` and navigate with `prefix + key`


# Installation

## Using [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

Add the following to your list of TPM plugins in `.tmux.conf`:

```
set -g @plugin 'jmsdrh/tmux-pane-marks'
```

Hit <kbd>prefix</kbd> + <kbd>I</kbd> to fetch and source the plugin. You should now be able to use
the plugin!

## Manual

Clone the repo:

```
➜ git clone https://github.com/jmsdrh/tmux-pane-marks ~/.tmux/plugins/tmux-pane-marks
```

Source it in your `.tmux.conf`:

```
run-shell ~/.tmux/plugins/tmux-pane-marks/tmux-pane-marks.tmux
```

Reload TMUX conf by running:

```
➜ tmux source-file ~/.tmux.conf
```


# Configuration

**NB: Any options below must be set before sourcing the plugin**

### Set Mark Keys

As to not conflict with other key bindings in tmux or TUIs, the keys that can be used for marks must be specified.  
Set the option `@tmux_pane_marks_keys` to specify the keys.

**Example:**

Make <kbd>a</kbd><kbd>s</kbd><kbd>d</kbd><kbd>f</kbd><kbd>g</kbd> available as keys to be used as marks.

```bash
set -g @tmux_pane_marks_keys 'asdfg'
```

A full config with [TPM](https://github.com/tmux-plugins/tpm) might look something like this:

```bash
#
# some other  configurations
#

# make asdfgqwerty available as keys to be used for marks.
set -g @tmux_pane_marks_keys 'asdfgqwerty'

#
# some other  configurations
#

# List of plugins for TMUX plugin manager
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'jmsdrh/tmux-pane-marks'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

A full config for a manual install might look something like this:

```bash
#
# some other  configurations
#

# make asdfgqwerty available as keys to be used as marks.
set -g @tmux_pane_marks_keys 'asdfgqwerty'

#
# some other  configurations
#

run-shell ~/.tmux/plugins/tmux-pane-marks/tmux-pane-marks.tmux
```


### Customize the `prefix` used to create marks

Set the option `@tmux_pane_marks_prefix`. Default is <kbd>ALT</kbd>+<kbd>m</kbd>

**Examples:**

Make <kbd>CTRL</kbd>+<kbd>h</kbd> the prefix. `CTRL-h + p` marks the current pane with `p`

```bash
set -g @tmux_pane_marks_prefix 'C-h'
```

Make <kbd>ALT</kbd>+<kbd>s</kbd> the prefix. `ALT-s + p` marks the current pane with `p`

```bash
set -g @tmux_pane_marks_prefix 'M-s'
```


### Customize `modifier key` used to jump to marks

Set the option `@tmux_pane_marks_jumps_mod `. Default is <kbd>ALT</kbd>

**Example:**

Make <kbd>CTRL</kbd> the modifier. `CTRL + p` jumps to pane marked `p`

```bash
set -g @tmux_pane_marks_jumps_mod 'C'
```


### Add `prefix` for jumping to marks

Set the option `@tmux_pane_marks_jumps_prefix`. No default set.
If this option is set then it is used to jump to marks instead of `modifier key`
It scopes all jumps to any prefix key combination chosen

**Example:**

Make <kbd>ALT</kbd>+<kbd>n</kbd> prefix for jumps.  `ALT-n + p` jumps to pane marked `p`

```bash
set -g @tmux_pane_marks_jumps_prefix 'M-n'
```


### Add `previous mark key` for jumping to last active mark

Set the option `@tmux_pane_marks_alternate_mark_key`. No default set.

**Example:**

Make <kbd>;</kbd> a mark for previously active marked pane.

```bash
set -g @tmux_pane_marks_alternate_mark_key '\;'
```
