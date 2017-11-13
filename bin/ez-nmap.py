#!/usr/bin/env python
# coding=utf-8

# http://ruby-doc.org/stdlib-2.3.1/libdoc/optparse/rdoc/OptionParser.html
# https://docs.python.org/2/library/argparse.html
# https://docs.python.org/3/library/argparse.html
#
# https://docs.python.org/3.5/library/cmd.html
# https://github.com/jonathanslenders/python-prompt-toolkit (looks awesome)
#   * https://python-prompt-toolkit.readthedocs.io/en/stable/pages/building_prompts.html
#
# https://github.com/JEG2/highline (ruby)
# http://www.awesomecommandlineapps.com/gems.html
#   * http://naildrivin5.com/methadone/
#   * http://naildrivin5.com/gli/
#
# And/or curses (console UI)
# And/or REPL style console
#
# https://www.ruby-toolbox.com/projects/thor

# https://stachliu.atlassian.net/wiki/display/TechRef/Nmap+-+HowTo+-+Port+Scanning+-+Fran+Notes
# https://stachliu.atlassian.net/wiki/pages/viewpageattachments.action?pageId=61997308

# Nmap to XLSX – StompDiggity: Stomp_digity_0.2.4.pl - Perl script parses Nmap results and puts into nice Excel spreadsheet:
# https://dl.dropboxusercontent.com/u/37051339/Software/Stomp_digity_0.2.4.pl

# Step 1 – Limited Port Scan – Identify Live Hosts
# Small port list – EXTERNAL INITIAL SCAN – good for quickly detecting live external systems:
# nmap -sS -n -T aggressive -P0 -vv --randomize_hosts -oA COMPANY-NmapResults-SmallPorts-v1 -iL COMPANY-IPs2ScanList.txt -p 21,22,23,25,53,80,443,3389,8000,8080

# Medium Port List – INTERNAL INITIAL SCAN - see attached Port_List.txt or Cheat_Sheet-CommonPorts.png for more details:
# nmap -sS -n -O -T aggressive -P0 -vv --randomize_hosts -oA COMPANY-NmapResults-CommonPorts-v1 -iL COMPANY-IPs2ScanList.txt -p 21,22,23,25,53,69,79,80,110,111,135,139,161,443,445,512,513,514,1099,1433,1494,1521,2000,2048,2049,2301,2433,3306,3389,4899,5631,5800,5900,6000,8080

# Step 2 – Full Port Scan – Of Known Live Systems
# Full Port Scan – once list of live IPs is obtained (at least 1 open port identified), run full ~65k port scan to identify all open ports
# nmap -sS -n -O -T aggressive -P0 -vv --randomize_hosts -oA COMPANY-NmapResults-FullPort-v1 -iL COMPANY-IPs2ScanList.txt -p-

# https://dl.dropboxusercontent.com/u/37051339/SL/Research/Internet_Census_2012-Summary/Nmap-Scripts/IP_Address_Ranges_to_IP_Listv2.pl
#   * Convert this to python and include?
#   * Include option to show # of IP's/etc

# http://exfiltrated.com/querystart.php Internet Census 2012 Search

# https://hackertarget.com/7-nmap-nse-scripts-recon/

# https://highon.coffee/blog/nmap-cheat-sheet/


from __future__ import unicode_literals
from prompt_toolkit import prompt
import argparse

# smallports = "21,22,23,25,53,80,443,3389,8000,8080"
# mediumports = "21,22,23,25,53,69,79,80,110,111,135,139,161,443,445,512,513,514,1099,1433,1494,1521,2000,2048,2049,2301,2433,3306,3389,4899,5631,5800,5900,6000,8080"

parser = argparse.ArgumentParser(description='Foo a bar')

# TODO:
# * --output-label: company/domain/label/etc (for output file)
# * --scope: scope file or ip range
# * Limited Port Scan - Identify Live Hosts
#   * External: small port list --limited-scan-external
#   * Internal: medium port list --limited-scan-internal
# * Full port scan on live hosts --full-scan
# * --no-root: Don't run nmap as root
# * --dry-run: Just generate the nmap command (useful for copying to a remote server)

# Features:
#   List scan: -sL (List Scan): The list scan is a degenerate form of host discovery that simply lists each host of the network(s) specified, without sending any packets to the target hosts. By default, Nmap still does reverse-DNS resolution on the hosts to learn their names.
#   Scripts:
#     IIS shortname
#     Other hostnames for host

parser.add_argument('integers', metavar='N', type=int, nargs='+',
                   help='an integer for the accumulator')

parser.add_argument('--sum', dest='accumulate', action='store_const',
                   const=sum, default=max,
                   help='sum the integers (default: find the max)')

args = parser.parse_args()


print args.accumulate(args.integers)

prompt('Enter a foo: ', default='somedefault')