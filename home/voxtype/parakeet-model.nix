{ fetchurl, linkFarm }:

let
  name = "parakeet-tdt-0.6b-v2";

  modelFile =
    upstreamName: hash:
    fetchurl {
      url = "https://huggingface.co/istupakov/${name}-onnx/resolve/main/${upstreamName}";
      inherit hash;
    };
in
linkFarm name {
  "config.json" = modelFile "config.json" "sha256-ZmkDx2uXmMrywhCv1PbNYLCKjb+YAOyNejvA0hSKxGY=";
  "decoder_joint-model.onnx" =
    modelFile "decoder_joint-model.int8.onnx" "sha256-pEn0ms1ol51BhlHdLctzfMDxvwIl4AninuMmNU7b99M=";
  "encoder-model.onnx" =
    modelFile "encoder-model.int8.onnx" "sha256-PgWB/aarhDiItR5W1+54ttW8MjfsETrx9zLR1ShqoVU=";
  "nemo128.onnx" = modelFile "nemo128.onnx" "sha256-qf3hSG6/zAjzKNda1GEMZ4Nf6ljHO6V+Mgmm9s8Bnp8=";
  "vocab.txt" = modelFile "vocab.txt" "sha256-7BgrcN1CETr/bFNyx1ysWMlSRD6yIyL1e71/U5d9SX0=";
}
