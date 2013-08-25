This is the Hawaii Data Pipeline tool.  It's the fastest way to get all the Hawaii Open Data into Ruby (or JSON).

Read the first of two or three tutorials here:
* [Introducing the Hawaii Data Pipeline](http://pasdechocolat.com/2013/04/06/introducing-the-hawaii-data-pipeline/) - An introduction to this tool, and how to get started.
* [The Pipeline Works or Honolulu Too](http://pasdechocolat.com/2013/04/07/pipeline-for-honolulu-too/) - The tool also works for City of Honolulu data too, find out how to switch datasets.
* [Using D3.js in Hawaii](http://pasdechocolat.com/2013/04/08/using-d3-in-hawaii/) - D3 is a great tool for making data visualizations. This tutorial teaches you how to mix D3 with Hawaii Open Data.
* [Mapping Hawaii](http://pasdechocolat.com/2013/05/03/mapping-hawaii/) - Find out how to create your own custom SVG maps of Hawaii. You'll start with open source shapefiles and travel through TopoJSON, finally ending up with D3 plots of your points of interest.

## Requirements

* Ruby version >= 1.9
* A sense of humor.

## Getting Started

````ruby
$ (clone this repo)
$ cd (this repo)
$ cp config/config.template.yml config/config.yml
$ (edit config/config.yml to include your Socrata API App Token)
$ irb -r './client.rb'

> client = HDP::Client.new 
 => #<HDPipeline::Client:0x007f8c82198b90 @user_config={:socrata=>{:app_token=>"xxxxx"}}, @config={:gov=>:state, :app_token=>"xxxxx"}>

> client.list
 ... (bit huge list: see below for example) ...

 > client.list "income"
 ... (smaller, more manageable list of datasets filtered by "income" in name, description) ...

> data = client.data_for "padw-q7ep"
 => ... (big dataset as array of hashes) ...

> data[0]
 => {"year"=>"1900", "rate_per_1000_resident_population"=>"6.7"}
````

## Datasets by Index

There's also an alternate way to grab datasets by their index (in the list):

````ruby
> client.list_item_at 214
 => {:name=>"/Health/Birth-Rate-State-Of-Hawaii-1900-2011", :id=>"padw-q7ep", :index=>214}

> client.list_item_at(214)[:name]
 => "/Health/Birth-Rate-State-Of-Hawaii-1900-2011"

> data = client.data_at 214
 => [{"year"=>"1900", "rate_per_1000_resident_population"=>"6.7"},...
````

## Catalog Search

This only works for the State of Hawaii datasets.  This is not implemented for the City of Honolulu.  We require a "catalog of datasets" for this to work.

The State of Hawaii provides a lot of datasets.  You may wish to find a dataset via index or ID lookup. Or, you may with to search on name, description, or some other part of the catalog metadata.

````ruby
# Get a catalog item by index:
> i = client.catalog_at 0

# Or, get a catalog item by ID:
> i = client.catalog_at "wzeq-n5pg"

# It behaves like a Ruby Hash.
> i.keys
 => [:name, :id, :metadata, :index]

# Note, I've stuffed all the data from the API into the ":metadata" hash.

# But, it also has method access to top-level keys:
> i[:name]
 => "1. USA.gov Short Links"

> i[:id]
 => "wzeq-n5pg"

> i[:index]
 => 0

# Search by partial name of the dataset:
> list = client.catalog_with_name "EV"
...
 => [{:name=>"Hawaii EV Charging Stations 02072013"...
> list.size
 => 1

# Search by your keywords for you idea, such as a name of thing:
> list = client.catalog_search "hawaii"
 => [{:name=>"2011 Visitor Plant Inventory Hawaii"...

> list.size
 => 70

> list = client.catalog_search "budget"
 => [{:name=>"FY 12 & FY 13 CIP Budget"...

> list.size
 => 2

# General search, allows for searching by long-form descriptions:
> list = client.catalog_search "alpha designations"
 => [{:name=>"FY 12 & FY 13 CIP Budget"...

# ...searching by index:
> list = client.catalog_search 0
 => [{:name=>"1. USA.gov Short Links"...

> list.size
 => 1

# ...searching by ID:
> list = c.catalog_search "wzeq-n5pg"
 => [{:name=>"1. USA.gov Short Links"...

> list.size
 => 1
````

## Catalog Exploration

This only works for the State of Hawaii datasets.  This is not implemented for the City of Honolulu.  We require a "catalog of datasets" for this to work.

The State of Hawaii provides a lot of metadata for each catalog item. You can use the tool to explore this metadata.

````ruby
# Catalog items are just nomal Ruby Hash objects.
# All features of the CatalogItem (CI) module are static convenience methods for 
# parsing this metadata hash.

# The trailing "nil" just suppresses echoing of output.
> i.each {|key, value| puts "#{key} is #{value}" };nil
name is 1. USA.gov Short Links
id is wzeq-n5pg
metadata is {"system_id"=>"wzeq-n5pg"...
index is 0
 => nil

# Get at the metadata:
> i[:metadata]
 => {"system_id"=>"wzeq-n5pg"...

# Find all the columns in this dataset:
> CI.columns i
 => [{"id"=>2802619,...}]

# List columns by name:
> CI.column_names i
 => ["short_url", "user_agent", "country_code", "known_user", "global_bitly_hash", "user_bitly_hash", "user_login", "short_url_cname", "referring_url", "long_url", "timestamp", "geo_region", "location", "city", "timezone", "hash_timestamp", "language"]

# List columns by display names:
> CI.column_display_names i
 => ["Short URL", "User Agent", "Country Code", "Known User", "Global Bitly Hash", "User Bitly Hash", "User Login", "Short URL CNAME", "Referring URL", "Long URL", "Timestamp", "Geo Region", "Location", "City", "Timezone", "Hash Timestamp", "Language"]

# Look up metadata on column by name:
> CI.column i, "short_url"
 => [{"id"=>2802619, "name"=>"Short URL", "dataTypeName"=>"url", "fieldName"=>"short_url", "position"=>2, "renderTypeName"=>"url", "tableColumnId"=>1502687, "width"=>208, "format"=>{}, "subColumnTypes"=>["url", "description"]}]

# Look up metadata on column by field (display) name:
> CI.column i, "Short URL"
 => [{"id"=>2802619, "name"=>"Short URL"...}]

# Look up metadata on column by ID:
> CI.column i, 2802619
 => [{"id"=>2802619, "name"=>"Short URL"...}]

# Search for column by part of the column name:
> cols = CI.column_like i, "url"
 => [{"id"=>2802619, "name"=>"Short URL"...

> cols.size
 => 4
````

You can begin to see the power of searching through the metadata for each catalog item, when you consider that we might match datasets together based on similar column types (such as latitude and longitude).


## Filtering large datasets

For a more comprehensive look at how to work with datasets, please check out the list of tutorials at the top of this page.

If you're interested in looking at smaller portions of large datasets, it is important to understand how to use [SODA API queries](http://dev.socrata.com/docs/queries). The Pipeline tool allows you to attach arbitrary SODA queries to your request for a dataset via the "client.data_for" method. It also has helpful convenience options for specifying just portions of a query (such as "where", or "max_recs").

Here are some examples.  Please check out the [SODA query documentation](http://dev.socrata.com/docs/queries) for more infomation on how to specify a valid query.

The parameters available on **client.data_for** are:
* max_recs: N - Specify the max number (N) of records to return.
* order_by: "column_name" - Specify the column (column_name) to sort by (ascending is the default).
* order_by: "column_name desc" - Same, but descending.
* soda_query: "your_query" - Specify your own [SODA query](http://dev.socrata.com/docs/queries).

Examples of each of these follow.

````ruby
# Specify the maximum number of records to return, and how to sort
# them.  This is useful when the dataset is large, and you just want
# a peek at it.

# Let's look at this dataset, the price of gas:
> client.list "dqp6-3idi"
...
24) Name: AAA Fuel Prices  ID: dqp6-3idi

# This dataset has the following columns:
> CI.column_names c.catalog_search("dqp6-3idi").first
 => ["month_of_price", "county", "fuel", "price", "physicalunit"]

# This query pulls the oldest records.
> client.data_for "dqp6-3idi", max_recs: 10, order_by: "month_of_price"
...
 => [{"price"=>"2.314", "county"=>"US", "month_of_price"=>"2006-01-01T00:00:00", "fuel"=>"Gasoline - Regular", "physicalunit"=>"Dollars"},...

# Same as the above, but this query pulls the latest records.
> cient.data_for "dqp6-3idi", max_recs: 10, order_by: "month_of_price desc"
...
 => [{"price"=>"3.356", "county"=>"US", "month_of_price"=>"2012-07-01T00:00:00", "fuel"=>"Gasoline - Regular", "physicalunit"=>"Dollars"},...

# This is an example of aggregation, calculating the average fuel price.
> client.data_for "dqp6-3idi", soda_query: "&$select=fuel,avg(price)&$group=fuel"
...
 => [{"fuel"=>"Gasoline - Regular", "avg_price"=>"3.4411924050632911"}, {"fuel"=>"Gasoline - Midgrade", "avg_price"=>"3.6041848101265823"}, {"fuel"=>"Gasoline - Premium", "avg_price"=>"3.6840987341772152"}, {"fuel"=>"Diesel", "avg_price"=>"3.9448050632911392"}]

# Here's anoter aggregation that finds the max price:
> client.data_for "dqp6-3idi", soda_query: "&$select=fuel,max(price)&$group=fuel"
...
 => [{"fuel"=>"Gasoline - Regular", "max_price"=>"4.891"}, {"fuel"=>"Gasoline - Midgrade", "max_price"=>"4.978"}, {"fuel"=>"Gasoline - Premium", "max_price"=>"5.067"}, {"fuel"=>"Diesel", "max_price"=>"5.483"}]
````

The custom query interface is still a bit clunky. But, it's interesting to note that the advantage of using custom queries is that the work is done on the SODA servers. This means that it's usually much faster than pulling all the data and processing it locally.


## Exporting Data (JSON or CSV)

When exporting data, it's important to note that all explicitly exported data goes to the **data** directory by default.

However, there's a short-cut to generating this data. Look in the **tmp/cache** directory. That's where *everything* you download goes. EVERYTHING.

````ruby
# Get a dataset (this is the birthrate dataset):
> d = client.data_at 48

# Do crazy things with the data here.

# Generate a JSON file from the birthrate data:
> client.export_json d, "temp.json"
 => 6608
# Your JSON file is now in "data/birthrate.json"

# Generate a CSV (comma-delimited) for the birthrate data:
> client.export_csv d, "birthrate.csv"
 => [{"year"=>"1900"...
# Your CSV file is now in "data/birthrate.csv"

# Specify a custom delimiter (e.g. the pipe here) for the birthrate data:
> client.export_csv d, "piped_birthrate.csv", "|"
 => [{"year"=>"1900"...
# Your CSV file is now in "data/piped_birthrate.csv"

````


## What could this possibly be good for?

It's difficult to explain this, as there are folks who will see immediate value here and those who do not. If you do not, it's probably because you aren't sure how exactly to work with all this data. Rest assured, if you find yourself working with **more than one** dataset at a time, you'll want something more than a mouse to help you.

You'll probably want something that looks like this tool right here. This isn't the only way to solve this problem. How about writing something with Clojure? Haskell?

In the future I'd like to (possibly):

- [ ] Add **charts** and **maps** to the dataset catalog.
- [ ] Allow searching for datasets with matching column types.
- [ ] Allow composition of multiple datasets, based on shared column types.
- [ ] Generate simple D3 charts for basic datasets.
- [ ] Generate simple D3 maps for basic datasets (which include lat/long info).

Enjoy!


# CITY OF HONOLULU DATASETS

<pre>
client.set_dataset_type :city
client.list
 => ...
0) Name: /Finance/City-FY14-Proposed  ID: rh9s-z3mn
1) Name: /Transportation/Bike-Rack-Locations-By-Area  ID: ab7c-s2jr
2) Name: /dataset/2012-Dec-Top-Ten-Sites  ID: 7kck-y29a
3) Name: /dataset/Automated-external-defibrillator-Locations  ID: 2swm-eusf
4) Name: /dataset/City-spending  ID: std8-yakc
5) Name: /dataset/Crime-Incidents  ID: a96q-gyhq
6) Name: /dataset/Data-Catalog  ID: a3ah-kpkr
7) Name: /dataset/HART-Proposed-Budget-2012  ID: ifzd-2k3p
8) Name: /dataset/Honolulu-311-Reports  ID: fdx8-nih6
9) Name: /dataset/Neighborhood-Boards  ID: 3dxw-z8rr
10) Name: /dataset/Neighborhood-Boards-Election-2011  ID: w4ir-s4fd
11) Name: /dataset/Public-Art  ID: yef5-h88r
12) Name: /dataset/Sister-Cities  ID: pvti-pwka
13) Name: /dataset/Templates  ID: t6ff-mewd
14) Name: /dataset/Traffic-Camera-Locations  ID: dcdf-43kn
15) Name: /dataset/Traffic-Incidents  ID: ix32-iw26
 => nil
</pre>

# STATE OF HAWAII DATASETS

<pre>
client.set_dataset_type :state
client.list
 => ...
Search complete, found 381 datasets.
0) Name: 2.1d VSAT Recommend Molokai By MMA  ID: htqt-4ghe
1) Name: 2007 Instructional Letters  ID: uj9h-52f4
2) Name: 2007-2008 National Voter Registration Act of 1993 Survey Combined Section A  ID: uwr9-2a69
3) Name: 2008 Election Administration and Voting Survey Combined Section C  ID: rk83-5bqj
4) Name: 2008 Election Administration and Voting Survey Combined Section C, D, E, F, F7, F7i, F8  ID: 2uw3-qc9y
5) Name: 2008 Election Administration and Voting Survey Combined Section D  ID: 7jjx-d6en
6) Name: 2008 Election Administration and Voting Survey Combined Section E  ID: p332-7rv5
7) Name: 2008 Election Administration and Voting Survey Combined Section F  ID: jb3m-y7i7
8) Name: 2008 Election Administration and Voting Survey Combined Section F7  ID: xm3x-qbi7
9) Name: 2008 Election Administration and Voting Survey Combined Section F7I  ID: 66b6-term
10) Name: 2008 Election Administration and Voting Survey Combined Section F8  ID: 6mia-nc6j
11) Name: 2008 Uniformed and Overseas Citizens Absentee Voting Act Survey Combined Section B  ID: 2tan-w4es
12) Name: 2009 Instructional Letters  ID: pj69-ay3t
13) Name: 2009-2010 National Voter Registration Act of 1993 Survey  ID: xsr6-x4pr
14) Name: 2011 Data Book Sections And Tables  ID: w28j-r29d
15) Name: 2011 Visitor Plant Inventory Hawaii  ID: rjmg-cpq7
16) Name: 2011-2012 LOBBYIST and ORGANIZATIONS  ID: n6vu-fqwd
17) Name: 2012 Instructional Letters  ID: qpxs-gtjv
18) Name: 2013 CIP Encumbrances  ID: p6rw-tx3z
19) Name: 2013 State Holidays  ID: epj5-jxdm
20) Name: 2013-2014 LOBBYIST and ORGANIZATIONS  ID: wh8j-hrn4
21) Name: 20130423 ERP STAFF AND INTERESTED PARTIES  ID: 8pbp-ehn6
22) Name: 2014 State Holidays  ID: rcfm-5fv2
23) Name: AAA Fuel Prices  ID: dqp6-3idi
24) Name: Ability To Speak English By Age  ID: ri9m-brxc
25) Name: Ability To Speak English By Gender  ID: y2i2-mgg7
26) Name: Ability To Speak English By Language  ID: 8jzv-99pp
27) Name: Ability To Speak English By Marital Status  ID: 6jpf-s9b3
28) Name: Ability To Speak English By Nativity  ID: u5ff-xh5k
29) Name: Ability To Speak English By Race  ID: avad-trha
30) Name: Ability To Speak English By Total Income  ID: wwsw-d6qv
31) Name: Achievement Results for State Assessments in Mathematics:  School Year 2008-09  ID: jie4-w22m
32) Name: Achievement Results for State Assessments in Mathematics:  School Year 2009-10  ID: hhtw-4eb7
33) Name: Achievement Results for State Assessments in Mathematics:  School Year 2010-11  ID: r3ix-z65i
34) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2008-09  ID: mvz4-m3zh
35) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2009-10  ID: s5rp-twp9
36) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2010-11  ID: 6qru-yfc5
37) Name: Adjusted Cohort Graduation Rates at the school level: School Year 2010-11  ID: m5pw-2ea9
38) Name: Adult Day Health Center facilities  ID: kahi-xnwd
39) Name: Adult Residential Care Home LISTING  ID: e7u9-uyxu
40) Name: Alcohol and Drug Abuse Prevention Services  ID: 2dr7-mwnn
41) Name: Alt Energy Station Data  ID: 36sn-6y6i
42) Name: Ambulatory Surgical Centers  ID: h965-zk9w
43) Name: Annual Production Figures of United States Currency  ID: ym8u-jtw3
44) Name: Assisted Living Facilities Listing  ID: iqpn-unzm
45) Name: Average Monthly Regular Gasoline Prices Hawaii (by County) vs U.S. (Source: DBEDT)  ID: f55i-85xa
46) Name: Bills Passed 2012  ID: 86eu-zw2n
47) Name: Bills That Passed 2013 Legislature  ID: pkba-543m
48) Name: Birth Rate, State Of Hawaii 1900 - 2011  ID: padw-q7ep
49) Name: Blog Posts  ID: 53b5-749p
50) Name: CIP 2011-2012  ID: pmbr-njwn
51) Name: CIP Encumberances June 2012  ID: aybr-r7va
52) Name: CIP Expenditures  ID: 54sf-nz6w
53) Name: Campaign Contributions Made To Candidates By Hawaii Noncandidate Committees From January 1, 2008 Through June 30, 2013  ID: 6huc-dcuw
54) Name: Campaign Contributions Received By Hawaii State and County Candidates From November 8, 2006 Through June 30, 2013  ID: jexd-xbcg
55) Name: Cash and Payments Management Data  ID: w9zu-5ne2
56) Name: Catalog of Federal Domestic Assistance (CFDA) (Old) (Old) (Old) (Old)  ID: mwm2-x6y4
57) Name: Category Information  ID: yv27-ghxi
58) Name: Category Stories  ID: p46r-d2ir
59) Name: Central Contractor Registration (CCR) FOIA Extract  ID: 3hqn-qzh6
60) Name: Civil Unions YTD 2012  ID: jjmh-uh4q
61) Name: Class Specification And Minimum Qualification  ID: b6h2-ri5e
62) Name: Contributions Received By Hawaii Noncandidate Committees From January 1, 2008 Through June 30, 2013  ID: rajm-32md
63) Name: Current TRI Chemical List  ID: gjp3-95wf
64) Name: DBEDT Average Annual Regular Gasoline Price Hawaii Vs U. S. 2006-2010  ID: fsqf-xf57
65) Name: DBEDT Average Monthly Regular Gasoline Price Hawaii Vs U. S. 2006-2010  ID: 9zb8-378h
66) Name: DBEDT Clean Economy Job Growth 2003-2010  ID: 5fix-ixwc
67) Name: DBEDT Cost Of Electricity For State Agencies FY05- FY10  ID: igkv-isiz
68) Name: DBEDT Cost Of Electricity For State Agencies by Fiscal Year  ID: x7ms-76ef
69) Name: DBEDT Cumulative Installed Photovoltaic Capacity Per Capita  ID: t9ac-479g
70) Name: DBEDT Currently Proposed Renewable Energy Projects In Hawaii  ID: b8it-cxyb
71) Name: DBEDT Electricity Consumption By State Agencies FY05- FY10  ID: 64np-vcjy
72) Name: DBEDT Energy Savings Performance Contracting Per Capita  ID: vad7-tbnj
73) Name: DBEDT HECO Ranks Third In 2010 Annual Solar Watts Per Customer  ID: jyvh-hvkp
74) Name: DBEDT Hawaii Annual Electricity Cost And Consumption 2006-2010  ID: dnwk-g44q
75) Name: DBEDT Hawaii Cumulative Hybrid And Electric Vehicles Registered 2000-2010  ID: wget-66q5
76) Name: DBEDT Hawaii De Facto Population By County 2000-2010  ID: i7pr-uy4x
77) Name: DBEDT Hawaii Electricity Consumption 1970-2010  ID: qs2r-yxun
78) Name: DBEDT Hawaii Energy Efficiency Improvements 2005-2010  ID: a7ub-k7sa
79) Name: DBEDT Hawaii Energy Star Buildings 2003-2011  ID: vd5c-qe52
80) Name: DBEDT Hawaii Fossil Fuel Consumption And Expenditures 1970-2009  ID: 2u2g-c52b
81) Name: DBEDT Hawaii Nominal Gross Domestic Product 2000-2010  ID: s3qd-f86n
82) Name: DBEDT Hawaii Renewable Energy Generation 2005-2010  ID: vvr4-p4an
83) Name: DBEDT Hawaii State Agencies Electricity Consumption And Cost FY05- FY10  ID: bubj-tpbw
84) Name: DBEDT Hawaii Utility Companies Rank Among The Top  ID: i2tt-ek6x
85) Name: DBEDT Hawaii Utility Companies Rank Among The Top In Cumulative Solar Watts Per Customer  ID: kbgq-sdh2
86) Name: DBEDT Hawaii Vehicle Miles Traveled 1990-2010  ID: 894w-927z
87) Name: DBEDT Hawaii's Clean Economy Job Growth  ID: d3e2-v3mh
88) Name: DBEDT New Distributed Renewable Energy Systems Installed In Hawaii Annually 2001-2010  ID: mp64-qiad
89) Name: DBEDT Pie Chart Of Electric Hybrid Fossil Cars  ID: hm88-midt
90) Name: DHHL General Leases  ID: i7f9-fj37
91) Name: DHHL Licenses  ID: vcvt-yznb
92) Name: DHHL Revocable Permits  ID: j5dq-nmjy
93) Name: DHHL Right Of Entry  ID: jpyg-5jmy
94) Name: DOH CAMHD  ID: m659-q5bd
95) Name: Data.gov Daily Visitor Statistics  ID: bmze-gihd
96) Name: Data.gov Dataset Monthly Download Trends  ID: vx25-4bgc
97) Name: Data.gov Datasets Download By Data Category  ID: hhjs-7smp
98) Name: Data.gov Datasets Uploaded by Agencies per month  ID: g5st-hnpb
99) Name: Data.gov Datasets Uploaded by Agencies per month  ID: 7vpv-axhc
100) Name: Data.gov Datasets Uploaded by Agencies per month May 2013 Onwards  ID: yiw6-6i4x
101) Name: Data.gov Federal Agency Participation  ID: aubg-mfc9
102) Name: Data.gov Federal Agency Participation May 2013 Onwards  ID: agtq-akrq
103) Name: Data.gov Monthly Page Views  ID: spus-5492
104) Name: Data.gov Monthly Visitor Statistics  ID: 9car-pxwp
105) Name: Data.gov Top 10 Visiting Countries  ID: czf7-qvqf
106) Name: Data.gov Top 10 Visiting States  ID: we7r-hu8x
107) Name: Death Rate, State Of Hawaii 1900 - 2011  ID: xa5e-sayp
108) Name: December 2012 Encumbrances  ID: 9j5e-h438
109) Name: Department of  Public Safety Weekly Population Reports  ID: q8ke-n6gw
110) Name: Department of Defense - State Civil Defense Emergency Siren Locations  ID: jety-j7dm
111) Name: Department of Defense Hawaii Air National Guard  ID: Enter a resource name
112) Name: Department of Defense Hawaii Army National Guard Facility Locations  ID: 9ms4-cvz7
113) Name: Department of Public Safety Bed Capacity 2013  ID: qv4n-m8rb
114) Name: Department of State Voting Assistance Officer 2008 Post Election Survey  ID: szft-5daq
115) Name: Dialysis Centers  ID: bcw9-zb3y
116) Name: Distinct agency names in geospatial metadata  ID: 6mq7-82cd
117) Name: Durable Assets For Hawaii Noncandidate Committees From January 1, 2008 Through June 30, 2013  ID: i778-my94
118) Name: Durable Assets For Hawaii State and County Candidates From November 8, 2006 Through June 30, 2013  ID: fmfj-bac2
119) Name: EPA Toxics Release Inventory Program  ID: wma8-v5fi
120) Name: Early Learning  ID: tnnx-zerc
121) Name: Election Periods for Hawaii Noncandidate Committees  ID: ngjc-id6g
122) Name: Enterprise Zone Enrollment  ID: nhut-yk4g
123) Name: Executive Orders from 1994 to 2012  ID: ps37-i6ce
124) Name: Expenditures Made By Hawaii Noncandidate Committees From January 1, 2008 Through June 30, 2013  ID: riiu-7d4b
125) Name: Expenditures Made By Hawaii State and County Candidates From November 8, 2006 Through June 30, 2013  ID: 3maa-4fgr
126) Name: Export-Import FY 2007 Applications  ID: b522-5988
127) Name: Export-Import FY 2007 Participants  ID: 94s7-8bc4
128) Name: Export-Import FY 2008 Applications  ID: x5yb-3m6g
129) Name: Export-Import FY 2008 Participants  ID: qmg4-28c7
130) Name: Export-Import FY 2009 Applications  ID: qjfq-7m95
131) Name: Export-Import FY 2009 Participants  ID: w4ju-iurc
132) Name: Export-Import FY 2010 Applications  ID: de9r-6tze
133) Name: Export-Import FY 2010 Participants  ID: xegi-46pm
134) Name: Export-Import FY 2011 Applications  ID: 7gs4-396b
135) Name: Export-Import FY 2011 Participants  ID: mdvf-68cr
136) Name: Export-Import FY 2012 Applications  ID: a84i-8kb5
137) Name: Export-Import FY 2012 Participants  ID: em83-2ywi
138) Name: Export-Import FY 2013 Applications  ID: jki6-u4jp
139) Name: Export-Import FY 2013 Participants  ID: yhdt-apb3
140) Name: FARA Records  ID: fara-registrations
141) Name: FAS Forecast Of Contracting Opportunities  ID: e6hw-q8rb
142) Name: FEC Candidates  ID: fec-candidate
143) Name: FEC Committees  ID: fec-committee
144) Name: FEC Contributions  ID: 4dkz-64bn
145) Name: FY 12 & FY 13 CIP Budget  ID: dkm3-39id
146) Name: FY 13 Operating Budget By Cost Element (w. SUB)  ID: pi3x-y834
147) Name: FY2013 Per Diem Reimbursement Rates  ID: perdiem
148) Name: Family Guidance Centers  ID: uv73-kg72
149) Name: Family Guidance Centers  ID: vr34-rcsa
150) Name: Federal Acquisition Service Instructional Letter 2008  ID: uqka-e8rd
151) Name: Federal Acquisition Service Instructional Letter 2010  ID: in27-bzp2
152) Name: Federal Acquisition Service Instructional Letter 2011  ID: gxu5-zmjz
153) Name: Federal Advisory Committee Act (FACA) Committee Member List-1997  ID: fext-zxex
154) Name: Federal Advisory Committee Act (FACA) Committee Member List-1998  ID: zx26-9ui3
155) Name: Federal Advisory Committee Act (FACA) Committee Member List-1999  ID: 3ne8-smp5
156) Name: Federal Advisory Committee Act (FACA) Committee Member List-2000  ID: 9rrm-cghv
157) Name: Federal Advisory Committee Act (FACA) Committee Member List-2001  ID: tvsq-mxeu
158) Name: Federal Advisory Committee Act (FACA) Committee Member List-2002  ID: z8t4-b33c
159) Name: Federal Advisory Committee Act (FACA) Committee Member List-2003  ID: kxci-9zen
160) Name: Federal Advisory Committee Act (FACA) Committee Member List-2004  ID: uwfv-c5g3
161) Name: Federal Advisory Committee Act (FACA) Committee Member List-2005  ID: 7ji5-mpn9
162) Name: Federal Advisory Committee Act (FACA) Committee Member List-2006  ID: e2uu-kmyn
163) Name: Federal Advisory Committee Act (FACA) Committee Member List-2007  ID: 3wwp-fssc
164) Name: Federal Advisory Committee Act (FACA) Committee Member List-2008  ID: b348-risj
165) Name: Federal Cost of School Food Program Data  ID: ysmn-j7g2
166) Name: Federal Data Center Consolidation Initiative (FDCCI) Data Center Closings 2010-2014  ID: d5wm-4c37
167) Name: Federal Employees Living Overseas 2008 Post Election Survey  ID: mgvs-6quj
168) Name: Federal Executive Agency Internet Domains as of  07/02/2013  ID: ku4m-7ynp
169) Name: First In Nation Energy Savings Performance Contracting Per Capita (Source: Energy Services Coalition)  ID: my42-pfm5
170) Name: Fiscal Year 2006 Employee & Survivor Annuitants by Geographic Distribution  ID: cbz3-q4aw
171) Name: Foreign Per Diem Rates by Location  ID: jf5a-mh6t
172) Name: Free Standing X-Ray Facility  ID: xpu9-ny5u
173) Name: General Election 2010 Summary Results.csv  ID: 8bdn-x7b5
174) Name: General Election 2012 Results  ID: eze4-hq7j
175) Name: General Election 2012 Summary Results  ID: gvfi-8e84
176) Name: General Election Results 2010  ID: y7za-qz47
177) Name: Grand Traverse Overall Supply Air Monitoring  ID: v7h3-9e9g
178) Name: Green Jobs By Industry  ID: grte-hrwt
179) Name: GreenSun Hawaii  ID: 5pwd-w8pn
180) Name: HAWAII'S FARMER'S MARKET  ID: nqfm-3etr
181) Name: HI Electricity Prices  ID: 74g9-vewt
182) Name: HI KWh Utility Supply 2008 - 2012  ID: raj6-dc7s
183) Name: HSEC- Organizations Expenditures (2006-2012)  ID: 6uwv-4qkz
184) Name: Hawa  International Study Market Share Compare To US  ID: 22ij-z5fe
185) Name: Hawaii Annual Electricity Consumption  ID: biet-37vh
186) Name: Hawaii Annual Electricity Cost  ID: i7am-7q95
187) Name: Hawaii County Births, Deaths, Marriages, Civil Unions 2012  ID: q8kg-9myh
188) Name: Hawaii County TEFAP Agencies  ID: u2s9-2pv4
189) Name: Hawaii Directory Of Green Employers  ID: mq86-5ta6
190) Name: Hawaii EV Charging Stations 02072013  ID: hbhw-unm4
191) Name: Hawaii Electricity Consumption  ID: ya75-e6j8
192) Name: Hawaii International Study Direct Spending final  ID: c2xi-ug2r
193) Name: Hawaii International Study Direct Spending-2  ID: xtwj-zrh4
194) Name: Hawaii Public Electric Vehicle Charging Stations  ID: cizq-byyq
195) Name: Hawaii Public Schools  ID: 6r5m-ppsj
196) Name: Hawaii Renewable Energy Generation By Resource  ID: ezj8-myxp
197) Name: Hawaii Training Providers 2011  ID: 365y-wu3m
198) Name: Hawaii eGov Apps  ID: y552-5npg
199) Name: Hawaii's Registered Livestock Brands  ID: gqi6-9ts8
200) Name: Home Health Agencies  ID: 3ekp-jm2z
201) Name: Honolulu County Births, Deaths, Marriages, Civil Unions 2012  ID: bxc7-28ys
202) Name: Hospice Facilities  ID: c6z7-qg9b
203) Name: Hospitals in Hawaii  ID: rwns-g4bn
204) Name: IC2011 ODI  ID: wjms-uqtz
205) Name: IC2012 ODI  ID: ick7-necg
206) Name: IC2013 ODI  ID: bemv-9rsd
207) Name: Initial Conferences Held ( RSN 39973)  ID: yrmn-32dg
208) Name: Interactive Datasets on Data.gov  ID: 2hpy-4cgt
209) Name: Inventory Reporting Information System (IRIS) Safety  ID: 3myt-pfx4
210) Name: Investing In Innovation 2010 Applications  ID: qk9j-ipa4
211) Name: Investing In Innovation 2011 Applications  ID: svh6-9cag
212) Name: Kauai County Births, Deaths, Marriages, Civil Unions 2012  ID: u2ph-i4am
213) Name: Kauai TEFAP Agencies  ID: 92m2-d339
214) Name: LICENSED PESTICIDES LISTING  ID: rzjk-9g6v
215) Name: Lead By Example Hawaii State Agencies Electricity Consumption  ID: xpcc-ct2d
216) Name: Leading Indicators for the School Improvement Grant Program - School Year 2010-11  ID: smu7-q9sm
217) Name: Libraries Annual Statistics Comparison 2010-2011  ID: utt5-rg7n
218) Name: Libraries Blind And Physically Handicapped Fiscal 2011  ID: nd3u-89v6
219) Name: Libraries Borrowers 1984 - 2011  ID: uzs2-uayh
220) Name: Libraries Circulation Activity 1984 - 2011  ID: ky64-e4mx
221) Name: Libraries Collection Statistics 2011  ID: acuw-fgkq
222) Name: Libraries Collections Statistics 2005-2011  ID: g4rv-58tp
223) Name: Libraries Computers Available  ID: tkwq-e4vi
224) Name: Libraries Expenditures FY2007 - FY2010  ID: cqxe-ukdd
225) Name: Libraries Holdings 1984 - 2011  ID: rdtc-xuie
226) Name: Libraries Holdings FY84 - FY12  ID: n84k-kyxx
227) Name: Libraries Hosted Programs FY2009 - FY2011  ID: 3af5-md85
228) Name: Libraries Internet Sessions By Year FY06 - FY11  ID: e85y-zk7s
229) Name: Libraries Material Inventory 2005 - 2012  ID: cip4-gcsk
230) Name: Libraries Outreach Programs FY2009 - FY2011  ID: ekm4-ugtg
231) Name: Libraries State Of Hawaii  ID: jx86-2vch
232) Name: Licensed Intermediate Care Facilities  ID: 3zrt-yrqs
233) Name: Loans Received By Hawaii State and County Candidates From November 8, 2006 Through June 30, 2013  ID: yf4f-x3r4
234) Name: Lobbying Disclosure Reports  ID: congressional-lobbying
235) Name: Local Education Agency (School District) Universe Survey Data 2009-10  ID: t9x5-2xzp
236) Name: Local Election Official 2008 Post Election Survey  ID: bwb6-fcji
237) Name: Marine Casualty and Pollution Database - Facility Pollution for 2002-2010  ID: wxch-i4p2
238) Name: Marine Casualty and Pollution Database - Injury for 2002 - 2010  ID: atbs-jds5
239) Name: Marine Casualty and Pollution Database - Other Events for 2002 - 2010  ID: 9jm7-jmx8
240) Name: Marine Casualty and Pollution Database - Vessel 2002-2010  ID: 8gap-yij5
241) Name: Marine Casualty and Pollution Database - Vessel Events for 2002-2010  ID: vf29-pk33
242) Name: Marine Casualty and Pollution Database - Vessel Pollution for 2002-2010  ID: g66d-8aji
243) Name: Materials Discarded in the U.S. Municipal Waste Stream, 1960 to 2009 (in tons)  ID: 3g88-w2ag
244) Name: Maui County Births, Deaths, Marriages, Civil Unions 2012  ID: rt4b-b8s5
245) Name: Maui County TEFAP Agencies  ID: ww8h-8rsi
246) Name: Monthly Economic Indicators - State Of Hawaii  ID: f96m-3kf5
247) Name: Motions Hearings Held ( RSN 39976)  ID: c5n8-8cmk
248) Name: NSF Funding Rate History  ID: g5it-4uhm
249) Name: NSF GRFP Awardees And Honorable Mentions (2000-2012)  ID: hm25-zz27
250) Name: National Center for Education Statistics (NCES) -  Integrated Postsecondary Education Data System (IPEDS) - Institutional Characteristics - Directory Information - 2011  ID: IPEDS-HD2011
251) Name: National Center for Education Statistics (NCES) - Classification of Instructional Programs (CIP 2000)  ID: CIPCODE
252) Name: National Center for Education Statistics (NCES) - Common Core of Data (CCD) - Public Elementary/Secondary School Universe Survey Data (2010-11)  ID: NCES-CCD-SC102A
253) Name: National Center for Education Statistics (NCES) - Integrated Postsecondary Education Data System (IPEDS) - Awards/degrees Conferred by Program - 2011  ID: NCES-IPEDS-C2011_A
254) Name: National Center for Education Statistics (NCES) - State Education Data Profiles - Elementary & Secondary Education Characteristics - CCD: 2010-2011  ID: vi5x-f3ti
255) Name: National Center for Education Statistics (NCES) - State Education Data Profiles - Elementary & Secondary Education Finance - CCD: FY10 (2009-2010)  ID: f7u8-xypq
256) Name: National Center for Education Statistics (NCES) - State Education Data Profiles - National Assessment of Educational Progress - NAEP: 2002, 2007, 2009, 2011  ID: 7xjd-vnu6
257) Name: New Distributed Renewable Energy Systems Installed In Hawaii Annually  ID: y7ur-vi2p
258) Name: Non-federal employees living overseas 2008 Post Election Survey  ID: njp2-ckqg
259) Name: Non-resident Marriages 2012  ID: nu5e-s79u
260) Name: Number of Appeals ( RSN 39972)  ID: 6yqr-w4bm
261) Name: OAHU Food Establishments  ID: qkvm-skze
262) Name: OGE Travel Reports  ID: oge-travel-reports
263) Name: OIE-FAVN TEST RESULTS BY MICROCHIP - under construction with test data  ID: fhan-ym2j
264) Name: OIP Master UIPA Records Request Year- End Log For FY2013  ID: pzmr-37xi
265) Name: OIP Master UIPA Records Request Year-End Log For FY 2013  ID: 7dxn-jvme
266) Name: Oahu TEFAP Agencies  ID: e4jf-2nsz
267) Name: October 2012 Encumbrances  ID: avhv-dnmd
268) Name: Organ Procurement facilities  ID: 678g-isej
269) Name: Organizational Reports For Hawaii Noncandidate Committees  ID: i4e7-rcnc
270) Name: Organizational Reports For Hawaii State and County Candidates  ID: gkek-wbij
271) Name: Other Receipts For Hawaii Noncandidate Committees From January 1, 2008 Through June 30, 2013  ID: m822-j8iy
272) Name: Other Receipts For Hawaii State and County Candidates From November 8, 2006 Through June 30, 2013  ID: ue3d-efjr
273) Name: Outpatient Physical therapy locations  ID: 3gh2-6seg
274) Name: Passenger Counts  International and Domestic May 2013  ID: btiw-7vk4
275) Name: Passenger Counts May 2013  ID: k5s6-yfqg
276) Name: Post-Secondary Universe Survey 2009 - Student financial aid and net price: 2008-09 (revised on 07/12/2011)  ID: 4ibs-r6fv
277) Name: Post-Secondary Universe Survey 2010 - Awards/degrees conferred by program, award level, race/ethnicity, and gender  ID: fjce-ze3t
278) Name: Post-Secondary Universe Survey 2010 - Directory information  ID: uc4u-xdrd
279) Name: Post-Secondary Universe Survey 2010 - Educational offerings and athletic associations  ID: 5uik-y7st
280) Name: Post-Secondary Universe Survey 2010 - Student charges by program (vocational programs)  ID: tcb6-vjfn
281) Name: Post-Secondary Universe Survey 2010 - Student charges for academic year programs  ID: wgh7-hitc
282) Name: Primary Election Precinct Results 2012  ID: dmak-5fr2
283) Name: Primary Election Summary Results 2012  ID: gaj3-6934
284) Name: Profiles For Hawaii State and County Candidates  ID: 9ewi-sbvu
285) Name: Promise Neighborhood 2010 Applications  ID: tx6j-n43f
286) Name: Promise Neighborhoods 2011 Applications  ID: v8dy-34yh
287) Name: Promise Neighborhoods 2011 Grantees  ID: 7tzs-hvnp
288) Name: Public Charging Stations in Hawaii  ID: 95x5-qrxh
289) Name: Public Elementary/Secondary School Universe Survey 2009-10  ID: school
290) Name: Public Health Nursing Listing  ID: x8h7-p5cj
291) Name: Ready to Learn 2010 Applicants  ID: xtr2-xtwh
292) Name: Report Card 1:  Overall Hawaii Visitor Numbers  ID: puxz-9rab
293) Name: Report Card 2.1a VSAT Recommend Statewide By MMA  ID: 787x-dmw4
294) Name: Report Card 2.1b VSAT Recommend Oahu By MMA  ID: ajhw-3huu
295) Name: Report Card 2.1c VSAT Recommend Maui By MMA  ID: 2g7t-6bmg
296) Name: Report Card 2.1e VSAT Recommend Lanai By MMA  ID: uu3p-zrur
297) Name: Report Card 2.1f VSAT Recommend Kauai By MMA  ID: 525d-apk2
298) Name: Report Card 2.1g VSAT Recommend Big Island By MMA  ID: 8v3f-iwvf
299) Name: Report Card 2.2a VSAT Return Statewide By MMA  ID: cwzq-rpan
300) Name: Report Card 2.3a VSAT Expectations Statewide By MMA  ID: 7n2q-gb7g
301) Name: Report Card 2b VSAT Overall Satisfaction Oahu By MMA  ID: j7f6-dpfq
302) Name: Report Card 2c VSAT Overall Satisfaction Maui By MMA  ID: 7rff-hkaj
303) Name: Report Card 2d VSAT Overall Satisfaction Molokai By MMA  ID: 3exa-uvbq
304) Name: Report Card 2e VSAT Overall Satisfaction Lanai By MMA  ID: wyyg-zvvt
305) Name: Report Card 2f VSAT Overall Satisfaction Kauai By MMA  ID: mvkv-3dke
306) Name: Report Card 2g VSAT Overall Satisfaction Hawaii Island By MMA  ID: qqa6-5vvy
307) Name: Report Card 3a Resident Sentiment Benefits  ID: i58n-7utq
308) Name: Report Card 3b Resident Sentiment Tourism for Family  ID: 3nqr-pbqh
309) Name: Report Card 3c Resident Sentiment Island Economy  ID: xrap-ydyp
310) Name: Report Card 3d Resident Sentiment Island Expense Locals  ID: jxj3-wzqf
311) Name: Report Card 3e Resident Sentiment Quality of Life  ID: asy7-es7y
312) Name: Report Card 3f Resident Sentiment Govt Promote  ID: mjna-b9qt
313) Name: Report Card 3g Resident Sentiment Jobs  ID: 3nah-v3qi
314) Name: Report Card 3h Resident Sentiment Treatment  ID: sudc-h239
315) Name: Report Card 3i Resident Sentiment Resources  ID: 69kz-wks8
316) Name: Report Card 4a Tax Visitor Expenditures  ID: jaz3-xs6b
317) Name: Report Card 4b Tax Tax Revenues From Visitor Expenditures  ID: nit8-gtva
318) Name: Report Card 4c Tax TAT  ID: qs2i-nbst
319) Name: Rural Health Clinics  ID: map3-5ue5
320) Name: SEALS OF QUALITY  ID: usck-9d9m
321) Name: SOI County-to-County Inflow Migration Data, 2004-2010  ID: qjy6-p5ad
322) Name: SOI County-to-County Outflow Migration Data, 2004-2010  ID: ixnw-g23j
323) Name: STD HIV Clinic  ID: gbu4-vtbs
324) Name: Sample OIP Master UIPA Records Request Log For All Agencies  ID: emfc-dtj9
325) Name: School Improvement 2010 Grants  ID: tft7-e3rz
326) Name: Second In The Nation Cumulative Installed Photovoltaic Capacity Per Capita (Source: Interstate Renewable Energy Council)  ID: bkbb-h3r6
327) Name: September 2012 Encumbrances  ID: 8st4-pkf9
328) Name: Settlement And Status Conferences Held ( RSN 39974)  ID: kqr4-b9tu
329) Name: Seventh in Nation Annual PV Installations (Source: Solar Energy Industries Association)  ID: ru9g-mapp
330) Name: Skilled Nursing Care Facilities  ID: 67hh-8zm9
331) Name: Slideshow Content  ID: 7dae-bjqc
332) Name: Solar- Related Construction Expenditures As A Percent Of Total Expenditures (Source: DBEDT)  ID: 7cps-5y5m
333) Name: State Civil Defense Hurricane Shelters  ID: vae6-r73i
334) Name: State Tax Revenue On International Study  ID: 6c5h-urdb
335) Name: State of Hawaii Elected Officials  ID: m6cf-4bb7
336) Name: State of Hawaii Open Data growth  ID: berr-farz
337) Name: Statewide Births, Deaths, Marriages, Civil Unions 2012  ID: bhtq-x545
338) Name: Statewide Food Est List11-2011  ID: 9ekn-r3cm
339) Name: Statewide LEED Certified Buildings  ID: 9rkm-2zvu
340) Name: System for Tracking and Administering Real-property (STAR) Inventory Buildings  ID: 843a-3ptd
341) Name: TAX 12 2012  Liquid Fuel Collections  ID: 36ik-4uk9
342) Name: TAX 12 2012 Liquid Fuel Allocations  ID: cbix-g738
343) Name: TAX 12-2012 LIQUID FUEL RATE SCHEDULE  ID: ap2e-c6eb
344) Name: TAX 12-2012 Liquor Collections And Permits  ID: c44e-iar7
345) Name: TAX 12-2012 Tobacco Tax Collections  ID: 42id-b4fw
346) Name: TSCA Inventory  ID: cq6u-d4uv
347) Name: Table 1.06 RESIDENT POPULATION, BY COUNTY 1990 TO 2011 (as Of July 1)  ID: hnpb-2rfi
348) Name: Table 1.09 DE FACTO POPULATION, BY COUNTY  1990 TO 2011 (as Of July 1)  ID: r7rd-74na
349) Name: Table 10.03 ACTIVE DUTY PERSONNEL, BY SERVICE 1953 TO 2011  ID: 6c7h-e33a
350) Name: Table 10: Cumulative Sanitary Surveys of Drinking Water Systems  ID: x38n-w8un
351) Name: Table 11.11 SOCIAL SECURITY BENEFICIARIES AND BENEFITS PAID 1991 TO 2010  ID: gtc6-4in2
352) Name: Table 11: Total Underground Injection Control (UIC) Permits  ID: deaj-mj5i
353) Name: Table 12.26 AVERAGE ANNUAL WAGE  IN CURRENT AND CONSTANT DOLLARS  1969 TO 2010  ID: e7p8-6b2a
354) Name: Table 12: Wastewater Treatment Plant Operations & Compliance  ID: at3v-ejzj
355) Name: Table 13.02 GROSS DOMESTIC PRODUCT, TOTAL AND PER CAPITA AND RESIDENT  ID: khmp-yavi
356) Name: Table 13.06 TOTAL AND PER CAPITA PERSONAL INCOME FOR THE UNITED STATES AND HAWAII 1969 TO 2011  ID: 5gja-rp2f
357) Name: Table 13: Wastewater Recycled  ID: 56dm-4idp
358) Name: Table 14.02 CONSUMER PRICE INDEX, FOR ALL URBAN CONSUMERS ( CPI- U), ALL ITEMS, FOR HONOLULU AND UNITED STATES  1940 TO 2011  ID: 4qc6-bjzm
359) Name: Table 14: Toxic Release Inventory (TRI) (in pounds)  ID: jhq5-pd3u
360) Name: Table 15: Oil and Chemical Releases  ID: yqmp-94ap
361) Name: Table 16: Solid Waste Generated Per Person (Pounds)  ID: eex2-n8qt
362) Name: Table 17.03 CONSUMPTION OF ENERGY BY END- USE SECTOR 1960 TO 2009  ID: usfi-mive
363) Name: Table 17.05 PRIMARY ENERGY CONSUMPTION, BY SOURCE  1992 TO 2010  ID: 7rq6-y7pf
364) Name: Table 17: Solid Waste Recycled (in tons)  ID: v48g-wbhi
365) Name: Table 18.07  MOTOR VEHICLES REGISTERED, BY COUNTY 1995 TO 2011  ID: jbez-8d6q
366) Name: Table 18.25 PUBLIC TRANSIT, FOR OAHU  1993 TO 2011  ID: 88uj-hez9
367) Name: Table 18: Leaking Underground Storage Tanks  ID: 5xci-hiqu
368) Name: Table 19: Hazardous Waste Generated  ID: h44e-tzy6
369) Name: Table 21.25 STATE GOVERNMENT CAPITAL IMPROVEMENT PROJECT EXPENDITURES  1990 TO 2011  ID: dyvi-h84f
370) Name: Table 23.34 VISITOR ACCOMMODATIONS, BY COUNTY  1975 TO 2011 (number Of Units)  ID: w6i2-ivxn
371) Name: Table 2: Ambient Levels of Airborne Particulates (PM) in Honolulu  ID: fn9b-s9c4
372) Name: Table 3.14 HAWAII STATE HIGH SCHOOL GRADUATES BY PUBLIC AND PRIVATE HIGH SCHOOL  ID: bvnw-4za7
373) Name: Table 3.22 HEADCOUNT ENROLLMENT AT THE UNIVERSITY OF HAWAII, BY CAMPUS  FALL 1997 TO 2011  ID: rjsa-twkk
374) Name: Table 5: Ambient Levels of Carbon Monoxide (CO) in Honolulu  ID: 5abm-p3au
375) Name: Table 6: Number of Hawaiian Coastal Waters by Island (2006)  ID: crh9-d7dx
376) Name: Table 7.03 VISITOR ARRIVALS AND AVERAGE DAILY VISITOR CENSUS 1966 TO 2011  ID: b587-guv7
377) Name: Table 7: Number of Hawaiian Perennial Streams by Island  ID: wr45-43y4
378) Name: Table 9.51 FEDERAL EXPENDITURES IN HAWAII, BY TYPE  1983 TO 2010  ID: hb24-hmx9
379) Name: Table 9: Percentage of Population served Safe Drinking Water  ID: h53f-wetv
380) Name: Table A1: Actual and Forecast of Key Economic Indicators for Hawaii: 2010 TO 2015  ID: h4a4-8vsd
381) Name: Tax Returns Processed  ID: xwuk-s2i8
382) Name: Tax Year 2007 County Income Data  ID: wvps-imhx
383) Name: Teaching American History 2010 Applicants  ID: fwe6-iczz
384) Name: Teaching American History 2010 Grantees  ID: 7ckp-dax8
385) Name: Templates  ID: templates
386) Name: Test-Dailypassenger Total  ID: p2pw-yyri
387) Name: Third In Nation Clean Economy Job Growth (Source: Brookings Institute)  ID: qb5w-vky4
388) Name: Third in Nation Solar Installations (Source: Environment America Research & Policy Center)  ID: c3hy-v46b
389) Name: Time to Hire GSA employees  ID: 2xzh-tft9
390) Name: Top 10 Source Countries Of International Undergraduate Student In The US 2012  ID: dmkk-8tma
391) Name: Top 50 Employers - Hawaii County  ID: gphu-34y5
392) Name: Top 50 Employers - Honolulu County  ID: jkm3-epq4
393) Name: Top 50 Employers - Maui County  ID: 9i8q-bgfy
394) Name: Toxics Release Inventory Chemicals by Groupings  ID: pwnn-pm3f
395) Name: Trials and Hearings De Novo Held ( RSN 39975)  ID: rd53-cm5u
396) Name: U.S. Overseas Loans and Grants (Greenbook)  ID: 668u-5wrc
397) Name: USAID Development Credit Authority Guarantee Data: Loan Transactions  ID: 7swc-ittd
398) Name: USAID Development Credit Authority Guarantee Data: Utilization and Claims  ID: atqm-5nw2
399) Name: Unemployment Weeks Claimed 2013  ID: uvuu-rsxq
400) Name: Uniformed Voting Assistance Officers 2008 Post Election Survey  ID: q7ez-fzdd
401) Name: University Of Hawaii - Degrees Awarded By Major, CIP, And Hawaiian Legacy  ID: 7bfs-svqv
402) Name: University Of Hawaii - Enrollment By Zipcode  ID: wkcq-pipq
403) Name: University Of Hawaii - Enrollment Demographics  ID: fkt2-a2fc
404) Name: Unpaid Expenditures For Hawaii Noncandidate Committees From January 1, 2008 Through June 30, 2013  ID: dq35-6ks5
405) Name: Unpaid Expenditures For Hawaii State and County Candidates From November 8, 2006 Through June 30, 2013  ID: rrkr-p5kv
406) Name: Veterans Burial Sites  ID: 9awu-hy98
407) Name: WC2011 ODI  ID: 4va6-9e4c
408) Name: WC2012 ODI  ID: anqz-y43n
409) Name: WTI Barrel of Oil Future Prices  ID: jzyk-q3tp
410) Name: White House Visitor Records Requests  ID: white-house-visitor-records
 => nil
</pre>


# LICENSE

I'm using the [WTFPL](http://www.wtfpl.net "WTF Public License") for now. 

Copyright © 2013 Pas de Chocolat, LLC.
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

This program is free software. It comes without any warranty, to
* the extent permitted by applicable law. You can redistribute it
* and/or modify it under the terms of the Do What The Fuck You Want
* To Public License, Version 2, as published by Sam Hocevar. See
* http://www.wtfpl.net/ for more details.