{ pkgs, ... }:

let
  tesseract = pkgs.tesseract.override { enableLanguages = [ "eng" ]; };

  extractText = pkgs.writeShellApplication {
    name = "extract-text";
    runtimeInputs = [
      pkgs.grimblast
      pkgs.libnotify
      pkgs.wl-clipboard
      tesseract
    ];
    text = ''
      main() {
        local text
        text=$(capture_area | recognize_text)
        [[ -z $text ]] && exit 1
        printf '%s' "$text" | wl-copy
        notify-send "Copied text from selection to clipboard"
      }

      capture_area() {
        grimblast save area -
      }

      recognize_text() {
        tesseract stdin stdout --psm 6 -c preserve_interword_spaces=1
      }

      main
    '';
  };
in
{
  home.packages = [ extractText ];
}
