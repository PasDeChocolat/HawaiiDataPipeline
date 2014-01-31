This is the Hawaii Data Pipeline tool.  It's the fastest way to get all the Hawaii Open Data into Ruby (or JSON).

Read the first of two or three tutorials here:
* [Introducing the Hawaii Data Pipeline](http://pasdechocolat.com/2013/04/06/introducing-the-hawaii-data-pipeline/) - An introduction to this tool, and how to get started.
* [The Pipeline Works or Honolulu Too](http://pasdechocolat.com/2013/04/07/pipeline-for-honolulu-too/) - The tool also works for City of Honolulu data too, find out how to switch datasets.
* [Using D3.js in Hawaii](http://pasdechocolat.com/2013/04/08/using-d3-in-hawaii/) - D3 is a great tool for making data visualizations. This tutorial teaches you how to mix D3 with Hawaii Open Data.
* [Mapping Hawaii](http://pasdechocolat.com/2013/05/03/mapping-hawaii/) - Find out how to create your own custom SVG maps of Hawaii. You'll start with open source shapefiles and travel through TopoJSON, finally ending up with D3 plots of your points of interest.

## Requirements

* Ruby version >= 1.9 (for the new hash literal syntax)
* (Ruby 2.1.0 preferred, because.)
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

#### Note: This seems to be broken. The Socrata dataset is no longer available as a "resource".
Try using the [web interface](https://data.honolulu.gov/dataset/Data-Catalog/a3ah-kpkr) instead.

<pre>
client.set_dataset_type :state
client.list
 => ...
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
15) Name: 2011 IDEA Part B Personnel  ID: u75y-q5cg
16) Name: 2011 Visitor Plant Inventory Hawaii  ID: rjmg-cpq7
17) Name: 2011-2012 IDEA Part B Assessment  ID: abwk-havv
18) Name: 2011-2012 IDEA Part B Exiting  ID: 7mdz-8ya4
19) Name: 2011-2012 IDEA Part C Dispute Resolution  ID: bbvq-pq5r
20) Name: 2011-2012 IDEA Part C Exiting  ID: 2aie-rc7n
21) Name: 2012 IDEA Part B Child Count and Educational Environments  ID: 5t72-4535
22) Name: 2012 IDEA Part C Child Count and Settings  ID: dg4k-psxe
23) Name: 2012 Instructional Letters  ID: qpxs-gtjv
24) Name: 2013 CIP Encumbrances  ID: p6rw-tx3z
25) Name: 2013 State Holidays  ID: epj5-jxdm
26) Name: 20130423 ERP STAFF AND INTERESTED PARTIES  ID: 8pbp-ehn6
27) Name: 2014 State Holidays  ID: rcfm-5fv2
28) Name: AAA Fuel Prices  ID: dqp6-3idi
29) Name: Ability To Speak English By Age  ID: ri9m-brxc
30) Name: Ability To Speak English By Gender  ID: y2i2-mgg7
31) Name: Ability To Speak English By Language  ID: 8jzv-99pp
32) Name: Ability To Speak English By Marital Status  ID: 6jpf-s9b3
33) Name: Ability To Speak English By Nativity  ID: u5ff-xh5k
34) Name: Ability To Speak English By Race  ID: avad-trha
35) Name: Ability To Speak English By Total Income  ID: wwsw-d6qv
36) Name: Achievement Results for State Assessments in Mathematics:  School Year 2008-09  ID: jie4-w22m
37) Name: Achievement Results for State Assessments in Mathematics:  School Year 2009-10  ID: hhtw-4eb7
38) Name: Achievement Results for State Assessments in Mathematics:  School Year 2010-11  ID: r3ix-z65i
39) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2008-09  ID: mvz4-m3zh
40) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2009-10  ID: s5rp-twp9
41) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2010-11  ID: 6qru-yfc5
42) Name: Adjusted Cohort Graduation Rates at the school level: School Year 2010-11  ID: m5pw-2ea9
43) Name: Adult Day Health Center facilities  ID: kahi-xnwd
44) Name: Adult Residential Care Home LISTING  ID: e7u9-uyxu
45) Name: Alcohol and Drug Abuse Prevention Services  ID: 2dr7-mwnn
46) Name: Alt Energy Station Data  ID: 36sn-6y6i
47) Name: Ambulatory Surgical Centers  ID: h965-zk9w
48) Name: Annual Production Figures of United States Currency  ID: ym8u-jtw3
49) Name: Assisted Living Facilities Listing  ID: iqpn-unzm
50) Name: Bills Passed 2012  ID: 86eu-zw2n
51) Name: Bills That Passed 2013 Legislature  ID: pkba-543m
52) Name: Birth Rate, State Of Hawaii 1900 - 2011  ID: padw-q7ep
53) Name: Blog Posts  ID: 53b5-749p
54) Name: Budget Table: J2 (Other Current Expenses)  ID: qp7g-996d
55) Name: Budget Table: J3 (Equipment)  ID: 8umu-rtrb
56) Name: Budget Table: J4 (Motor Vehicles)  ID: htsw-v9h2
57) Name: Budget Table: K2 (Other Current Expenses: Leasing)  ID: ac7w-gtwf
58) Name: CIP 2011-2012  ID: pmbr-njwn
59) Name: CIP Encumberances June 2012  ID: aybr-r7va
60) Name: CIP Expenditures  ID: 54sf-nz6w
61) Name: Campaign Contributions Made To Candidates By Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2013  ID: 6huc-dcuw
62) Name: Campaign Contributions Received By Hawaii State and County Candidates From November 8, 2006 Through December 31, 2013  ID: jexd-xbcg
63) Name: Cash and Payments Management Data  ID: w9zu-5ne2
64) Name: Catalog of Federal Domestic Assistance (CFDA) (Old) (Old) (Old) (Old)  ID: mwm2-x6y4
65) Name: Category Information  ID: yv27-ghxi
66) Name: Category Stories  ID: p46r-d2ir
67) Name: Central Contractor Registration (CCR) FOIA Extract  ID: 3hqn-qzh6
68) Name: Civil Unions YTD 2012  ID: jjmh-uh4q
69) Name: Class Specification And Minimum Qualification  ID: b6h2-ri5e
70) Name: Connector Market Place Assisters  ID: nami-pcmh
71) Name: Contributions Received By Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2013  ID: rajm-32md
72) Name: Current TRI Chemical List  ID: gjp3-95wf
73) Name: DBEDT Average Annual Regular Gasoline Price Hawaii Vs U. S. 2006-2010  ID: fsqf-xf57
74) Name: DBEDT Average Monthly Regular Gasoline Price Hawaii Vs U. S. 2006-2010  ID: 9zb8-378h
75) Name: DBEDT Clean Economy Job Growth 2003-2010  ID: 5fix-ixwc
76) Name: DBEDT Cost Of Electricity For State Agencies FY05- FY10  ID: igkv-isiz
77) Name: DBEDT Cost Of Electricity For State Agencies by Fiscal Year  ID: x7ms-76ef
78) Name: DBEDT Cumulative Installed Photovoltaic Capacity Per Capita  ID: t9ac-479g
79) Name: DBEDT Currently Proposed Renewable Energy Projects In Hawaii  ID: b8it-cxyb
80) Name: DBEDT Electricity Consumption By State Agencies FY05- FY10  ID: 64np-vcjy
81) Name: DBEDT Energy Savings Performance Contracting Per Capita  ID: vad7-tbnj
82) Name: DBEDT HECO Ranks Third In 2010 Annual Solar Watts Per Customer  ID: jyvh-hvkp
83) Name: DBEDT Hawaii Annual Electricity Consumption  ID: biet-37vh
84) Name: DBEDT Hawaii Annual Electricity Cost And Consumption 2006-2010  ID: dnwk-g44q
85) Name: DBEDT Hawaii Cumulative Hybrid And Electric Vehicles Registered 2000-2010  ID: wget-66q5
86) Name: DBEDT Hawaii De Facto Population By County 2000-2010  ID: i7pr-uy4x
87) Name: DBEDT Hawaii Electricity Consumption 1970-2010  ID: qs2r-yxun
88) Name: DBEDT Hawaii Energy Efficiency Improvements 2005-2010  ID: a7ub-k7sa
89) Name: DBEDT Hawaii Energy Star Buildings 2003-2011  ID: vd5c-qe52
90) Name: DBEDT Hawaii Fossil Fuel Consumption And Expenditures 1970-2009  ID: 2u2g-c52b
91) Name: DBEDT Hawaii Nominal Gross Domestic Product 2000-2010  ID: s3qd-f86n
92) Name: DBEDT Hawaii Renewable Energy Generation 2005-2010  ID: vvr4-p4an
93) Name: DBEDT Hawaii State Agencies Electricity Consumption And Cost FY05- FY10  ID: bubj-tpbw
94) Name: DBEDT Hawaii Utility Companies Rank Among The Top  ID: i2tt-ek6x
95) Name: DBEDT Hawaii Utility Companies Rank Among The Top In Cumulative Solar Watts Per Customer  ID: kbgq-sdh2
96) Name: DBEDT Hawaii Vehicle Miles Traveled 1990-2010  ID: 894w-927z
97) Name: DBEDT Hawaii's Clean Economy Job Growth  ID: d3e2-v3mh
98) Name: DBEDT New Distributed Renewable Energy Systems Installed In Hawaii Annually 2001-2010  ID: mp64-qiad
99) Name: DBEDT Pie Chart Of Electric Hybrid Fossil Cars  ID: hm88-midt
100) Name: DHHL General Leases  ID: i7f9-fj37
101) Name: DHHL Licenses  ID: vcvt-yznb
102) Name: DHHL Revocable Permits  ID: j5dq-nmjy
103) Name: DHHL Right Of Entry  ID: jpyg-5jmy
104) Name: DOH CAMHD  ID: m659-q5bd
105) Name: Data.gov Daily Visitor Statistics  ID: bmze-gihd
106) Name: Data.gov Dataset Monthly Download Trends  ID: vx25-4bgc
107) Name: Data.gov Datasets Download By Data Category  ID: hhjs-7smp
108) Name: Data.gov Datasets Uploaded by Agencies per month  ID: 7vpv-axhc
109) Name: Data.gov Datasets Uploaded by Agencies per month  ID: g5st-hnpb
110) Name: Data.gov Datasets Uploaded by Agencies per month May 2013 Onwards  ID: yiw6-6i4x
111) Name: Data.gov Federal Agency Participation  ID: aubg-mfc9
112) Name: Data.gov Federal Agency Participation May 2013 Onwards  ID: agtq-akrq
113) Name: Data.gov Monthly Page Views  ID: spus-5492
114) Name: Data.gov Monthly Visitor Statistics  ID: 9car-pxwp
115) Name: Data.gov Top 10 Visiting Countries  ID: czf7-qvqf
116) Name: Data.gov Top 10 Visiting States  ID: we7r-hu8x
117) Name: Death Rate, State Of Hawaii 1900 - 2011  ID: xa5e-sayp
118) Name: December 2012 Encumbrances  ID: 9j5e-h438
119) Name: Department Of  Public Safety Weekly Population Reports  ID: asqc-nq6a
120) Name: Department of  Public Safety Weekly Population Reports  ID: fu6a-2jaq
121) Name: Department of  Public Safety Weekly Population Reports  ID: q8ke-n6gw
122) Name: Department of Defense - State Civil Defense Emergency Siren Locations  ID: jety-j7dm
123) Name: Department of Defense Hawaii Air National Guard  ID: Enter a resource name
124) Name: Department of Defense Hawaii Army National Guard Facility Locations  ID: 9ms4-cvz7
125) Name: Department of Public Safety Bed Capacity 2013  ID: qv4n-m8rb
126) Name: Department of State Voting Assistance Officer 2008 Post Election Survey  ID: szft-5daq
127) Name: Dialysis Centers  ID: bcw9-zb3y
128) Name: Distinct agency names in geospatial metadata  ID: 6mq7-82cd
129) Name: Durable Assets For Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2013  ID: i778-my94
130) Name: Durable Assets For Hawaii State and County Candidates From November 8, 2006 Through December 31, 2013  ID: fmfj-bac2
131) Name: EPA Toxics Release Inventory Program  ID: wma8-v5fi
132) Name: Early Learning  ID: tnnx-zerc
133) Name: Election Periods for Hawaii Noncandidate Committees  ID: ngjc-id6g
134) Name: Electricity Prices: U.S. vs Hawaii  (Source: EIA)  ID: ya75-e6j8
135) Name: Enterprise Zone Enrollment  ID: nhut-yk4g
136) Name: Executive Orders from 1994 to 2012  ID: ps37-i6ce
137) Name: Expenditures Made By Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2013  ID: riiu-7d4b
138) Name: Expenditures Made By Hawaii State and County Candidates From November 8, 2006 Through December 31, 2013  ID: 3maa-4fgr
139) Name: Export-Import FY 2007 Applications  ID: b522-5988
140) Name: Export-Import FY 2007 Participants  ID: 94s7-8bc4
141) Name: Export-Import FY 2008 Applications  ID: x5yb-3m6g
142) Name: Export-Import FY 2008 Participants  ID: qmg4-28c7
143) Name: Export-Import FY 2009 Applications  ID: qjfq-7m95
144) Name: Export-Import FY 2009 Participants  ID: w4ju-iurc
145) Name: Export-Import FY 2010 Applications  ID: de9r-6tze
146) Name: Export-Import FY 2010 Participants  ID: xegi-46pm
147) Name: Export-Import FY 2011 Applications  ID: 7gs4-396b
148) Name: Export-Import FY 2011 Participants  ID: mdvf-68cr
149) Name: Export-Import FY 2012 Applications  ID: a84i-8kb5
150) Name: Export-Import FY 2012 Participants  ID: em83-2ywi
151) Name: Export-Import FY 2013 Applications  ID: jki6-u4jp
152) Name: Export-Import FY 2013 Participants  ID: yhdt-apb3
153) Name: FARA Records  ID: fara-registrations
154) Name: FAS Forecast Of Contracting Opportunities  ID: e6hw-q8rb
155) Name: FEC Candidates  ID: fec-candidate
156) Name: FEC Committees  ID: fec-committee
157) Name: FEC Contributions  ID: 4dkz-64bn
158) Name: FY 12 & FY 13 CIP Budget  ID: dkm3-39id
159) Name: FY 13 Operating Budget By Cost Element (w. SUB)  ID: pi3x-y834
160) Name: Family Guidance Centers  ID: vr34-rcsa
161) Name: Family Guidance Centers  ID: uv73-kg72
162) Name: Federal Acquisition Service Instructional Letter 2008  ID: uqka-e8rd
163) Name: Federal Acquisition Service Instructional Letter 2010  ID: in27-bzp2
164) Name: Federal Acquisition Service Instructional Letter 2011  ID: gxu5-zmjz
165) Name: Federal Acquisition Service Instructional Letter 2013  ID: izeh-2yt3
166) Name: Federal Advisory Committee Act (FACA) Committee Member List-1997  ID: fext-zxex
167) Name: Federal Advisory Committee Act (FACA) Committee Member List-1998  ID: zx26-9ui3
168) Name: Federal Advisory Committee Act (FACA) Committee Member List-1999  ID: 3ne8-smp5
169) Name: Federal Advisory Committee Act (FACA) Committee Member List-2000  ID: 9rrm-cghv
170) Name: Federal Advisory Committee Act (FACA) Committee Member List-2001  ID: tvsq-mxeu
171) Name: Federal Advisory Committee Act (FACA) Committee Member List-2002  ID: z8t4-b33c
172) Name: Federal Advisory Committee Act (FACA) Committee Member List-2003  ID: kxci-9zen
173) Name: Federal Advisory Committee Act (FACA) Committee Member List-2004  ID: uwfv-c5g3
174) Name: Federal Advisory Committee Act (FACA) Committee Member List-2005  ID: 7ji5-mpn9
175) Name: Federal Advisory Committee Act (FACA) Committee Member List-2006  ID: e2uu-kmyn
176) Name: Federal Advisory Committee Act (FACA) Committee Member List-2007  ID: 3wwp-fssc
177) Name: Federal Advisory Committee Act (FACA) Committee Member List-2008  ID: b348-risj
178) Name: Federal Cost of School Food Program Data  ID: ysmn-j7g2
179) Name: Federal Data Center Consolidation Initiative (FDCCI) Data Center Closings 2010-2014  ID: d5wm-4c37
180) Name: Federal Employees Living Overseas 2008 Post Election Survey  ID: mgvs-6quj
181) Name: Federal Executive Agency Internet Domains as of 01282014  ID: ku4m-7ynp
182) Name: First In Nation Energy Savings Performance Contracting Per Capita (Source: Energy Services Coalition)  ID: my42-pfm5
183) Name: Fiscal Year 2006 Employee & Survivor Annuitants by Geographic Distribution  ID: cbz3-q4aw
184) Name: Foreign Per Diem Rates by Location  ID: jf5a-mh6t
185) Name: Free Standing X-Ray Facility  ID: xpu9-ny5u
186) Name: Gasoline Prices: U.S. vs. Hawaii  (Source: DBEDT)  ID: f55i-85xa
187) Name: General Election 2010 Summary Results.csv  ID: 8bdn-x7b5
188) Name: General Election 2012 Results  ID: eze4-hq7j
189) Name: General Election 2012 Summary Results  ID: gvfi-8e84
190) Name: General Election Results 2010  ID: y7za-qz47
191) Name: Grand Traverse Overall Supply Air Monitoring  ID: v7h3-9e9g
192) Name: Green Jobs By Industry  ID: grte-hrwt
193) Name: GreenSun Hawaii  ID: 5pwd-w8pn
194) Name: HGBP Grocery Stores  ID: c9pg-qedp
195) Name: HGBP Restaurants  ID: tjzq-hkqa
196) Name: HGBP Retail Stores & Offices  ID: nwf4-25d5
197) Name: HGBP State Agencies  ID: srdf-fk5g
198) Name: HI Electricity Prices  ID: 74g9-vewt
199) Name: HI KWh Utility Supply 2008 - 2012  ID: raj6-dc7s
200) Name: Hawaii Annual Electricity Cost  ID: i7am-7q95
201) Name: Hawaii County Births, Deaths, Marriages, Civil Unions 2012  ID: q8kg-9myh
202) Name: Hawaii County TEFAP Agencies  ID: u2s9-2pv4
203) Name: Hawaii Directory Of Green Employers  ID: mq86-5ta6
204) Name: Hawaii EV Charging Stations 02072013  ID: hbhw-unm4
205) Name: Hawaii Farmer's Markets  ID: nqfm-3etr
206) Name: Hawaii International Study Direct Spending final  ID: c2xi-ug2r
207) Name: Hawaii International Study Direct Spending-2  ID: xtwj-zrh4
208) Name: Hawaii International Study Market Share Compare To US  ID: 22ij-z5fe
209) Name: Hawaii Public Electric Vehicle Charging Stations  ID: cizq-byyq
210) Name: Hawaii Public Schools  ID: 6r5m-ppsj
211) Name: Hawaii Renewable Energy Generation By Resource (Source: Hawaii Public Utilities Commission)  ID: ezj8-myxp
212) Name: Hawaii Renewable Energy Generation by Utility (Source: Hawaii Public Utilities Commission)  ID: rpbd-ypkv
213) Name: Hawaii State Ethics Commission's Lobbyist Registration Statements  ID: gdxe-t5ff
214) Name: Hawaii State Ethics Commission's Lobbyists' Expenditure Statements  ID: 667b-qk6q
215) Name: Hawaii State Ethics Commission's Organizations' Expenditure Statements  ID: mq8q-3qtk
216) Name: Hawaii State Ethics Commission's Public Disclosures  ID: 9cs6-et3n
217) Name: Hawaii Training Providers 2011  ID: 365y-wu3m
218) Name: Hawaii eGov Apps  ID: y552-5npg
219) Name: Hawaii's Electricity Production by Source (Source: EIA)  ID: it4c-kd85
220) Name: Hawaii's Registered Livestock Brands  ID: gqi6-9ts8
221) Name: Home Health Agencies  ID: 3ekp-jm2z
222) Name: Home Page Featured Story  ID: wy7w-tcd5
223) Name: Home Page Stories  ID: v2k9-msid
224) Name: Honolulu County Births, Deaths, Marriages, Civil Unions 2012  ID: bxc7-28ys
225) Name: Hospice Facilities  ID: c6z7-qg9b
226) Name: Hospitals in Hawaii  ID: rwns-g4bn
227) Name: Initial Conferences Held ( RSN 39973)  ID: yrmn-32dg
228) Name: Interactive Datasets on Data.gov  ID: 2hpy-4cgt
229) Name: International Students in Hawaii  ID: c3i5-z94w
230) Name: Inventory Reporting Information System (IRIS) Safety  ID: 3myt-pfx4
231) Name: Investing In Innovation 2010 Applications  ID: qk9j-ipa4
232) Name: Investing In Innovation 2011 Applications  ID: svh6-9cag
233) Name: Kaua'i Agricultural Good Neighbor Program RUP Use Reporting  ID: 9pud-c8q5
234) Name: Kauai County Births, Deaths, Marriages, Civil Unions 2012  ID: u2ph-i4am
235) Name: Kauai TEFAP Agencies  ID: 92m2-d339
236) Name: LEA Level Achievement Results for State Assessments in Reading/Language Arts: School Year 2008-09  ID: 7uc4-5tpi
237) Name: LEA Level Achievement Results for State Assessments in Reading/Language Arts: School Year 2011-2012  ID: ca67-g5i2
238) Name: Lead By Example Hawaii State Agencies Electricity Consumption  ID: xpcc-ct2d
239) Name: Leading Indicators for the School Improvement Grant Program - School Year 2010-11  ID: smu7-q9sm
240) Name: Libraries Annual Statistics Comparison 2010-2011  ID: utt5-rg7n
241) Name: Libraries Blind And Physically Handicapped Fiscal 2011  ID: nd3u-89v6
242) Name: Libraries Borrowers 1984 - 2011  ID: uzs2-uayh
243) Name: Libraries Circulation Activity 1984 - 2011  ID: ky64-e4mx
244) Name: Libraries Collection Statistics 2011  ID: acuw-fgkq
245) Name: Libraries Collections Statistics 2005-2011  ID: g4rv-58tp
246) Name: Libraries Computers Available  ID: tkwq-e4vi
247) Name: Libraries Expenditures FY2007 - FY2010  ID: cqxe-ukdd
248) Name: Libraries Holdings 1984 - 2011  ID: rdtc-xuie
249) Name: Libraries Holdings FY84 - FY12  ID: n84k-kyxx
250) Name: Libraries Hosted Programs FY2009 - FY2011  ID: 3af5-md85
251) Name: Libraries Internet Sessions By Year FY06 - FY11  ID: e85y-zk7s
252) Name: Libraries Material Inventory 2005 - 2012  ID: cip4-gcsk
253) Name: Libraries Outreach Programs FY2009 - FY2011  ID: ekm4-ugtg
254) Name: Libraries State Of Hawaii  ID: jx86-2vch
255) Name: Licensed Intermediate Care Facilities  ID: 3zrt-yrqs
256) Name: Licensed Pesticide Listing  ID: rzjk-9g6v
257) Name: Loans Received By Hawaii State and County Candidates From November 8, 2006 Through December 31, 2013  ID: yf4f-x3r4
258) Name: Lobbying Disclosure Reports  ID: congressional-lobbying
259) Name: Local Education Agency (School District) Universe Survey Data 2009-10  ID: t9x5-2xzp
260) Name: Local Election Official 2008 Post Election Survey  ID: bwb6-fcji
261) Name: Marine Casualty and Pollution Database - Facility Pollution for 2002-2013  ID: wxch-i4p2
262) Name: Marine Casualty and Pollution Database - Injury for 2002 - 2013  ID: atbs-jds5
263) Name: Marine Casualty and Pollution Database - Other Events for 2002 - 2013  ID: 9jm7-jmx8
264) Name: Marine Casualty and Pollution Database - Vessel 2002-2010  ID: 8gap-yij5
265) Name: Marine Casualty and Pollution Database - Vessel Events for 2002-2013  ID: vf29-pk33
266) Name: Marine Casualty and Pollution Database - Vessel Pollution for 2002-2013  ID: g66d-8aji
267) Name: Materials Discarded in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: 3g88-w2ag
268) Name: Materials Generated In The U. S. Municipal Waste Stream 1960 To 2011 (in tons)  ID: xsqu-pn48
269) Name: Materials Recovered In The U. S. Municipal Waste Stream 1960 To 2011 (in tons)  ID: xyr8-enn9
270) Name: Maui County Births, Deaths, Marriages, Civil Unions 2012  ID: rt4b-b8s5
271) Name: Maui County TEFAP Agencies  ID: ww8h-8rsi
272) Name: Med-QUEST Offices  ID: fek4-ym6q
273) Name: Messages  ID: gb78-jhh6
274) Name: Monthly Economic Indicators - State Of Hawaii  ID: f96m-3kf5
275) Name: Motions Hearings Held ( RSN 39976)  ID: c5n8-8cmk
276) Name: NSF Funding Rate History  ID: g5it-4uhm
277) Name: NSF GRFP Awardees And Honorable Mentions (2000-2012)  ID: hm25-zz27
278) Name: National Center for Education Statistics (NCES) -  Integrated Postsecondary Education Data System (IPEDS) - Institutional Characteristics - Directory Information - 2011  ID: IPEDS-HD2011
279) Name: National Center for Education Statistics (NCES) - Classification of Instructional Programs (CIP 2000)  ID: CIPCODE
280) Name: National Center for Education Statistics (NCES) - Common Core of Data (CCD) - Public Elementary/Secondary School Universe Survey Data (2010-11)  ID: NCES-CCD-SC102A
281) Name: National Center for Education Statistics (NCES) - Integrated Postsecondary Education Data System (IPEDS) - Awards/degrees Conferred by Program - 2011  ID: NCES-IPEDS-C2011_A
282) Name: National Center for Education Statistics (NCES) - State Education Data Profiles - Elementary & Secondary Education Characteristics - CCD: 2010-2011  ID: vi5x-f3ti
283) Name: National Center for Education Statistics (NCES) - State Education Data Profiles - Elementary & Secondary Education Finance - CCD: FY10 (2009-2010)  ID: f7u8-xypq
284) Name: National Center for Education Statistics (NCES) - State Education Data Profiles - National Assessment of Educational Progress - NAEP: 2002, 2007, 2009, 2011  ID: 7xjd-vnu6
285) Name: New Distributed Renewable Energy Systems Installed In Hawaii Annually  (Source: Hawaii Public Utilities Commission)  ID: y7ur-vi2p
286) Name: Non-federal employees living overseas 2008 Post Election Survey  ID: njp2-ckqg
287) Name: Non-resident Marriages 2012  ID: nu5e-s79u
288) Name: Number of Appeals ( RSN 39972)  ID: 6yqr-w4bm
289) Name: OAHU Food Establishments  ID: qkvm-skze
290) Name: OGE Travel Reports  ID: oge-travel-reports
291) Name: OIE-FAVN TEST RESULTS BY MICROCHIP - under construction with test data  ID: fhan-ym2j
292) Name: OIMT Spending Report to Legislature FY13-FY14  ID: fh6a-3v4q
293) Name: OIP Master UIPA Record Request Semiannual Log for FY 2014  ID: 3ehz-vfp2
294) Name: OIP Master UIPA Record Request Year-End Log For FY 2013  ID: 7dxn-jvme
295) Name: Oahu State Public Parking Lots  ID: tbyx-mr7t
296) Name: Oahu TEFAP Agencies  ID: e4jf-2nsz
297) Name: October 2012 Encumbrances  ID: avhv-dnmd
298) Name: Organ Procurement facilities  ID: 678g-isej
299) Name: Organizational Reports For Hawaii Noncandidate Committees  ID: i4e7-rcnc
300) Name: Organizational Reports For Hawaii State and County Candidates  ID: gkek-wbij
301) Name: Other Receipts For Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2013  ID: m822-j8iy
302) Name: Other Receipts For Hawaii State and County Candidates From November 8, 2006 Through December 31, 2013  ID: ue3d-efjr
303) Name: Outpatient Physical therapy locations  ID: 3gh2-6seg
304) Name: PC TSSB WKLY  ID: 4rpu-rhfz
305) Name: PSD Facility Addresses  ID: i6md-8nrq
306) Name: Passenger Counts  International and Domestic May 2013  ID: btiw-7vk4
307) Name: Passenger Counts May 2013  ID: k5s6-yfqg
308) Name: Per Diem Reimbursement Rates  ID: perdiem
309) Name: Post-Secondary Universe Survey 2009 - Student financial aid and net price: 2008-09 (revised on 07/12/2011)  ID: 4ibs-r6fv
310) Name: Post-Secondary Universe Survey 2010 - Awards/degrees conferred by program, award level, race/ethnicity, and gender  ID: fjce-ze3t
311) Name: Post-Secondary Universe Survey 2010 - Directory information  ID: uc4u-xdrd
312) Name: Post-Secondary Universe Survey 2010 - Educational offerings and athletic associations  ID: 5uik-y7st
313) Name: Post-Secondary Universe Survey 2010 - Student charges by program (vocational programs)  ID: tcb6-vjfn
314) Name: Post-Secondary Universe Survey 2010 - Student charges for academic year programs  ID: wgh7-hitc
315) Name: Primary Election Precinct Results 2012  ID: dmak-5fr2
316) Name: Primary Election Summary Results 2012  ID: gaj3-6934
317) Name: Products Discarded with Detail on Containers and Packaging in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: sw6p-hfd3
318) Name: Products Discarded with Detail on Durables in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: 23jb-cahg
319) Name: Products Discarded with Detail on Nondurables in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: 5fh7-ikkb
320) Name: Products Generated with Detail on Containers and Packaging in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: i9x3-k8wj
321) Name: Products Generated with Detail on Durables in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: mh35-t5e3
322) Name: Products Generated with Detail on Nondurables in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: kxy8-c4ky
323) Name: Products Recovered through Recycling and Composting with Detail on Containers and Packaging in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: xsme-tqdn
324) Name: Products Recovered through Recycling and Composting with Detail on Durables in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: k4jm-q6ib
325) Name: Products Recovered through Recycling and Composting with Detail on Nondurables in the U.S. Municipal Waste Stream, 1960 to 2011 (in tons)  ID: nbbh-y2qt
326) Name: Profile Pictures for Hawaii State and County Candidates  ID: ataf-eya8
327) Name: Profiles For Hawaii State and County Candidates  ID: 9ewi-sbvu
328) Name: Promise Neighborhood 2010 Applications  ID: tx6j-n43f
329) Name: Promise Neighborhoods 2011 Applications  ID: v8dy-34yh
330) Name: Promise Neighborhoods 2011 Grantees  ID: 7tzs-hvnp
331) Name: Public Charging Stations in Hawaii  ID: 95x5-qrxh
332) Name: Public Elementary/Secondary School Universe Survey 2009-10  ID: school
333) Name: Public Health Nursing Listing  ID: x8h7-p5cj
334) Name: Ready to Learn 2010 Applicants  ID: xtr2-xtwh
335) Name: Report Card 1:  Overall Hawaii Visitor Numbers  ID: puxz-9rab
336) Name: Report Card 2.1a VSAT Recommend Statewide By MMA  ID: 787x-dmw4
337) Name: Report Card 2.1b VSAT Recommend Oahu By MMA  ID: ajhw-3huu
338) Name: Report Card 2.1c VSAT Recommend Maui By MMA  ID: 2g7t-6bmg
339) Name: Report Card 2.1e VSAT Recommend Lanai By MMA  ID: uu3p-zrur
340) Name: Report Card 2.1f VSAT Recommend Kauai By MMA  ID: 525d-apk2
341) Name: Report Card 2.1g VSAT Recommend Big Island By MMA  ID: 8v3f-iwvf
342) Name: Report Card 2.2a VSAT Return Statewide By MMA  ID: cwzq-rpan
343) Name: Report Card 2.3a VSAT Expectations Statewide By MMA  ID: 7n2q-gb7g
344) Name: Report Card 2b VSAT Overall Satisfaction Oahu By MMA  ID: j7f6-dpfq
345) Name: Report Card 2c VSAT Overall Satisfaction Maui By MMA  ID: 7rff-hkaj
346) Name: Report Card 2d VSAT Overall Satisfaction Molokai By MMA  ID: 3exa-uvbq
347) Name: Report Card 2e VSAT Overall Satisfaction Lanai By MMA  ID: wyyg-zvvt
348) Name: Report Card 2f VSAT Overall Satisfaction Kauai By MMA  ID: mvkv-3dke
349) Name: Report Card 2g VSAT Overall Satisfaction Hawaii Island By MMA  ID: qqa6-5vvy
350) Name: Report Card 3a Resident Sentiment Benefits  ID: i58n-7utq
351) Name: Report Card 3b Resident Sentiment Tourism for Family  ID: 3nqr-pbqh
352) Name: Report Card 3c Resident Sentiment Island Economy  ID: xrap-ydyp
353) Name: Report Card 3d Resident Sentiment Island Expense Locals  ID: jxj3-wzqf
354) Name: Report Card 3e Resident Sentiment Quality of Life  ID: asy7-es7y
355) Name: Report Card 3f Resident Sentiment Govt Promote  ID: mjna-b9qt
356) Name: Report Card 3g Resident Sentiment Jobs  ID: 3nah-v3qi
357) Name: Report Card 3h Resident Sentiment Treatment  ID: sudc-h239
358) Name: Report Card 3i Resident Sentiment Resources  ID: 69kz-wks8
359) Name: Report Card 4a Tax Visitor Expenditures  ID: jaz3-xs6b
360) Name: Report Card 4b Tax Tax Revenues From Visitor Expenditures  ID: nit8-gtva
361) Name: Report Card 4c Tax TAT  ID: qs2i-nbst
362) Name: Roll-up By Location  ID: tdns-ndbu
363) Name: Rural Health Clinics  ID: map3-5ue5
364) Name: SEALS OF QUALITY  ID: usck-9d9m
365) Name: SOI County-to-County Inflow Migration Data, 2004-2010  ID: qjy6-p5ad
366) Name: SOI County-to-County Outflow Migration Data, 2004-2010  ID: ixnw-g23j
367) Name: STD HIV Clinic  ID: gbu4-vtbs
368) Name: Sample (Practice) OIP Master UIPA Records Request Log For All Agencies  ID: c4r6-wq6h
369) Name: School Improvement 2010 Grants  ID: tft7-e3rz
370) Name: Second In The Nation Grid-Connected Photovoltaic Cumulative Installed Capacity per Capita (Source: Interstate Renewable Energy Council)  ID: bkbb-h3r6
371) Name: Second in Nation United States Renewable Energy Attractiveness Indices (Source: Ernst & Young)  ID: kmx6-bnt4
372) Name: September 2012 Encumbrances  ID: 8st4-pkf9
373) Name: Settlement And Status Conferences Held ( RSN 39974)  ID: kqr4-b9tu
374) Name: Seventh in Nation Annual PV Installations (Source: Solar Energy Industries Association)  ID: ru9g-mapp
375) Name: Skilled Nursing Care Facilities  ID: 67hh-8zm9
376) Name: Slideshow Content  ID: 7dae-bjqc
377) Name: Solar- Related Construction Expenditures (based on expenditure)    (Source: DBEDT)  ID: 7cps-5y5m
378) Name: State Civil Defense Hurricane Shelters  ID: vae6-r73i
379) Name: State Tax Revenue On International Study  ID: 6c5h-urdb
380) Name: State of Hawaii Elected Officials  ID: m6cf-4bb7
381) Name: State of Hawaii Open Data growth  ID: berr-farz
382) Name: Statewide Births, Deaths, Marriages, Civil Unions 2012  ID: bhtq-x545
383) Name: Statewide Food Est List11-2011  ID: 9ekn-r3cm
384) Name: Statewide LEED Certified Buildings  ID: 9rkm-2zvu
385) Name: System for Tracking and Administering Real-property (STAR) Inventory Buildings  ID: 843a-3ptd
386) Name: TAX 12 2012  Liquid Fuel Collections  ID: 36ik-4uk9
387) Name: TAX 12 2012 Liquid Fuel Allocations  ID: cbix-g738
388) Name: TAX 12-2012 LIQUID FUEL RATE SCHEDULE  ID: ap2e-c6eb
389) Name: TAX 12-2012 Liquor Collections And Permits  ID: c44e-iar7
390) Name: TAX 12-2012 Tobacco Tax Collections  ID: 42id-b4fw
391) Name: TSCA Inventory  ID: cq6u-d4uv
392) Name: Table 1.06 RESIDENT POPULATION, BY COUNTY 2000 TO 2012 (as of July 1)  ID: hnpb-2rfi
393) Name: Table 1.09 DE FACTO POPULATION, BY COUNTY  1990 TO 2012 (as Of July 1)  ID: r7rd-74na
394) Name: Table 10.03 ACTIVE DUTY PERSONNEL, BY SERVICE 1953 TO 2012  ID: 6c7h-e33a
395) Name: Table 10: Cumulative Sanitary Surveys of Drinking Water Systems  ID: x38n-w8un
396) Name: Table 11.11 SOCIAL SECURITY BENEFICIARIES AND BENEFITS PAID 1991 TO 2011  ID: gtc6-4in2
397) Name: Table 11: Total Underground Injection Control (UIC) Permits  ID: deaj-mj5i
398) Name: Table 12.26 AVERAGE ANNUAL WAGE  IN CURRENT AND CONSTANT DOLLARS  1969 TO 2011  ID: e7p8-6b2a
399) Name: Table 12: Wastewater Treatment Plant Operations & Compliance  ID: at3v-ejzj
400) Name: Table 13.02 GROSS DOMESTIC PRODUCT, TOTAL AND PER CAPITA AND RESIDENT POPULATION 1963 TO 2012  ID: khmp-yavi
401) Name: Table 13.06 TOTAL AND PER CAPITA PERSONAL INCOME FOR THE UNITED STATES AND HAWAII 1969 TO 2012  ID: 5gja-rp2f
402) Name: Table 13: Wastewater Recycled  ID: 56dm-4idp
403) Name: Table 14.02 CONSUMER PRICE INDEX, FOR ALL URBAN CONSUMERS ( CPI- U), ALL ITEMS, FOR HONOLULU AND UNITED STATES  1940 TO 2012  ID: 4qc6-bjzm
404) Name: Table 14: Toxic Release Inventory (TRI) (in pounds)  ID: jhq5-pd3u
405) Name: Table 15: Oil and Chemical Releases  ID: yqmp-94ap
406) Name: Table 16: Solid Waste Generated Per Person (Pounds)  ID: eex2-n8qt
407) Name: Table 17.03 CONSUMPTION OF ENERGY BY END- USE SECTOR 1960 TO 2010  ID: usfi-mive
408) Name: Table 17.05 PRIMARY ENERGY CONSUMPTION, BY SOURCE  1992 TO 2011  ID: 7rq6-y7pf
409) Name: Table 17: Solid Waste Recycled (in tons)  ID: v48g-wbhi
410) Name: Table 18.07  MOTOR VEHICLES REGISTERED, BY COUNTY 1995 TO 2012  ID: jbez-8d6q
411) Name: Table 18.25 PUBLIC TRANSIT, FOR OAHU  1993 TO 2012  ID: 88uj-hez9
412) Name: Table 18: Leaking Underground Storage Tanks  ID: 5xci-hiqu
413) Name: Table 19: Hazardous Waste Generated  ID: h44e-tzy6
414) Name: Table 21.25 STATE GOVERNMENT CAPITAL IMPROVEMENT PROJECT EXPENDITURES  1990 TO 2012  ID: dyvi-h84f
415) Name: Table 23.34 VISITOR ACCOMMODATIONS, BY COUNTY  1975 TO 2012 (number Of Units)  ID: w6i2-ivxn
416) Name: Table 2: Ambient Levels of Airborne Particulates (PM) in Honolulu  ID: fn9b-s9c4
417) Name: Table 3.14 HAWAII STATE HIGH SCHOOL GRADUATES BY PUBLIC AND PRIVATE HIGH SCHOOL 1982 TO 2012  ID: bvnw-4za7
418) Name: Table 3.22 HEADCOUNT ENROLLMENT AT THE UNIVERSITY OF HAWAII, BY CAMPUS  FALL 1997 TO 2012  ID: rjsa-twkk
419) Name: Table 5: Ambient Levels of Carbon Monoxide (CO) in Honolulu  ID: 5abm-p3au
420) Name: Table 6: Number of Hawaiian Coastal Waters by Island (2006)  ID: crh9-d7dx
421) Name: Table 7.03 VISITOR ARRIVALS AND AVERAGE DAILY VISITOR CENSUS 1966 TO 2011  ID: b587-guv7
422) Name: Table 7: Number of Hawaiian Perennial Streams by Island  ID: wr45-43y4
423) Name: Table 9.51 FEDERAL EXPENDITURES IN HAWAII, BY TYPE  1983 TO 2010  ID: hb24-hmx9
424) Name: Table 9: Percentage of Population served Safe Drinking Water  ID: h53f-wetv
425) Name: Table A1: Actual and Forecast of Key Economic Indicators for Hawaii: 2010 TO 2015  ID: h4a4-8vsd
426) Name: Tax Returns Processed  ID: xwuk-s2i8
427) Name: Tax Year 2007 County Income Data  ID: wvps-imhx
428) Name: Teaching American History 2010 Applicants  ID: fwe6-iczz
429) Name: Teaching American History 2010 Grantees  ID: 7ckp-dax8
430) Name: Tenth in Nation U.S. Clean Tech Leadership Index (Source: Clean Edge)  ID: v4dp-e4kg
431) Name: Test-Dailypassenger Total  ID: p2pw-yyri
432) Name: Third in Nation Cumulative Solar Electricity Capacity per Capita (Source: Environment America Research & Policy Center)  ID: c3hy-v46b
433) Name: Time to Hire GSA employees  ID: 2xzh-tft9
434) Name: Top 10 Source Countries Of International Students in the US 2013  ID: ivqq-v23t
435) Name: Top 10 Source Countries Of International Undergraduate Student In The US 2012  ID: dmkk-8tma
436) Name: Top 50 Employers - Hawaii County  ID: gphu-34y5
437) Name: Top 50 Employers - Honolulu County  ID: jkm3-epq4
438) Name: Top 50 Employers - Kauai County  ID: metr-canm
439) Name: Top 50 Employers - Maui County  ID: 9i8q-bgfy
440) Name: Toxics Release Inventory Chemicals by Groupings  ID: pwnn-pm3f
441) Name: Trials and Hearings De Novo Held ( RSN 39975)  ID: rd53-cm5u
442) Name: U.S. Overseas Loans and Grants (Greenbook)  ID: 668u-5wrc
443) Name: UI Initial Claims 2009 To Present  ID: 5hca-9ii5
444) Name: UI WC2009 To Present ODI  ID: ps39-dra9
445) Name: UNEMPLOYMENT RATE - HAWAII County - Annual - Not Seasonally Adjusted  ID: hwpi-m9nj
446) Name: UNEMPLOYMENT RATE - HAWAII County - Monthly - Not Seasonally Adjusted  ID: fwib-3htg
447) Name: UNEMPLOYMENT RATE - HONOLULU - Annual - Not Seasonally Adjusted  ID: jgtk-zvs5
448) Name: UNEMPLOYMENT RATE - HONOLULU - Monthly - Not Seasonally Adjusted  ID: 8djr-dj7q
449) Name: UNEMPLOYMENT RATE - KAUAI County - Annual - Not Seasonally Adjusted  ID: axg8-fskj
450) Name: UNEMPLOYMENT RATE - KAUAI County - Monthly - Not Seasonally Adjusted  ID: cieb-g5na
451) Name: UNEMPLOYMENT RATE - MAUI County - Annual - Not Seasonally Adjusted  ID: gydz-g9uw
452) Name: UNEMPLOYMENT RATE - MAUI County - Monthly - Not Seasonally Adjusted  ID: xhzq-4bun
453) Name: UNEMPLOYMENT RATE - STATE OF HAWAII - Annual - Not Seasonally Adjusted  ID: ypfk-u8xg
454) Name: UNEMPLOYMENT RATE - STATE OF HAWAII - Monthly - Not Seasonally Adjusted  ID: skx5-9dam
455) Name: USAID Development Credit Authority Guarantee Data: Loan Transactions  ID: 7swc-ittd
456) Name: USAID Development Credit Authority Guarantee Data: Utilization and Claims  ID: atqm-5nw2
457) Name: Underlying Credit Ratings for DBF  ID: vtr3-vfpe
458) Name: Underlying Credit Ratings for DHHL  ID: wgsm-xpsg
459) Name: Underlying Credit Ratings for State of Hawaii  ID: eewi-qmq5
460) Name: Uniformed Voting Assistance Officers 2008 Post Election Survey  ID: q7ez-fzdd
461) Name: University Of Hawaii - Degrees Awarded By Major, CIP, And Hawaiian Legacy  ID: 7bfs-svqv
462) Name: University Of Hawaii - Enrollment By Zipcode  ID: wkcq-pipq
463) Name: University Of Hawaii - Enrollment Demographics  ID: fkt2-a2fc
464) Name: Unpaid Expenditures For Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2013  ID: dq35-6ks5
465) Name: Unpaid Expenditures For Hawaii State and County Candidates From November 8, 2006 Through December 31, 2013  ID: rrkr-p5kv
466) Name: Veterans Burial Sites  ID: 9awu-hy98
467) Name: WTI Barrel of Oil Future Prices  ID: jzyk-q3tp
468) Name: White House Visitor Records Requests  ID: white-house-visitor-records
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