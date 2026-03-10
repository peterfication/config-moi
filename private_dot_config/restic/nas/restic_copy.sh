# Copy restic-backups repositories to external drive
#
# export RESTIC_FROM_PASSWORD='source-repo-password'
# export RESTIC_PASSWORD='destination-repo-password'

export RESTIC_FROM_REPOSITORY="/volume2/restic-backups/macbook"
export RESTIC_REPOSITORY="/volumeUSB1/usbshare/restic-backups/macbook"

restic copy
