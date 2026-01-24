{pkgs, stdenv, fetchFromGitHub }:
{
  hanabi = stdenv.mkDerivation rec {
    pname = "gnome-ext-hanabi";
    version = "";
    dontBuild = false;
    nativeBuildInputs = with pkgs; [
      meson
      ninja
      glib
      nodejs
      wrapGAppsHook4
      appstream-glib
      gobject-introspection
      shared-mime-info
    ];

    buildInputs = with pkgs; [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    clapper
    gjs
    gtk4
    wayland
    wayland-protocols
    ];
    dontWrapGApps = true;
    
    postPatch = ''
      patchShebangs build-aux/meson-postinstall.sh 
    '';

    postFixup = ''
      wrapGApp "$out/share/gnome-shell/extensions/hanabi-extension@jeffshee.github.io/renderer/renderer.js"
      ln -s "$out/share/gsettings-schemas/gnome-ext-hanabi-/glib-2.0/schemas" "$out/share/gnome-shell/extensions/hanabi-extension@jeffshee.github.io/schemas"

    '';


    src = fetchFromGitHub {
      owner = "jeffshee";
      repo = "gnome-ext-hanabi";
      rev = "4d04eea04f60c760bfaa31abaec1844bc616579e";
      sha256 = "sha256-ntR82Z7PmcgBtOSHlIYHz558viGyTyitceLxeQqt/9k=";
    };
  };
}
