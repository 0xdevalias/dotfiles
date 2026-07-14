# ffmpeg-x264[-silent] INPUT [OUTPUT] [CRF]
# ffmpeg-x265[-silent] INPUT [OUTPUT] [CRF]
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
  local extension=${4:-mp4}

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

  local output="${input:r}.${extension}"
  if [[ ! -e "$output" && ! -L "$output" ]]; then
    print -r -- "$output"
    return 0
  fi

  local fallback="${input:r}.${variant}.${extension}"
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

# MP3 audio using LAME variable-bitrate encoding.
# Quality 0 is best/largest; 9 is lowest/smallest. Approximate averages:
#   0=245k, 1=225k, 2=190k, 3=175k, 4=165k, 5=130k, 6=115k
#   7=100k, 8=85k, 9=65k (consider ABR instead for qualities 7-9)
ffmpeg-mp3() {
  local quality=2

  case "${1-}" in
    -h|--help)
      print -rl -- \
        "Usage: ffmpeg-mp3 [-q QUALITY] INPUT [OUTPUT]" \
        "Convert INPUT to MP3; OUTPUT defaults to the input basename with .mp3." \
        "  -q, --quality  VBR quality 0-9 (default: 2, about 190 kbps)" \
        "  -h, --help     Show this help."
      return
      ;;
    -q|--quality)
      if [[ -z "${2-}" ]]; then
        print -u2 -- "Error: $1 requires a quality from 0 to 9."
        return 1
      fi
      quality=$2
      shift 2
      ;;
  esac

  if (( $# < 1 || $# > 2 )); then
    print -u2 -- "Usage: ffmpeg-mp3 [-q QUALITY] INPUT [OUTPUT]"
    return 1
  fi

  if [[ "$quality" != <0-9> ]]; then
    print -u2 -- "Error: quality must be an integer from 0 to 9."
    return 1
  fi

  local output="$(_ffmpeg_prepare_output "$1" "${2-}" converted mp3)"
  [[ -n "$output" ]] || return 1

  ffmpeg \
    -n \
    -i "$1" \
    -map 0:a:0 \
    -c:a libmp3lame \
    -q:a "$quality" \
    "$output"
}
