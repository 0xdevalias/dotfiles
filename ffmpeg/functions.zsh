# ffmpeg-* INPUT [OUTPUT] [CRF]
#
# When OUTPUT is omitted, use the input basename with an .mp4 extension.
# If that would overwrite the input or another file, add the helper variant:
#   video.mov -> video.mp4
#   video.mp4 -> video.x264.mp4
#
# Existing explicit outputs are always refused. If both automatic output names
# conflict, the helper exits without running ffmpeg.
#
# Input/output:
#   -n                   Refuse to overwrite an existing output.
#   -i INPUT             Input file.
#
# Video:
#   -map 0:v:0           Use the first video stream only.
#   -c:v libx264/libx265 Select the video encoder.
#   -preset slow         Better compression, slower encode.
#   -crf N               Quality setting. Lower = better/larger.
#   -pix_fmt yuv420p     Better player/device compatibility.
#
# Audio:
#   -map 0:a?            Include audio if present; don't fail if absent.
#   -c:a aac             Encode audio as AAC.
#   -b:a 160k            Set the audio bitrate.
#   -an                  Silent variants only: disable audio entirely.
#
# MP4 container:
#   -tag:v hvc1          Improve Apple HEVC compatibility (x265 only).
#   -movflags +faststart Put MP4 metadata first for streaming/web playback.
#
# Usual CRF ranges:
#   H.264/x264: 18-22, default here 20.
#   H.265/x265: 22-28, default here 24.

_ffmpeg_prepare_output() {
  local input=$1
  local explicit_output=$2
  local variant=$3

  if [[ ! -f "$input" ]]; then
    print -u2 -- "Error: input '$input' is not a file."
    return 1
  fi

  # -n checks for a non-empty explicit output.
  # -e covers existing paths; -L also catches dangling symlinks.
  if [[ -n "$explicit_output" ]]; then
    if [[ -e "$explicit_output" || -L "$explicit_output" ]]; then
      print -u2 -- "Error: output '$explicit_output' already exists; refusing to overwrite it."
      return 1
    fi

    print -r -- "$explicit_output"
    return 0
  fi

  local output="${input:r}.mp4"
  if [[ ! -e "$output" && ! -L "$output" ]]; then
    print -r -- "$output"
    return 0
  fi

  local fallback="${input:r}.${variant}.mp4"
  if [[ -e "$fallback" || -L "$fallback" ]]; then
    print -u2 -- "Error: outputs '$output' and '$fallback' already exist; refusing to overwrite them."
    return 1
  fi

  print -r -- "$fallback"
}

# H.264/x264 MP4 with AAC audio.
ffmpeg-x264() {
  local output="$(_ffmpeg_prepare_output "$1" "${2-}" x264)"
  [[ -n "$output" ]] || return 1

  ffmpeg \
    -n \
    -i "$1" \
    -map 0:v:0 \
    -c:v libx264 \
    -preset slow -crf "${3:-20}" \
    -pix_fmt yuv420p \
    -map '0:a?' \
    -c:a aac -b:a 160k \
    -movflags +faststart \
    "$output"
}

# H.264/x264 MP4, no audio.
ffmpeg-x264-silent() {
  local output="$(_ffmpeg_prepare_output "$1" "${2-}" x264-silent)"
  [[ -n "$output" ]] || return 1

  ffmpeg \
    -n \
    -i "$1" \
    -map 0:v:0 \
    -c:v libx264 \
    -preset slow -crf "${3:-20}" \
    -pix_fmt yuv420p \
    -an \
    -movflags +faststart \
    "$output"
}

# H.265/x265 MP4 with AAC audio.
ffmpeg-x265() {
  local output="$(_ffmpeg_prepare_output "$1" "${2-}" x265)"
  [[ -n "$output" ]] || return 1

  ffmpeg \
    -n \
    -i "$1" \
    -map 0:v:0 \
    -c:v libx265 \
    -preset slow -crf "${3:-24}" \
    -pix_fmt yuv420p \
    -map '0:a?' \
    -c:a aac -b:a 160k \
    -tag:v hvc1 \
    -movflags +faststart \
    "$output"
}

# H.265/x265 MP4, no audio.
ffmpeg-x265-silent() {
  local output="$(_ffmpeg_prepare_output "$1" "${2-}" x265-silent)"
  [[ -n "$output" ]] || return 1

  ffmpeg \
    -n \
    -i "$1" \
    -map 0:v:0 \
    -c:v libx265 \
    -preset slow -crf "${3:-24}" \
    -pix_fmt yuv420p \
    -an \
    -tag:v hvc1 \
    -movflags +faststart \
    "$output"
}
