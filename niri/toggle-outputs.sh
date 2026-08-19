#!/usr/bin/env bash
# Cycles output modes:
#   1. DP-2 ON  / HDMI-A-1 ON
#   2. DP-2 OFF / HDMI-A-1 ON
#   3. DP-2 ON  / HDMI-A-1 OFF
set -euo pipefail

state=$(niri msg --json outputs | jq -r '
  "\(.["DP-2"].current_mode != null):\(.["HDMI-A-1"].current_mode != null)"')

case "$state" in
  true:true)   # both on -> DP-2 off, HDMI on
    niri msg output DP-2 off
    niri msg output HDMI-A-1 on
    ;;
  false:true)  # HDMI only -> DP-2 on, HDMI off
    niri msg output DP-2 on
    niri msg output HDMI-A-1 off
    ;;
  *)           # DP-2 only (or anything else) -> both on
    niri msg output DP-2 on
    niri msg output HDMI-A-1 on
    ;;
esac
