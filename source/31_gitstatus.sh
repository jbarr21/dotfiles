if [[ "$JBARR21_USE_P10K" -eq 1 ]]; then
  # export POWERLEVEL9K_DISABLE_GITSTATUS=true
  export GITSTATUS_CACHE_DIR="/Users/jbarr/Uber/.cache/gitstatus"
  export GITSTATUS_NUM_THREADS=$(expr $(nproc) / 2)
fi
