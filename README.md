#Nessus Compliance Check Parser to Dradis Pro (via MediaWiki)#

Parses Nessus .nessus files containing Compliance Checks and outputs them in a for adding to MediaWiki. From there they can then be imported into Dradis Professional for use in generating a report.

It only goes via MediaWiki because it was quicker to write and better than creating individual issues. This way the findings can be imported into future projects too.

##Usage##
```
Options:
     --input-file, -i <s>:   Nessus .nessus input file
       --wiki-url, -w <s>:   MediaWiki API URL (full path to /api.php)
  --wiki-username, -k <s>:   MediaWiki username
  --wiki-password, -p <s>:   MediaWiki password
          --limit, -l <i>:   Limit the number of results processed (default: 0)
            --verbose, -v:   Be verbose
               --help, -h:   Show this message
```
