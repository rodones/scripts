# Uploading Images to S3 Compatible Service

## Using s4cmd
### Setup

- Install s4cmd: `pip install s4cmd`

- Specify following variables in `.env`

        AWS_ACCESS_KEY_ID
        AWS_SECRET_ACCESS_KEY
        S3_ENDPOINT_URL

- Load environment: `source ./activate.sh`

- Check if everything work: `s4cmd ls`. You should see something like this:

        2021-10-09 12:41 DIR s3://rodones/
        2021-10-22 08:04 DIR s3://rodones-images/

### Uploading
- Load environment: `source ./activate.sh`
- Get next index: `rodo_next_index <PLACE>` (For example: `rodo_next_index GK-TAM`, _GK-TAM_ is a place code)
- Rename your images according to this format: `<PLACE>_<INDEX>_<UID>.JPG` (UID is one letter uploader identifier).
- Check you are not messing up with _--dry-run/-n_ parameter: `s4cmd -c 8 -n put -r 'your-images-dir/' s3://rodones-images/<PLACE>`
- Run to upload `s4cmd -c 8 put -r 'your-images-dir/' s3://rodones-images/CENG` 
(Be careful to the path endings. They affect uploading behaviour.)