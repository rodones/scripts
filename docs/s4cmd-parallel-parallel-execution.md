# Executing s4cmd commands parallel

- Write the commands to file without *s4cmd* like this:

```text
del s3://some-bucket/some/file
del s3://some-bucket/other/file
del s3://some-bucket/another/file
mv s3://some-bucket/another/file s3://some-bucket/another/file2
ls 's3://another-bucket/folder/wildcard*'
ls -r s3://another-bucket/folder/
-c 8 -n put . s3://some-bucket/other/
```

- Run `./s4cmd_parallel.sh your_command_file.txt`