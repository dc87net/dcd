log(){ echo "$*"; } #logger -t TLDW "$*"; }
 [[ $(pgrep 'Cloudflare WARP') ]] && {
    log 'Loading WARP' &&{
      ("/Applications/Cloudflare\ WARP.app/Contents/MacOS/Cloudflare\ WARP" || log 'Error spawning WARP');
    };
  }
