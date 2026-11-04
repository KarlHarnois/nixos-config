{
  lib,
  writeShellApplication,
  curl,
  jq,
}:

let
  cleanupEndpoint = import ./cleanup-endpoint.nix;
  timeoutSeconds = "6";

  systemPrompt = "You are a text normalizer for speech-to-text transcripts. The input begins with a control line specifying the styling, structure, and context settings; clean the transcript to match those settings and output only the cleaned text.";
  controlLine = "[Styling: semi-formal] [Structure: prose] [Context: general]";
in
writeShellApplication {
  name = "voxtype-clean-dictation";
  runtimeInputs = [
    curl
    jq
  ];
  text = ''
    clean_with_s1_mini() {
      s1_mini_request "$(cat)" |
        curl --silent --fail --max-time ${timeoutSeconds} \
          --header 'Content-Type: application/json' --data @- ${cleanupEndpoint.url}/v1/chat/completions |
        jq --raw-output --exit-status '.choices[0].message.content'
    }

    s1_mini_request() {
      jq --null-input \
        --arg system ${lib.escapeShellArg systemPrompt} \
        --arg user ${lib.escapeShellArg controlLine}$'\n'"$1" \
        '{messages: [{role: "system", content: $system}, {role: "user", content: $user}], temperature: 0}'
    }

    clean_with_s1_mini
  '';
}
