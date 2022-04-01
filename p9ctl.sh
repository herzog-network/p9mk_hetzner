if [ -d ./pf9 ]; then
  echo ''
else
  bash <(curl -sL https://pmkft-assets.s3-us-west-1.amazonaws.com/pf9ctl_setup)
fi
