# Secure Drupal File
A script to secure drupal filesystem

To run the script, provide the user for the desired Drupal filesystem owner:

```
./secure_drupal_file.sh root
```

It is recommended that you run this in a stage/dev system before in production.

Note after running this script you will no longer be able to install modules through the drupal interface. This is due to more restrictive file level permissions.
