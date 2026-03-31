password_generate() {
  echo "bw generate -ulns --length 20"
  bw generate -ulns --length 20
}

password_dice_generate() {
  echo "bw generate --passphrase --words 4 --separator "-""
  bw generate --passphrase --words 4 --separator "-"
}
