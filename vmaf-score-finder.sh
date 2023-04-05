#!/bin/bash

# Function to check and install dependencies
install_dependencies() {
  for cmd in ffmpeg jq; do
    if ! command -v $cmd &>/dev/null; then
      echo "$cmd not found, trying to install..."
      case "$(uname -s)" in
        Linux)
          sudo apt-get update && sudo apt-get install -y $cmd
          ;;
        Darwin)
          brew install $cmd
          ;;
        *)
          echo "Unsupported platform. Please install $cmd manually."
          exit 1
          ;;
      esac
    fi
  done

  if ! command -v vmaf &>/dev/null; then
    echo "VMAF not found, trying to install..."
    case "$(uname -s)" in
      Linux|Darwin)
        git clone https://github.com/Netflix/vmaf.git
        cd vmaf/libvmaf
        meson build --buildtype release
        ninja -vC build
        sudo ninja -vC build install
        sudo ldconfig
        cd ../..
        rm -rf vmaf
        ;;
      *)
        echo "Unsupported platform. Please install VMAF manually."
        exit 1
        ;;
    esac
  fi
}

# Install dependencies if required
install_dependencies

# Rest of the script...

#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <source_video_filepath> <converted_video_filepath>"
  exit 1
fi

source_video="$1"
converted_video="$2"

if [ ! -f "$source_video" ] || [ ! -f "$converted_video" ]; then
  echo "Error: One or both video files do not exist."
  exit 1
fi

# Generate VMAF score
ffmpeg -i "$source_video" -i "$converted_video" -lavfi libvmaf="model_path=/usr/local/share/model/vmaf_v0.6.1.pkl:log_fmt=json" -f null - 2> vmaf_score.json

# Extract VMAF score from JSON output
vmaf_score=$(jq '.VMAF_score' vmaf_score.json)

echo "VMAF score: $vmaf_score"

# Remove temporary JSON file
rm vmaf_score.json
