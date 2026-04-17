# ==========================================
# tool environment
# ==========================================
# interactive tool preferences.

export MANPAGER="sh -c 'sed -u -e \"s/\x1B\[[0-9;]*m//g; s/.\x08//g\" | bat -l man -p --paging=always --pager \"less -R -i --incsearch\"'"
export LESSHISTFILE=-
