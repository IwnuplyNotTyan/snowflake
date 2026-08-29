{ pkgs, pkgsUnstable, ... }:

let
  mod = "Mod";
in
{
  home.packages = with pkgs; [
    wl-clipboard
    wl-clip-persist
    wtype
    cliphist

    pulseaudio

    swaybg

    xwayland-satellite

    nerd-fonts.iosevka
  ];

  programs.niri = {
    enable = true;
    package = pkgsUnstable.niri;

    settings = {
      prefer-no-csd = true;

      input.keyboard.xkb = {
        layout = "us,ru";
        options = "grp:alt_space_toggle";
      };

      layout = {
        gaps = 6;

        border.enable = false;
        focus-ring.enable = false;

        preset-column-widths = [
          { proportion = 0.5; }
          { proportion = 0.75; }
          { proportion = 1.0; }
        ];
      };

      workspaces = {
        "1" = {};
        "2" = {};
        "3" = {};
        "4" = {};
        "5" = {};
        "6" = {};
        "7" = {};
        "8" = {};
        "9" = {};
        "10" = {};
      };

      spawn-at-startup = [
	  { command = [ "xwayland-satellite" ]; }
	  { command = [ "sh" "-c" "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY" ]; }
	  { command = ["wl-clip-persist" "--clipboard" "both"]; }
	  { command = ["sh" "-c" "wl-paste --type text --watch cliphist store"]; }
	  { command = ["sh" "-c" "wl-paste --type image --watch cliphist store"]; }
	  { command = [ "walpick" ]; }
	  { command = [ "nixGLIntel" "vicinae" "server" ]; }
	  { command = [ "eww" "daemon" ]; }
	  { command = [ "notif-listener" ]; }
	];

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 13.0;
            top-right = 13.0;
            bottom-left = 13.0;
            bottom-right = 13.0;
          };
          clip-to-geometry = true;
        }
        {
          matches = [ { app-id = "^vicinae$"; } ];
          open-floating = true;
          default-column-width = { fixed = 800; };
          default-window-height = { fixed = 600; };
        }
      ];

      binds = {
        #"${mod}+Shift+Slash".action.show-hotkey-overlay = [ ];

        #"${mod}+Return".action.spawn = [ "kitty" ];
        "${mod}+q".action.close-window = [ ];

	"${mod}+Alt+x".action.spawn = [ "warpd" "--hint" ];

        "${mod}+space".action.spawn = [ "vicinae" "open" ];

        "${mod}+l".action.focus-column-left = [ ];
        "${mod}+k".action.focus-window-down = [ ];
        "${mod}+j".action.focus-window-up = [ ];
        "${mod}+h".action.focus-column-right = [ ];

        "${mod}+Left".action.focus-column-left = [ ];
        "${mod}+Down".action.focus-window-down = [ ];
        "${mod}+Up".action.focus-window-up = [ ];
        "${mod}+Right".action.focus-column-right = [ ];

        "${mod}+Shift+l".action.move-column-left = [ ];
        "${mod}+Shift+k".action.move-window-down = [ ];
        "${mod}+Shift+j".action.move-window-up = [ ];
        "${mod}+Shift+h".action.move-column-right = [ ];

        "${mod}+Shift+Left".action.move-column-left = [ ];
        "${mod}+Shift+Down".action.move-window-down = [ ];
        "${mod}+Shift+Up".action.move-window-up = [ ];
        "${mod}+Shift+Right".action.move-column-right = [ ];

        "${mod}+y".action.consume-window-into-column = [ ];
        "${mod}+u".action.expel-window-from-column = [ ];

        "${mod}+f".action.fullscreen-window = [ ];

        "${mod}+Shift+space".action.toggle-window-floating = [ ];
        "${mod}+d".action.switch-focus-between-floating-and-tiling = [ ];
        "${mod}+a".action.toggle-column-tabbed-display = [ ];

        "${mod}+1".action.focus-workspace = "1";
        "${mod}+2".action.focus-workspace = "2";
        "${mod}+3".action.focus-workspace = "3";
        "${mod}+4".action.focus-workspace = "4";
        "${mod}+5".action.focus-workspace = "5";
        "${mod}+6".action.focus-workspace = "6";
        "${mod}+7".action.focus-workspace = "7";
        "${mod}+8".action.focus-workspace = "8";
        "${mod}+9".action.focus-workspace = "9";
        "${mod}+0".action.focus-workspace = "10";

        "${mod}+Shift+1".action.move-window-to-workspace = "1";
        "${mod}+Shift+2".action.move-window-to-workspace = "2";
        "${mod}+Shift+3".action.move-window-to-workspace = "3";
        "${mod}+Shift+4".action.move-window-to-workspace = "4";
        "${mod}+Shift+5".action.move-window-to-workspace = "5";
        "${mod}+Shift+6".action.move-window-to-workspace = "6";
        "${mod}+Shift+7".action.move-window-to-workspace = "7";
        "${mod}+Shift+8".action.move-window-to-workspace = "8";
        "${mod}+Shift+9".action.move-window-to-workspace = "9";
        "${mod}+Shift+0".action.move-window-to-workspace = "10";

        "${mod}+Shift+e" = {
          hotkey-overlay.title = "Exit niri";
          action.quit = [ ]; # niri shows its own confirmation prompt
        };

        "${mod}+o".action.spawn-sh = "eww open player && sleep 10 && eww close player";

        "${mod}+Ctrl+l".action.set-column-width = "+10%";
        "${mod}+Ctrl+h".action.set-column-width = "-10%";
        "${mod}+Ctrl+k".action.set-window-height = "-10%";
        "${mod}+Ctrl+j".action.set-window-height = "+10%";

        "${mod}+Ctrl+Shift+h".action.set-column-width = "+3%";
        "${mod}+Ctrl+Shift+l".action.set-column-width = "-3%";
        "${mod}+Ctrl+Shift+k".action.set-window-height = "-3%";
        "${mod}+Ctrl+Shift+j".action.set-window-height = "+3%";

        "${mod}+p".action.screenshot-screen = [ ];

        "XF86AudioRaiseVolume".action.spawn-sh = "pactl set-sink-volume @DEFAULT_SINK@ +5% && vol-popup";
        "XF86AudioLowerVolume".action.spawn-sh = "pactl set-sink-volume @DEFAULT_SINK@ -5% && vol-popup";
        "XF86AudioMute".action.spawn-sh = "pactl set-sink-mute @DEFAULT_SINK@ toggle && vol-popup";
        "XF86AudioMicMute".action.spawn-sh = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
      };
    };
  };
}
