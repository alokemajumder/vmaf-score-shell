


# VMAF Check

This shell script checks the VMAF score of a video file compared to its source video. It supports various video formats like mp4, av1, hls, vp9, etc.

## Dependencies

- FFmpeg: https://ffmpeg.org/download.html
- VMAF: https://github.com/Netflix/vmaf
- jq: https://stedolan.github.io/jq/download/

## Usage

1. Install the required dependencies if the auto install by the script fails
2. Run the script as follows:

```bash
./vmaf_check.sh <source_video_filepath> <converted_video_filepath>
