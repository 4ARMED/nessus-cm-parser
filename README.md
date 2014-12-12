#Nessus Compliance Check Parser to Dradis Pro (via MediaWiki)#

Parses Nessus .nessus files containing Compliance Checks and outputs them in a Dradis Pro format (tweak field names to suit your templates) and then (optionally) uploads them to MediaWiki. From there they can then be imported into Dradis Professional for use in generating a report.

It only goes via MediaWiki because it was quicker to write and better than creating individual issues. This way the findings can be imported into future projects too.

##Installation##

It uses Ruby, tested on 2.1.3 but it's not doing anything crazy so should work back to 1.9. Needs a few gems so check out the repo and use Bundler.

```
$ git clone https://github.com/4ARMED/nessus-cm-parser.git
$ cd nessus-cm-parser
$ bundle install
```

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

###Example###

```
./nessus-cm-parser.rb -v -i /tmp/some_host_we_scanned.nessus -v --wiki-url http://wiki.madeupco.lan/api.php
```
