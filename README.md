## mibrowser-file-manager

Utility to transfer data files from a cluster server to the MIBrowser AWS S3 bucket 
with proper paths and prefixes.

### S3 bucket

The target bucket is:

- Console:  <https://s3.console.aws.amazon.com/s3/buckets/mibrowser-data-s3>
- File URI: <s3://mibrowser-data-s3/FILE>
- File URL: <https://mibrowser-data-s3.s3.us-east-2.amazonaws.com/FILE>

### Configuration

Enter IAM User credentials for the bucket into file **credentials** in format 
(this file is not present in this repository for security reasons):

```
[default]
aws_access_key_id = xxx
aws_secret_access_key = xxx
```

Enter types of supported data transfers in file **config.yml** - see file for details.

### Batch scripts for app execution

Folder **batch-scripts** has batch scripts that are called on a desktop or laptop
to launch the app on the server and use it by port tunneling via ssh.
