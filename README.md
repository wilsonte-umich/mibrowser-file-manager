## mibrowser-file-manager

Utility to transfer data files from a cluster server to the MIBrowser AWS S3 bucket 
with proper paths and prefixes.

### Batch scripts for app execution

Folder **batch-scripts** has batch scripts that are called on a desktop or laptop
to launch the app on the server and use it by port tunneling via ssh.

### S3 bucket

The target bucket is 'mibrowser-data-s3'.

### Configuration

Enter IAM User credentials for the bucket into file **credentials** in format 
(this file is not present in this repository for security reasons):

```
[default]
aws_access_key_id = xxx
aws_secret_access_key = xxx
```

Enter types of supported data transfers in file **config.yml** - see file for details.
