# shellcheck shell=sh

# overwrite readline unix-word-rubout with XOFF so readline forward-search-history (Control-s) isn't clobbered
stty stop '^W'
